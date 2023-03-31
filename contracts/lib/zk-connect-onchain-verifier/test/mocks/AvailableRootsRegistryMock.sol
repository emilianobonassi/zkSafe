// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {IAvailableRootsRegistry} from "src/periphery/interfaces/IAvailableRootsRegistry.sol";

contract AvailableRootsRegistryMock is IAvailableRootsRegistry {
  mapping(uint256 => bool) public _roots;

  function initialize(address) external {}

  function isRootAvailable(uint256 root) external view returns (bool) {
    return true;
  }

  function registerRoot(uint256 root) external {
    _roots[root] = true;
  }

  function unregisterRoot(uint256 root) external {
    _roots[root] = false;
  }
}
