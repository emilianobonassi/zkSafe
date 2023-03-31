// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import "../utils/Structs.sol";
import {RequestBuilder} from "../utils/RequestBuilder.sol";
import {Context} from "../../../lib/openzeppelin-contracts/contracts/utils/Context.sol";
import {IZkConnectLib} from "./IZkConnectLib.sol";
import {IZkConnectVerifier} from "../../interfaces/IZkConnectVerifier.sol";
import {IAddressesProvider} from "../../periphery/interfaces/IAddressesProvider.sol";

contract ZkConnect is IZkConnectLib, Context {
  uint256 public constant ZK_CONNECT_LIB_VERSION = 2;

  IAddressesProvider public constant ADDRESSES_PROVIDER =
    IAddressesProvider(0x3340Ac0CaFB3ae34dDD53dba0d7344C1Cf3EFE05);

  IZkConnectVerifier internal _zkConnectVerifier;
  bytes16 public appId;

  constructor(bytes16 appIdentifier) {
    appId = appIdentifier;
    _zkConnectVerifier = IZkConnectVerifier(ADDRESSES_PROVIDER.get(string("zkConnectVerifier-v2")));
  }

  function verify(
    bytes memory responseBytes,
    Auth memory authRequest,
    Claim memory claimRequest,
    bytes memory messageSignatureRequest,
    bytes16 namespace
  ) internal returns (ZkConnectVerifiedResult memory) {
    ZkConnectResponse memory zkConnectResponse = abi.decode(responseBytes, (ZkConnectResponse));
    ZkConnectRequest memory zkConnectRequest = buildRequest(
      claimRequest,
      authRequest,
      messageSignatureRequest,
      namespace
    );
    return _zkConnectVerifier.verify(zkConnectResponse, zkConnectRequest);
  }

  function verify(
    bytes memory responseBytes,
    Auth memory authRequest,
    Claim memory claimRequest,
    bytes16 namespace
  ) internal returns (ZkConnectVerifiedResult memory) {
    ZkConnectResponse memory zkConnectResponse = abi.decode(responseBytes, (ZkConnectResponse));
    ZkConnectRequest memory zkConnectRequest = buildRequest(claimRequest, authRequest, namespace);
    return _zkConnectVerifier.verify(zkConnectResponse, zkConnectRequest);
  }

  function verify(
    bytes memory responseBytes,
    Auth memory authRequest,
    bytes memory messageSignatureRequest,
    bytes16 namespace
  ) internal returns (ZkConnectVerifiedResult memory) {
    ZkConnectResponse memory zkConnectResponse = abi.decode(responseBytes, (ZkConnectResponse));
    ZkConnectRequest memory zkConnectRequest = buildRequest(
      authRequest,
      messageSignatureRequest,
      namespace
    );
    return _zkConnectVerifier.verify(zkConnectResponse, zkConnectRequest);
  }

  function verify(
    bytes memory responseBytes,
    Claim memory claimRequest,
    bytes memory messageSignatureRequest,
    bytes16 namespace
  ) internal returns (ZkConnectVerifiedResult memory) {
    ZkConnectResponse memory zkConnectResponse = abi.decode(responseBytes, (ZkConnectResponse));
    ZkConnectRequest memory zkConnectRequest = buildRequest(
      claimRequest,
      messageSignatureRequest,
      namespace
    );
    return _zkConnectVerifier.verify(zkConnectResponse, zkConnectRequest);
  }

  function verify(
    bytes memory responseBytes,
    Auth memory authRequest,
    bytes16 namespace
  ) internal returns (ZkConnectVerifiedResult memory) {
    ZkConnectResponse memory zkConnectResponse = abi.decode(responseBytes, (ZkConnectResponse));
    ZkConnectRequest memory zkConnectRequest = buildRequest(authRequest, namespace);
    return _zkConnectVerifier.verify(zkConnectResponse, zkConnectRequest);
  }

  function verify(
    bytes memory responseBytes,
    Claim memory claimRequest,
    bytes16 namespace
  ) internal returns (ZkConnectVerifiedResult memory) {
    ZkConnectResponse memory zkConnectResponse = abi.decode(responseBytes, (ZkConnectResponse));
    ZkConnectRequest memory zkConnectRequest = buildRequest(claimRequest, namespace);
    return _zkConnectVerifier.verify(zkConnectResponse, zkConnectRequest);
  }

  function verify(
    bytes memory responseBytes,
    Auth memory authRequest,
    Claim memory claimRequest,
    bytes memory messageSignatureRequest
  ) internal returns (ZkConnectVerifiedResult memory) {
    ZkConnectResponse memory zkConnectResponse = abi.decode(responseBytes, (ZkConnectResponse));
    ZkConnectRequest memory zkConnectRequest = buildRequest(
      claimRequest,
      authRequest,
      messageSignatureRequest
    );
    return _zkConnectVerifier.verify(zkConnectResponse, zkConnectRequest);
  }

  function verify(
    bytes memory responseBytes,
    Auth memory authRequest,
    Claim memory claimRequest
  ) internal returns (ZkConnectVerifiedResult memory) {
    ZkConnectResponse memory zkConnectResponse = abi.decode(responseBytes, (ZkConnectResponse));
    ZkConnectRequest memory zkConnectRequest = buildRequest(claimRequest, authRequest);
    return _zkConnectVerifier.verify(zkConnectResponse, zkConnectRequest);
  }

  function verify(
    bytes memory responseBytes,
    Auth memory authRequest,
    bytes memory messageSignatureRequest
  ) internal returns (ZkConnectVerifiedResult memory) {
    ZkConnectResponse memory zkConnectResponse = abi.decode(responseBytes, (ZkConnectResponse));
    ZkConnectRequest memory zkConnectRequest = buildRequest(authRequest, messageSignatureRequest);
    return _zkConnectVerifier.verify(zkConnectResponse, zkConnectRequest);
  }

  function verify(
    bytes memory responseBytes,
    Claim memory claimRequest,
    bytes memory messageSignatureRequest
  ) internal returns (ZkConnectVerifiedResult memory) {
    ZkConnectResponse memory zkConnectResponse = abi.decode(responseBytes, (ZkConnectResponse));
    ZkConnectRequest memory zkConnectRequest = buildRequest(claimRequest, messageSignatureRequest);
    return _zkConnectVerifier.verify(zkConnectResponse, zkConnectRequest);
  }

  function verify(
    bytes memory responseBytes,
    Auth memory authRequest
  ) internal returns (ZkConnectVerifiedResult memory) {
    ZkConnectResponse memory zkConnectResponse = abi.decode(responseBytes, (ZkConnectResponse));
    ZkConnectRequest memory zkConnectRequest = buildRequest(authRequest);
    return _zkConnectVerifier.verify(zkConnectResponse, zkConnectRequest);
  }

  function verify(
    bytes memory responseBytes,
    Claim memory claimRequest
  ) internal returns (ZkConnectVerifiedResult memory) {
    ZkConnectResponse memory zkConnectResponse = abi.decode(responseBytes, (ZkConnectResponse));
    ZkConnectRequest memory zkConnectRequest = buildRequest(claimRequest);
    return _zkConnectVerifier.verify(zkConnectResponse, zkConnectRequest);
  }

  function verify(
    bytes memory responseBytes,
    ZkConnectRequest memory zkConnectRequest
  ) internal returns (ZkConnectVerifiedResult memory) {
    ZkConnectResponse memory zkConnectResponse = abi.decode(responseBytes, (ZkConnectResponse));
    return _zkConnectVerifier.verify(zkConnectResponse, zkConnectRequest);
  }

  function buildClaim(
    bytes16 groupId,
    bytes16 groupTimestamp,
    uint256 value,
    ClaimType claimType,
    bytes memory extraData
  ) internal pure returns (Claim memory) {
    return RequestBuilder.buildClaim(groupId, groupTimestamp, value, claimType, extraData);
  }

  function buildClaim(bytes16 groupId) internal pure returns (Claim memory) {
    return RequestBuilder.buildClaim(groupId);
  }

  function buildClaim(bytes16 groupId, bytes16 groupTimestamp) internal pure returns (Claim memory) {
    return RequestBuilder.buildClaim(groupId, groupTimestamp);
  }

  function buildClaim(bytes16 groupId, uint256 value) internal pure returns (Claim memory) {
    return RequestBuilder.buildClaim(groupId, value);
  }

  function buildClaim(bytes16 groupId, ClaimType claimType) internal pure returns (Claim memory) {
    return RequestBuilder.buildClaim(groupId, claimType);
  }

  function buildClaim(bytes16 groupId, bytes memory extraData) internal pure returns (Claim memory) {
    return RequestBuilder.buildClaim(groupId, extraData);
  }

  function buildClaim(
    bytes16 groupId,
    bytes16 groupTimestamp,
    uint256 value
  ) internal pure returns (Claim memory) {
    return RequestBuilder.buildClaim(groupId, groupTimestamp, value);
  }

  function buildClaim(
    bytes16 groupId,
    bytes16 groupTimestamp,
    ClaimType claimType
  ) internal pure returns (Claim memory) {
    return RequestBuilder.buildClaim(groupId, groupTimestamp, claimType);
  }

  function buildClaim(
    bytes16 groupId,
    bytes16 groupTimestamp,
    bytes memory extraData
  ) internal pure returns (Claim memory) {
    return RequestBuilder.buildClaim(groupId, groupTimestamp, extraData);
  }

  function buildClaim(
    bytes16 groupId,
    uint256 value,
    ClaimType claimType
  ) internal pure returns (Claim memory) {
    return RequestBuilder.buildClaim(groupId, value, claimType);
  }

  function buildClaim(
    bytes16 groupId,
    uint256 value,
    bytes memory extraData
  ) internal pure returns (Claim memory) {
    return RequestBuilder.buildClaim(groupId, value, extraData);
  }

  function buildClaim(
    bytes16 groupId,
    ClaimType claimType,
    bytes memory extraData
  ) internal pure returns (Claim memory) {
    return RequestBuilder.buildClaim(groupId, claimType, extraData);
  }

  function buildClaim(
    bytes16 groupId,
    bytes16 groupTimestamp,
    uint256 value,
    ClaimType claimType
  ) internal pure returns (Claim memory) {
    return RequestBuilder.buildClaim(groupId, groupTimestamp, value, claimType);
  }

  function buildClaim(
    bytes16 groupId,
    bytes16 groupTimestamp,
    uint256 value,
    bytes memory extraData
  ) internal pure returns (Claim memory) {
    return RequestBuilder.buildClaim(groupId, groupTimestamp, value, extraData);
  }

  function buildClaim(
    bytes16 groupId,
    bytes16 groupTimestamp,
    ClaimType claimType,
    bytes memory extraData
  ) internal pure returns (Claim memory) {
    return RequestBuilder.buildClaim(groupId, groupTimestamp, claimType, extraData);
  }

  function buildClaim(
    bytes16 groupId,
    uint256 value,
    ClaimType claimType,
    bytes memory extraData
  ) internal pure returns (Claim memory) {
    return RequestBuilder.buildClaim(groupId, value, claimType, extraData);
  }

  function buildAuth(
    AuthType authType,
    bool anonMode,
    uint256 userId,
    bytes memory extraData
  ) internal pure returns (Auth memory) {
    return RequestBuilder.buildAuth(authType, anonMode, userId, extraData);
  }

  function buildAuth(AuthType authType) internal pure returns (Auth memory) {
    return RequestBuilder.buildAuth(authType);
  }

  function buildAuth(AuthType authType, bool anonMode) internal pure returns (Auth memory) {
    return RequestBuilder.buildAuth(authType, anonMode);
  }

  function buildAuth(AuthType authType, uint256 userId) internal pure returns (Auth memory) {
    return RequestBuilder.buildAuth(authType, userId);
  }

  function buildAuth(AuthType authType, bytes memory extraData) internal pure returns (Auth memory) {
    return RequestBuilder.buildAuth(authType, extraData);
  }

  function buildAuth(
    AuthType authType,
    bool anonMode,
    uint256 userId
  ) internal pure returns (Auth memory) {
    return RequestBuilder.buildAuth(authType, anonMode, userId);
  }

  function buildAuth(
    AuthType authType,
    bool anonMode,
    bytes memory extraData
  ) internal pure returns (Auth memory) {
    return RequestBuilder.buildAuth(authType, anonMode, extraData);
  }

  function buildAuth(
    AuthType authType,
    uint256 userId,
    bytes memory extraData
  ) internal pure returns (Auth memory) {
    return RequestBuilder.buildAuth(authType, userId, extraData);
  }

  function buildRequest(
    Claim memory claimRequest,
    Auth memory authRequest,
    bytes memory messageSignatureRequest
  ) internal returns (ZkConnectRequest memory) {
    return RequestBuilder.buildRequest(claimRequest, authRequest, messageSignatureRequest, appId);
  }

  function buildRequest(
    Claim memory claimRequest,
    Auth memory authRequest
  ) internal returns (ZkConnectRequest memory) {
    return RequestBuilder.buildRequest(claimRequest, authRequest, appId);
  }

  function buildRequest(
    Claim memory claimRequest,
    bytes memory messageSignatureRequest
  ) internal returns (ZkConnectRequest memory) {
    return RequestBuilder.buildRequest(claimRequest, messageSignatureRequest, appId);
  }

  function buildRequest(
    Auth memory authRequest,
    bytes memory messageSignatureRequest
  ) internal returns (ZkConnectRequest memory) {
    return RequestBuilder.buildRequest(authRequest, messageSignatureRequest, appId);
  }

  function buildRequest(Claim memory claimRequest) internal returns (ZkConnectRequest memory) {
    return RequestBuilder.buildRequest(claimRequest, appId);
  }

  function buildRequest(Auth memory authRequest) internal returns (ZkConnectRequest memory) {
    return RequestBuilder.buildRequest(authRequest, appId);
  }

  function buildRequest(
    Claim memory claimRequest,
    Auth memory authRequest,
    bytes memory messageSignatureRequest,
    bytes16 namespace
  ) internal returns (ZkConnectRequest memory) {
    return
      RequestBuilder.buildRequest(
        claimRequest,
        authRequest,
        messageSignatureRequest,
        appId,
        namespace
      );
  }

  function buildRequest(
    Claim memory claimRequest,
    Auth memory authRequest,
    bytes16 namespace
  ) internal returns (ZkConnectRequest memory) {
    return RequestBuilder.buildRequest(claimRequest, authRequest, appId, namespace);
  }

  function buildRequest(
    Claim memory claimRequest,
    bytes memory messageSignatureRequest,
    bytes16 namespace
  ) internal returns (ZkConnectRequest memory) {
    return RequestBuilder.buildRequest(claimRequest, messageSignatureRequest, appId, namespace);
  }

  function buildRequest(
    Auth memory authRequest,
    bytes memory messageSignatureRequest,
    bytes16 namespace
  ) internal returns (ZkConnectRequest memory) {
    return RequestBuilder.buildRequest(authRequest, messageSignatureRequest, appId, namespace);
  }

  function buildRequest(
    Claim memory claimRequest,
    bytes16 namespace
  ) internal returns (ZkConnectRequest memory) {
    return RequestBuilder.buildRequest(claimRequest, appId, namespace);
  }

  function buildRequest(
    Auth memory authRequest,
    bytes16 namespace
  ) internal returns (ZkConnectRequest memory) {
    return RequestBuilder.buildRequest(authRequest, appId, namespace);
  }
}
