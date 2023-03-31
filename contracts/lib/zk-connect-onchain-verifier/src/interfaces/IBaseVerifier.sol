// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import {ZkConnectProof, VerifiedAuth, VerifiedClaim} from "../libs/utils/Structs.sol";

interface IBaseVerifier {
  function verify(
    bytes16 appId,
    bytes16 namespace,
    ZkConnectProof memory zkConnectProof
  ) external view returns (VerifiedAuth memory, VerifiedClaim memory, bytes memory);
}
