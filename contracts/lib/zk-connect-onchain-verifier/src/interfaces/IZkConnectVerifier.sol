// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../libs/utils/Structs.sol";

interface IZkConnectVerifier {
  ////Errors: Request/Response mismatch errors
  error VersionMismatch(bytes32 requestVersion, bytes32 responseVersion);
  error NamespaceMismatch(bytes16 requestNamespace, bytes16 responseNamespace);
  error AppIdMismatch(bytes16 requestAppId, bytes16 responseAppId);
  error MessageSignatureMismatch(bytes requestMessageSignature, bytes responseMessageSignature);
  // Auth mismatch errors
  error AuthTypeMismatch(AuthType requestAuthType, AuthType responseAuthType);
  error AuthAnonModeMismatch(bool requestAnonMode, bool responseAnonMode);
  error AuthUserIdMismatch(uint256 requestUserId, uint256 responseUserId);
  error AuthExtraDataMismatch(bytes requestExtraData, bytes responseExtraData);
  // Claim mismatch errors
  error ClaimTypeMismatch(ClaimType requestClaimType, ClaimType responseClaimType);
  error ClaimValueMismatch(uint256 requestClaimValue, uint256 responseClaimValue);
  error ClaimExtraDataMismatch(bytes requestExtraData, bytes responseExtraData);
  error ClaimGroupIdMismatch(bytes16 requestGroupId, bytes16 responseGroupId);
  error ClaimGroupTimestampMismatch(bytes16 requestGroupTimestamp, bytes16 responseGroupTimestamp);

  event VerifierSet(bytes32, address);

  function verify(
    ZkConnectResponse memory zkConnectResponse,
    ZkConnectRequest memory zkConnectRequest
  ) external returns (ZkConnectVerifiedResult memory);

  function ZK_CONNECT_VERSION() external view returns (bytes32);
}
