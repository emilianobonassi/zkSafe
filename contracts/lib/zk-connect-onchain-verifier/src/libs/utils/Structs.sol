// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.17;

struct ZkConnectRequest {
  bytes16 appId;
  bytes16 namespace;
  ZkConnectRequestContent content;
}

struct ZkConnectRequestContent {
  DataRequest[] dataRequests;
  LogicalOperator[] operators;
}

struct DataRequest {
  Auth authRequest;
  Claim claimRequest;
  bytes messageSignatureRequest;
}

struct Claim {
  bytes16 groupId;
  bytes16 groupTimestamp;
  uint256 value;
  ClaimType claimType;
  bytes extraData;
}

struct Auth {
  AuthType authType;
  bool anonMode;
  uint256 userId;
  bytes extraData;
}

enum ClaimType {
  EMPTY,
  GTE,
  GT,
  EQ,
  LT,
  LTE,
  USER_SELECT
}

enum AuthType {
  EMPTY,
  ANON,
  GITHUB,
  TWITTER,
  EVM_ACCOUNT
}

enum LogicalOperator {
  AND,
  OR
}

struct ZkConnectResponse {
  bytes16 appId;
  bytes16 namespace;
  bytes32 version;
  ZkConnectProof[] proofs;
}

struct ZkConnectProof {
  Claim claim;
  Auth auth;
  bytes signedMessage;
  bytes32 provingScheme;
  bytes proofData;
  bytes extraData;
}

struct ZkConnectVerifiedResult {
  bytes16 appId;
  bytes16 namespace;
  bytes32 version;
  VerifiedAuth[] verifiedAuths;
  VerifiedClaim[] verifiedClaims;
  bytes[] signedMessages;
}

struct VerifiedClaim {
  bytes16 groupId;
  bytes16 groupTimestamp;
  ClaimType claimType;
  uint256 value;
  bytes extraData;
  uint256 proofId;
}

struct VerifiedAuth {
  AuthType authType;
  bool anonMode;
  uint256 userId;
  bytes extraData;
  uint256 proofId;
}
