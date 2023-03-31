// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

import "script/01_DeployAll.s.sol";

contract DeployAllTest is Test {
  ScriptTypes.DeployAllContracts contracts;

  address immutable PROXY_ADMIN = address(1);
  address immutable OWNER = address(2);
  address immutable ROOTS_OWNER = address(3);

  function setUp() public virtual {
    DeployAll deploy = new DeployAll();

    (bool success, bytes memory result) = address(deploy).delegatecall(
      abi.encodeWithSelector(DeployAll.runFor.selector, "test")
    );
    require(success, "Deploy script did not run successfully!");
    contracts = abi.decode(result, (ScriptTypes.DeployAllContracts));
  }

  function testDeployment() public {
    console.log(address(contracts.availableRootsRegistry));
  }

  function testAvailableRootsRegistryDeployed() public {
    _expectDeployedWithProxy(address(contracts.availableRootsRegistry), PROXY_ADMIN);
    assertEq(contracts.availableRootsRegistry.owner(), ROOTS_OWNER);
  }

  function testCommitmentMapperRegistryDeployed() public {
    _expectDeployedWithProxy(address(contracts.commitmentMapperRegistry), PROXY_ADMIN);
    assertEq(contracts.commitmentMapperRegistry.owner(), OWNER);
  }

  function testHydraS2Verifier() public {
    _expectDeployedWithProxy(address(contracts.hydraS2Verifier), PROXY_ADMIN);
    assertEq(
      address(contracts.hydraS2Verifier.COMMITMENT_MAPPER_REGISTRY()),
      address(contracts.commitmentMapperRegistry)
    );
    assertEq(
      address(contracts.hydraS2Verifier.AVAILABLE_ROOTS_REGISTRY()),
      address(contracts.availableRootsRegistry)
    );
  }

  function testZkConnectVerifier() public {
    _expectDeployedWithProxy(address(contracts.zkConnectVerifier), PROXY_ADMIN);
    assertEq(
      contracts.zkConnectVerifier.getVerifier("hydra-s2.1"),
      address(contracts.hydraS2Verifier)
    );
    assertEq(contracts.zkConnectVerifier.owner(), OWNER);
  }

  function _expectDeployedWithProxy(address proxy, address expectedAdmin) internal {
    // Expect proxy is deployed behin a TransparentUpgradeableProxy proxy with the right admin
    vm.prank(expectedAdmin);
    (bool success, bytes memory result) = address(proxy).call(
      abi.encodeWithSelector(TransparentUpgradeableProxy.admin.selector)
    );
    assertEq(success, true);
    assertEq(abi.decode(result, (address)), PROXY_ADMIN);
  }
}
