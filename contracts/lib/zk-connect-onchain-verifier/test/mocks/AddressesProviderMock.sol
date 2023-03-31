// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.14;

contract AddressesProviderMock {
  mapping(bytes32 => address) private _contractAddresses;
  string[] private _contractNames;

  /**
   * @dev Sets the address of a contract.
   * @param contractAddress Address of the contract.
   * @param contractName Name of the contract.
   */
  function set(address contractAddress, string memory contractName) public {
    bytes32 contractNameHash = keccak256(abi.encodePacked(contractName));

    if (_contractAddresses[contractNameHash] == address(0)) {
      _contractNames.push(contractName);
    }

    _contractAddresses[contractNameHash] = contractAddress;
  }

  function get(string memory contractName) public view returns (address) {
    bytes32 contractNameHash = keccak256(abi.encodePacked(contractName));

    return _contractAddresses[contractNameHash];
  }
}
