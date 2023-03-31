// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Script.sol";
import "../src/zkConnectDummyModule.sol";

contract zkConnectDummyModuleDeployer is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        address _safe = 0x02a3f8233efEA083666efFe40392b940c412669F;
        bytes16 _appId = 0x11627eb6dd3358f8f4434a94bd15e6c5;
        bytes16 _groupId = 0x8837536887a7f6458977b10cc464df4b;

        new zkConnectDummyModule(_safe, _appId, _groupId);

        vm.stopBroadcast();
    }
}
