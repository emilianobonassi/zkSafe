// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.17;

import "src/libs/zk-connect/ZkConnectLib.sol";

contract ZkConnectTest is ZkConnect {

    constructor(
        bytes16 appId
    ) ZkConnect(appId) {}

    function buildClaimTest(bytes16 groupId) public pure returns (Claim memory) {
        return buildClaim(groupId);
    }

    function buildAuthTest(AuthType authType) public pure returns (Auth memory) {
        return buildAuth(authType);
    }

    function verifyTest(bytes memory zkConnectResponse, ZkConnectRequest memory zkConnectRequest) public returns (ZkConnectVerifiedResult memory) {
        return verify(zkConnectResponse, zkConnectRequest);
    }



}