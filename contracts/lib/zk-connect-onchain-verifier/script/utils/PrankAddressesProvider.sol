// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Script.sol";
import "forge-std/console.sol";

import {IAddressesProvider} from "src/periphery/interfaces/IAddressesProvider.sol";

contract PrankAddressesProvider is Script {
  function run() external {
    IAddressesProvider sismoAddressProvider = IAddressesProvider(
      0x3340Ac0CaFB3ae34dDD53dba0d7344C1Cf3EFE05
    );
    // Addressess Provider owner
    vm.prank(0xaee4acd5c4Bf516330ca8fe11B07206fC6709294);
    sismoAddressProvider.set(
      0xB8159fe3E3a41213d8AeCE447cfE41037F714cA4,
      string("zkConnectVerifier")
    );
  }
}
