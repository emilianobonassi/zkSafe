// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {IBaseVerifier} from "../interfaces/IBaseVerifier.sol";
import {HydraS2Verifier as HydraS2SnarkVerifier} from "@sismo-core/hydra-s2/HydraS2Verifier.sol";
import {ICommitmentMapperRegistry} from "../periphery/interfaces/ICommitmentMapperRegistry.sol";
import {IAvailableRootsRegistry} from "../periphery/interfaces/IAvailableRootsRegistry.sol";
import {Initializable} from "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import {HydraS2ProofData, HydraS2Lib, HydraS2ProofInput} from "./HydraS2Lib.sol";
import {IHydraS2Verifier} from "./IHydraS2Verifier.sol";
import {Auth, ClaimType, AuthType, Claim, ZkConnectProof, VerifiedAuth, VerifiedClaim} from "../libs/utils/Structs.sol";

contract HydraS2Verifier is IHydraS2Verifier, IBaseVerifier, HydraS2SnarkVerifier, Initializable {
  using HydraS2Lib for HydraS2ProofData;
  using HydraS2Lib for Auth;
  using HydraS2Lib for Claim;

  uint8 public constant IMPLEMENTATION_VERSION = 1;
  bytes32 public immutable HYDRA_S2_VERSION = "hydra-s2.1";
  // Registry storing the Commitment Mapper EdDSA Public key
  ICommitmentMapperRegistry public immutable COMMITMENT_MAPPER_REGISTRY;
  // Registry storing the Registry Tree Roots of the Attester's available ClaimData
  IAvailableRootsRegistry public immutable AVAILABLE_ROOTS_REGISTRY;

  constructor(address commitmentMapperRegistry, address availableRootsRegistry) {
    COMMITMENT_MAPPER_REGISTRY = ICommitmentMapperRegistry(commitmentMapperRegistry);
    AVAILABLE_ROOTS_REGISTRY = IAvailableRootsRegistry(availableRootsRegistry);
    initialize();
  }

  function initialize() public reinitializer(IMPLEMENTATION_VERSION) {}

  function verify(
    bytes16 appId,
    bytes16 namespace,
    ZkConnectProof memory zkConnectProof
  ) external view override returns (VerifiedAuth memory, VerifiedClaim memory, bytes memory) {
    // Verify the zkConnectProof version corresponds to the current verifier.
    if (zkConnectProof.provingScheme != HYDRA_S2_VERSION) {
      revert InvalidVersion(zkConnectProof.provingScheme);
    }

    Auth memory auth = zkConnectProof.auth;
    Claim memory claim = zkConnectProof.claim;
    bytes memory signedMessage = zkConnectProof.signedMessage;

    // Decode the snark proof from the zkConnectProof
    // This snark proof is specify to this proving scheme
    HydraS2ProofData memory snarkProof = abi.decode(zkConnectProof.proofData, (HydraS2ProofData));
    HydraS2ProofInput memory snarkInput = snarkProof._input();

    // Verify Claim, Auth and SignedMessage validity by checking corresponding
    // snarkProof public input
    VerifiedAuth memory verifiedAuth = _verifyAuthValidity(snarkInput, auth, appId);
    VerifiedClaim memory verifiedClaim = _verifyClaimValidity(snarkInput, claim, appId, namespace);
    _validateSignedMessageInput(snarkInput, signedMessage);

    // Check the snarkProof is valid
    _checkSnarkProof(snarkProof);

    return (verifiedAuth, verifiedClaim, signedMessage);
  }

  function _verifyClaimValidity(
    HydraS2ProofInput memory input,
    Claim memory claim,
    bytes16 appId,
    bytes16 namespace
  ) private view returns (VerifiedClaim memory) {
    if (claim.claimType == ClaimType.EMPTY) {
      VerifiedClaim memory emptyVerifiedClaim;
      return emptyVerifiedClaim;
    }

    // Check claim value validity
    if (input.claimValue != claim.value) {
      revert ClaimValueMismatch();
    }

    // Check requestIdentifier validity
    uint256 expectedRequestIdentifier = _encodeRequestIdentifier(
      claim.groupId,
      claim.groupTimestamp,
      appId,
      namespace
    );
    if (input.requestIdentifier != expectedRequestIdentifier) {
      revert RequestIdentifierMismatch(input.requestIdentifier, expectedRequestIdentifier);
    }

    // commitmentMapperPubKey
    uint256[2] memory commitmentMapperPubKey = COMMITMENT_MAPPER_REGISTRY.getEdDSAPubKey();
    if (
      input.commitmentMapperPubKey[0] != commitmentMapperPubKey[0] ||
      input.commitmentMapperPubKey[1] != commitmentMapperPubKey[1]
    ) {
      revert CommitmentMapperPubKeyMismatch(
        commitmentMapperPubKey[0],
        commitmentMapperPubKey[1],
        input.commitmentMapperPubKey[0],
        input.commitmentMapperPubKey[1]
      );
    }

    // sourceVerificationEnabled
    if (input.sourceVerificationEnabled == false) {
      revert SourceVerificationNotEnabled();
    }
    // isRootAvailable
    if (!AVAILABLE_ROOTS_REGISTRY.isRootAvailable(input.registryTreeRoot)) {
      revert RegistryRootNotAvailable(input.registryTreeRoot);
    }
    // accountsTreeValue
    uint256 groupSnapshotId = _encodeAccountsTreeValue(claim.groupId, claim.groupTimestamp);
    if (input.accountsTreeValue != groupSnapshotId) {
      revert AccountsTreeValueMismatch(input.accountsTreeValue, groupSnapshotId);
    }

    bool claimComparatorEQ = input.claimComparator == 1;
    bool isClaimTypeFromClaimEqualToEQ = claim.claimType == ClaimType.EQ;
    if (claimComparatorEQ != isClaimTypeFromClaimEqualToEQ) {
      revert ClaimTypeMismatch(input.claimComparator, uint256(claim.claimType));
    }

    VerifiedClaim({
      groupId: claim.groupId,
      groupTimestamp: claim.groupTimestamp,
      value: claim.value,
      claimType: claim.claimType,
      proofId: input.proofIdentifier,
      extraData: claim.extraData
    });
  }

  function _verifyAuthValidity(
    HydraS2ProofInput memory input,
    Auth memory auth,
    bytes16 appId
  ) private view returns (VerifiedAuth memory) {
    if (auth.authType == AuthType.EMPTY) {
      VerifiedAuth memory emptyVerifiedAuth;
      return emptyVerifiedAuth;
    }
    uint256 userId;
    if (auth.authType == AuthType.ANON) {
      // vaultNamespace validity
      bytes16 appIdFromProof = bytes16(uint128(input.vaultNamespace));
      if (appIdFromProof != bytes16(appId)) {
        revert VaultNamespaceMismatch(appIdFromProof, appId);
      }

      userId = input.vaultIdentifier;
    } else {
      if (input.destinationVerificationEnabled == false) {
        revert DestinationVerificationNotEnabled();
      }
      // commitmentMapperPubKey
      uint256[2] memory commitmentMapperPubKey = COMMITMENT_MAPPER_REGISTRY.getEdDSAPubKey();
      if (
        input.commitmentMapperPubKey[0] != commitmentMapperPubKey[0] ||
        input.commitmentMapperPubKey[1] != commitmentMapperPubKey[1]
      ) {
        revert CommitmentMapperPubKeyMismatch(
          commitmentMapperPubKey[0],
          commitmentMapperPubKey[1],
          input.commitmentMapperPubKey[0],
          input.commitmentMapperPubKey[1]
        );
      }

      userId = uint256(uint160(input.destinationIdentifier));
    }

    return
      VerifiedAuth({
        authType: auth.authType,
        anonMode: auth.anonMode,
        userId: userId,
        extraData: auth.extraData,
        proofId: 0
      });
  }

  function _validateSignedMessageInput(
    HydraS2ProofInput memory input,
    bytes memory signedMessage
  ) private view {
    // don't check extraData if signedMessage is empty
    if (signedMessage.length == 0) {
      return;
    }
    if (input.extraData != uint256(keccak256(signedMessage))) {
      revert InvalidExtraData(bytes32(input.extraData), keccak256(signedMessage));
    }
  }

  function _checkSnarkProof(HydraS2ProofData memory snarkProof) internal view {
    if (
      !verifyProof(snarkProof.proof.a, snarkProof.proof.b, snarkProof.proof.c, snarkProof.input)
    ) {
      revert InvalidProof();
    }
  }

  function _encodeRequestIdentifier(
    bytes16 groupId,
    bytes16 groupTimestamp,
    bytes16 appId,
    bytes16 namespace
  ) internal pure returns (uint256) {
    bytes32 groupSnapshotId = _encodeGroupSnapshotId(groupId, groupTimestamp);
    bytes32 serviceId = _encodeServiceId(appId, namespace);
    return
      uint256(keccak256(abi.encodePacked(serviceId, groupSnapshotId))) % HydraS2Lib.SNARK_FIELD;
  }

  function _encodeAccountsTreeValue(
    bytes16 groupId,
    bytes16 groupTimestamp
  ) internal pure returns (uint256) {
    return uint256(_encodeGroupSnapshotId(groupId, groupTimestamp)) % HydraS2Lib.SNARK_FIELD;
  }

  function _encodeGroupSnapshotId(
    bytes16 groupId,
    bytes16 groupTimestamp
  ) internal pure returns (bytes32) {
    return bytes32(abi.encodePacked(groupId, groupTimestamp));
  }

  function _encodeServiceId(bytes16 appId, bytes16 namespace) internal pure returns (bytes32) {
    return bytes32(abi.encodePacked(appId, namespace));
  }
}
