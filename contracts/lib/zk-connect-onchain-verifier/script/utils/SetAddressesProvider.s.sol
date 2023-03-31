// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Script.sol";
import "forge-std/console.sol";

import {IAddressesProvider} from "src/periphery/interfaces/IAddressesProvider.sol";
import {BaseDeploymentConfig} from "script/BaseConfig.sol";

contract SetAddressesProvider is Script, BaseDeploymentConfig {
  function run() external {
    string memory chainName = vm.envString("CHAIN_NAME");
    _setConfig(getChainName(chainName));

    console.log("Run for CHAIN_NAME:", chainName);
    console.log("Sender:", msg.sender);

    vm.startBroadcast();

    IAddressesProvider sismoAddressProvider = IAddressesProvider(config.sismoAddressesProvider);
    sismoAddressProvider.set(config.zkConnectVerifier, string("zkConnectVerifier-v2"));

    vm.stopBroadcast();
  }
}
