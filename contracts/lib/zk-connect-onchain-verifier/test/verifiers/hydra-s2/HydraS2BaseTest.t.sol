// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.17;

import {BaseTest} from "test/BaseTest.t.sol";
import "src/verifiers/HydraS2Verifier.sol";
import "./HydraS2Proofs.sol";
import {CommitmentMapperRegistryMock, ICommitmentMapperRegistry} from "test/mocks/CommitmentMapperRegistryMock.sol";
import {AvailableRootsRegistryMock, IAvailableRootsRegistry} from "test/mocks/AvailableRootsRegistryMock.sol";

contract HydraS2BaseTest is BaseTest {
  HydraS2Proofs immutable hydraS2Proofs = new HydraS2Proofs();
  HydraS2Verifier hydraS2Verifier;
  ICommitmentMapperRegistry commitmentMapperRegistry;
  IAvailableRootsRegistry availableRootsRegistry;

  function setUp() public virtual override {
    super.setUp();

    commitmentMapperRegistry = new CommitmentMapperRegistryMock();
    availableRootsRegistry = new AvailableRootsRegistryMock();

    hydraS2Verifier = new HydraS2Verifier(
      address(commitmentMapperRegistry),
      address(availableRootsRegistry)
    );

    vm.startPrank(owner);
    zkConnectVerifier.registerVerifier(
      hydraS2Verifier.HYDRA_S2_VERSION(),
      address(hydraS2Verifier)
    );
    vm.stopPrank();

    commitmentMapperRegistry.updateCommitmentMapperEdDSAPubKey(hydraS2Proofs.getEdDSAPubKey());
    availableRootsRegistry.registerRoot(hydraS2Proofs.getRoot());
  }
}
