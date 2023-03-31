// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./zkConnectModule.sol";

//@notice NOT SAFE, temporarily till a fix in the zkConnect prover
contract zkConnectDummyModule is zkConnectModule {
    constructor(address _safe, bytes16 _appId, bytes16 _groupId) zkConnectModule(_safe, _appId, _groupId) {}

    /// @dev Exec transaction
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
    ) public virtual override returns (bool success) {
        ZkConnectVerifiedResult memory zkConnectVerifiedResult = verify({
            responseBytes: zkConnectResponse,
            authRequest: buildAuth({ authType: AuthType.ANON }),
            claimRequest: buildClaim({ groupId: groupId }),
            //signing always 0 temporarily till a fix in the zkConnect prover
            messageSignatureRequest: abi.encode(uint256(0))
        });

        require(safe.execTransactionFromModule(to, value, data, operation), "Module transaction failed");

        return true;
    }
}
