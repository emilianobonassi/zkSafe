// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "zk-connect-onchain-verifier/src/libs/zk-connect/ZkConnectLib.sol";

contract Enum {
    enum Operation {
        Call,
        DelegateCall
    }
}

interface GnosisSafe {
    /// @dev Allows a Module to execute a Safe transaction without any further confirmations.
    /// @param to Destination address of module transaction.
    /// @param value Ether value of module transaction.
    /// @param data Data payload of module transaction.
    /// @param operation Operation type of module transaction.
    function execTransactionFromModule(
        address to,
        uint256 value,
        bytes calldata data,
        Enum.Operation operation
    ) external returns (bool success);
}

contract zkConnectModule is ZkConnect {
    bytes16 public groupId;
    GnosisSafe public safe;

    //TODO make proxyable w/ initializer
    constructor(address _safe, bytes16 _appId, bytes16 _groupId) ZkConnect(_appId) {
        safe = GnosisSafe(_safe);
        groupId = _groupId;
    }

    /// @dev Change group identifier
    /// @param _groupId group identifier to check the claim
    function setGroupId(bytes16 _groupId) public {
        require(msg.sender == address(safe), "!safe");
        groupId = _groupId;
    }

    /// @dev Exec tx using zkConnect proof
    /// @param to Destination address of module transaction
    /// @param value Ether value of module transaction
    /// @param data Data payload of module transaction
    /// @param operation Operation type of module transaction
    function execTransactionFromModule(
        address to,
        uint256 value,
        bytes calldata data,
        Enum.Operation operation,
        bytes memory zkConnectResponse
    ) public virtual returns (bool success) {
        //TODO: should use a nonce to avoid replay

        ZkConnectVerifiedResult memory zkConnectVerifiedResult = verify({
            responseBytes: zkConnectResponse,
            authRequest: buildAuth({ authType: AuthType.ANON }),
            claimRequest: buildClaim({ groupId: groupId }),
            messageSignatureRequest: abi.encode(to, value, data, operation)
        });

        require(safe.execTransactionFromModule(to, value, data, operation), "Module transaction failed");

        return true;
    }
}
