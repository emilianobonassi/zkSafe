// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Script} from "forge-std/Script.sol";

struct DeploymentConfig {
  address proxyAdmin;
  address owner;
  address rootsOwner;
  uint256[2] commitmentMapperEdDSAPubKey;
  address availableRootsRegistry;
  address commitmentMapperRegistry;
  address sismoAddressesProvider;
  address zkConnectVerifier;
  address hydraS2Verifier;
}

contract BaseDeploymentConfig is Script {
  DeploymentConfig public config;

  address immutable SISMO_ADDRESSES_PROVIDER = 0x3340Ac0CaFB3ae34dDD53dba0d7344C1Cf3EFE05;

  // Main Env
  address immutable MAIN_PROXY_ADMIN = 0x2110475dfbB8d331b300178A867372991ff35fA3;
  address immutable MAIN_OWNER = 0x00c92065F759c3d1c94d08C27a2Ab97a1c874Cbc;
  address immutable MAIN_GNOSIS_ROOTS_OWNER = 0xEf809a50de35c762FBaCf1ae1F6B861CE42911D1;
  address immutable MAIN_POLYGON_ROOTS_OWNER = 0xF0a0B692e1c764281c211948D03edEeF5Fb57111;

  // Testnet Env
  address immutable TESTNET_PROXY_ADMIN = 0x246E71bC2a257f4BE9C7fAD4664E6D7444844Adc;
  address immutable TESTNET_OWNER = 0xBB8FcA8f2381CFeEDe5D7541d7bF76343EF6c67B;
  address immutable TESTNET_GOERLI_ROOTS_OWNER = 0xa687922C4bf2eB22297FdF89156B49eD3727618b;
  address immutable TESTNET_MUMBAI_ROOTS_OWNER = 0xCA0583A6682607282963d3E2545Cd2e75697C2bb;

  // Sismo Staging env (Sismo internal use only)
  address immutable STAGING_PROXY_ADMIN = 0x246E71bC2a257f4BE9C7fAD4664E6D7444844Adc;
  address immutable STAGING_OWNER = 0xBB8FcA8f2381CFeEDe5D7541d7bF76343EF6c67B;
  address immutable STAGING_GOERLI_ROOTS_OWNER = 0x7f2e6E158643BCaF85f30c57Ae8625f623D82659;
  address immutable STAGING_MUMBAI_ROOTS_OWNER = 0x63F08f8F13126B9eADC76dd683902C61c5115138;

  // commitment mapper pubkeys
  uint256 immutable PROD_BETA_COMMITMENT_MAPPER_PUB_KEY_X =
    0x07f6c5612eb579788478789deccb06cf0eb168e457eea490af754922939ebdb9;
  uint256 immutable PROD_BETA_COMMITMENT_MAPPER_PUB_KEY_Y =
    0x20706798455f90ed993f8dac8075fc1538738a25f0c928da905c0dffd81869fa;

  uint256 immutable DEV_BETA_COMMITMENT_MAPPER_PUB_KEY_X =
    0x2ab71fb864979b71106135acfa84afc1d756cda74f8f258896f896b4864f0256;
  uint256 immutable DEV_BETA_COMMITMENT_MAPPER_PUB_KEY_Y =
    0x30423b4c502f1cd4179a425723bf1e15c843733af2ecdee9aef6a0451ef2db74;

  error ChainNotConfigured(DeployChain chain);
  error ChainNameNotFound(string chainName);

  enum DeployChain {
    Gnosis,
    Polygon,
    TestnetGoerli,
    TestnetMumbai,
    StagingGoerli,
    StagingMumbai,
    Test
  }

  function getChainName(string memory chainName) internal returns (DeployChain) {
    if (_compareString(chainName, "gnosis")) {
      return DeployChain.Gnosis;
    } else if (_compareString(chainName, "polygon")) {
      return DeployChain.Polygon;
    } else if (_compareString(chainName, "testnet-goerli")) {
      return DeployChain.TestnetGoerli;
    } else if (_compareString(chainName, "testnet-mumbai")) {
      return DeployChain.TestnetMumbai;
    } else if (_compareString(chainName, "staging-goerli")) {
      return DeployChain.StagingGoerli;
    } else if (_compareString(chainName, "staging-mumbai")) {
      return DeployChain.StagingMumbai;
    } else if (_compareString(chainName, "test")) {
      return DeployChain.Test;
    }
    revert ChainNameNotFound(chainName);
  }

  function _setConfig(DeployChain chain) internal returns (DeploymentConfig memory) {
    if (chain == DeployChain.Gnosis) {
      config = DeploymentConfig({
        proxyAdmin: MAIN_PROXY_ADMIN,
        owner: MAIN_OWNER,
        rootsOwner: MAIN_GNOSIS_ROOTS_OWNER,
        commitmentMapperEdDSAPubKey: [
          PROD_BETA_COMMITMENT_MAPPER_PUB_KEY_X,
          PROD_BETA_COMMITMENT_MAPPER_PUB_KEY_Y
        ],
        availableRootsRegistry: address(0x9B0C9EF48DEc082904054cf9183878E1f4e04D79),
        commitmentMapperRegistry: address(0x653245dE30B901e507B1b09f619ce5B4b161e583),
        sismoAddressesProvider: SISMO_ADDRESSES_PROVIDER,
        zkConnectVerifier: address(0),
        hydraS2Verifier: address(0)
      });
    } else if (chain == DeployChain.Polygon) {
      config = DeploymentConfig({
        proxyAdmin: MAIN_PROXY_ADMIN,
        owner: MAIN_OWNER,
        rootsOwner: MAIN_POLYGON_ROOTS_OWNER,
        commitmentMapperEdDSAPubKey: [
          PROD_BETA_COMMITMENT_MAPPER_PUB_KEY_X,
          PROD_BETA_COMMITMENT_MAPPER_PUB_KEY_Y
        ],
        availableRootsRegistry: address(0x818c0f863C6B8E92c316924711bfEb2D903B4A77),
        commitmentMapperRegistry: address(0x2607c31e104bcF96F7Bc78e8e9BCA356C4D5ebBb),
        sismoAddressesProvider: SISMO_ADDRESSES_PROVIDER,
        zkConnectVerifier: address(0),
        hydraS2Verifier: address(0)
      });
    } else if (chain == DeployChain.TestnetGoerli) {
      config = DeploymentConfig({
        proxyAdmin: TESTNET_PROXY_ADMIN,
        owner: TESTNET_OWNER,
        rootsOwner: TESTNET_GOERLI_ROOTS_OWNER,
        commitmentMapperEdDSAPubKey: [
          DEV_BETA_COMMITMENT_MAPPER_PUB_KEY_X,
          DEV_BETA_COMMITMENT_MAPPER_PUB_KEY_Y
        ],
        availableRootsRegistry: address(0xF3dAc93c85e92cab8f811b3A3cCaCB93140D9304),
        commitmentMapperRegistry: address(0xa3104F52bF6C8317a49144d864CB04f2A487327B),
        sismoAddressesProvider: SISMO_ADDRESSES_PROVIDER,
        zkConnectVerifier: address(0x8BcD02319F29AB2f89b3D424FFc985FF7353E7DC),
        hydraS2Verifier: address(0xdE270F0107F350954A7D03C0d54021A7Ccf9AABC)
      });
    } else if (chain == DeployChain.TestnetMumbai) {
      config = DeploymentConfig({
        proxyAdmin: TESTNET_PROXY_ADMIN,
        owner: TESTNET_OWNER,
        rootsOwner: TESTNET_MUMBAI_ROOTS_OWNER,
        commitmentMapperEdDSAPubKey: [
          DEV_BETA_COMMITMENT_MAPPER_PUB_KEY_X,
          DEV_BETA_COMMITMENT_MAPPER_PUB_KEY_Y
        ],
        availableRootsRegistry: address(0x5449Cc7A7E4024a7192d70c9Ce60Bb823993fd81),
        commitmentMapperRegistry: address(0x041B342b3F114F58983A9179D2c90Da01b822BE0),
        sismoAddressesProvider: SISMO_ADDRESSES_PROVIDER,
        zkConnectVerifier: address(0),
        hydraS2Verifier: address(0)
      });
    } else if (chain == DeployChain.StagingGoerli) {
      config = DeploymentConfig({
        proxyAdmin: STAGING_PROXY_ADMIN,
        owner: STAGING_OWNER,
        rootsOwner: STAGING_GOERLI_ROOTS_OWNER,
        commitmentMapperEdDSAPubKey: [
          DEV_BETA_COMMITMENT_MAPPER_PUB_KEY_X,
          DEV_BETA_COMMITMENT_MAPPER_PUB_KEY_Y
        ],
        availableRootsRegistry: address(0xEF170C37DFE6022A9Ed10b8C81d199704ED38a11),
        commitmentMapperRegistry: address(0x5840b39264b9fc7B294Ef4D8De1c8d25b136201B),
        sismoAddressesProvider: address(0),
        zkConnectVerifier: address(0),
        hydraS2Verifier: address(0)
      });
    } else if (chain == DeployChain.StagingMumbai) {
      config = DeploymentConfig({
        proxyAdmin: STAGING_PROXY_ADMIN,
        owner: STAGING_OWNER,
        rootsOwner: STAGING_MUMBAI_ROOTS_OWNER,
        commitmentMapperEdDSAPubKey: [
          DEV_BETA_COMMITMENT_MAPPER_PUB_KEY_X,
          DEV_BETA_COMMITMENT_MAPPER_PUB_KEY_Y
        ],
        availableRootsRegistry: address(0x787A74BE3AfD2bE012bD7E7c4CF2c6bDa2e70c83),
        commitmentMapperRegistry: address(0x09Dca2AC5BB0b9E23beF5723D0203Bc9B1033D1f),
        sismoAddressesProvider: address(0),
        zkConnectVerifier: address(0),
        hydraS2Verifier: address(0)
      });
    } else if (chain == DeployChain.Test) {
      config = DeploymentConfig({
        proxyAdmin: address(1),
        owner: address(2),
        rootsOwner: address(3),
        commitmentMapperEdDSAPubKey: [uint256(10), uint256(11)],
        availableRootsRegistry: address(0),
        commitmentMapperRegistry: address(0),
        sismoAddressesProvider: address(0),
        zkConnectVerifier: address(0),
        hydraS2Verifier: address(0)
      });
    } else {
      revert ChainNotConfigured(chain);
    }
  }

  function _compareString(string memory a, string memory b) internal pure returns (bool) {
    return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
  }

  /// @dev broadcast transaction modifier
  /// @param pk private key to broadcast transaction
  modifier broadcast(uint256 pk) {
    vm.startBroadcast(pk);

    _;

    vm.stopBroadcast();
  }
}
