// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

struct Group {
  AccountData[] accountsData;
}

struct AccountData {
  address accountIdentifier;
  uint256 value;
}

library GroupLib {
  function build(AccountData[] memory accountsData) public returns (Group memory) {
    return Group({accountsData: accountsData});
  }
}
