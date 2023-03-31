import { shortenAddress, useEthers, useLookupAddress } from "@usedapp/core";
import React, { useEffect, useState } from "react";

import { Body, Button, Container, Header, Image, Link } from "./components";
import safelogo from "./safelogo.png";
import sismologo from "./sismologo.png";

import { ZkConnectButton, AuthType } from "@sismo-core/zk-connect-react";

import Box from "@mui/material/Box";
import Grid from "@mui/material/Grid";
import Typography from "@mui/material/Typography";
import TextField from "@mui/material/TextField";
import {Button as MButton} from "@mui/material";

import useLocalStorageState from "use-local-storage-state";

import { ethers } from "ethers";

import Safe from '@safe-global/safe-core-sdk';
import EthersAdapter from '@safe-global/safe-ethers-lib';

import zkConnectDummyModuleAbi from './abi/zkConnectDummyModule.abi.json';

const zkConnectConfig = {
  appId: "0x11627eb6dd3358f8f4434a94bd15e6c5",
  devMode: {
    enabled: true,
  },
};

function WalletButton() {
  const [rendered, setRendered] = useState("");

  const { ens } = useLookupAddress();
  const { account, activateBrowserWallet, deactivate, error } = useEthers();

  useEffect(() => {
    if (ens) {
      setRendered(ens);
    } else if (account) {
      setRendered(shortenAddress(account));
    } else {
      setRendered("");
    }
  }, [account, ens, setRendered]);

  useEffect(() => {
    if (error) {
      console.error("Error while connecting wallet:", error.message);
    }
  }, [error]);

  return (
    <Button
      onClick={() => {
        if (!account) {
          activateBrowserWallet();
        } else {
          deactivate();
        }
      }}
    >
      {rendered === "" && "Connect Wallet"}
      {rendered !== "" && rendered}
    </Button>
  );
}

function App() {
  const [safeAddress, setSafeAddress] = useLocalStorageState("safeAddress");
  const [to, setTo] = useLocalStorageState("to");
  const [value, setValue] = useLocalStorageState("value", {
    defaultValue: 0
  });
  const [data, setData] = useLocalStorageState("data", {
    defaultValue: "0x"
  });

  const [responseBytes, setResponseBytes] = useState("");
  const [messageSignatureRequest, setMessageSignatureRequest] = useState("");

  const [zkConnectSafeModuleAddress, setZkConnectSafeModuleAddress] = useState("");

  useEffect(() => {
    if(to != null && value != null && data != null) {
      /*setMessageSignatureRequest(ethers.utils.defaultAbiCoder.encode(
        ["address", "uint256", "bytes", "uint8"],
        [
          to,
          ethers.BigNumber.from(value),
          ethers.utils.hexlify(data),
          0,
        ] //fixed call
      ));*/

      //temporary fix for the demo
      setMessageSignatureRequest(ethers.utils.defaultAbiCoder.encode(
        ["uint256"],
        [ethers.BigNumber.from(0)]
      ));

      console.log(messageSignatureRequest)
    }
  }, [to, value, data])



  useEffect(() => {
      ;(async () => {
        if(safeAddress != null) {
          const provider = new ethers.providers.JsonRpcProvider('https://rpc.ankr.com/eth_goerli')
          const ethAdapter = new EthersAdapter({
            ethers,
            signerOrProvider: provider
          })
    
          const safeSdk = await Safe.create({ ethAdapter, safeAddress });
    
          const modules = await safeSdk.getModules();
    
          setZkConnectSafeModuleAddress(modules[0]);
        }
      })()
  }, [safeAddress])

  const {library} = useEthers();

  return (
    <Container>
      <Header>
        <WalletButton />
      </Header>
      <Body>
        <Box sx={{ flexGrow: 1 }}>
          <Grid
            container
            direction="row"
            spacing={1}
            alignItems="center"
            justifyContent="center"
          >
            <Grid item>
              <Box
                component="img"
                sx={{
                  height: 64,
                }}
                src={sismologo}
              />
            </Grid>
            <Grid item>
              <Box
                component="img"
                sx={{
                  height: 60,
                }}
                src={safelogo}
              />
            </Grid>
          </Grid>
          <Grid
            container
            direction="column"
            spacing={2}
            alignItems="center"
            justifyContent="center"
          >
            <Grid item>
              <Typography variant="h1" textAlign="center">
                zkSafe
              </Typography>
            </Grid>
            <Grid item>
              <Typography variant="h5" textAlign="center">
                Operate your Gnosis Safe using Sismo zkConnect 🎭
              </Typography>
            </Grid>
           
            <Grid item>
              <Grid
                container
                direction="row"
                alignItems="center"
                spacing={2}
                justifyContent="center"
              >
                <Grid item xs={6} textAlign="right">
                  Safe Address
                </Grid>
                <Grid item xs={6}>
                  <TextField
                    sx={{ width: "26ch" }}
                    variant="outlined"
                    placeholder="Safe Address"
                    value={safeAddress}
                    onChange={(e) => setSafeAddress(e.target.value)}
                  />
                </Grid>
              </Grid>
              <Grid item>
                <Grid
                  container
                  direction="row"
                  alignItems="center"
                  spacing={2}
                  justifyContent="center"
                >
                  <Grid item xs={6} textAlign="right">
                    To
                  </Grid>
                  <Grid item xs={6}>
                    <TextField
                      sx={{ width: "26ch" }}
                      variant="outlined"
                      placeholder="To"
                      value={to}
                      onChange={(e) => setTo(e.target.value)}
                    />
                  </Grid>
                </Grid>
              </Grid>
              <Grid item>
                <Grid
                  container
                  direction="row"
                  alignItems="center"
                  spacing={2}
                  justifyContent="center"
                >
                  <Grid item xs={6} textAlign="right">
                    Value
                  </Grid>
                  <Grid item xs={6}>
                    <TextField
                      sx={{ width: "26ch" }}
                      variant="outlined"
                      placeholder="Value"
                      value={value}
                      onChange={(e) => setValue(e.target.value)}
                    />
                  </Grid>
                </Grid>
              </Grid>
              <Grid item>
                <Grid
                  container
                  direction="row"
                  alignItems="center"
                  spacing={2}
                  justifyContent="center"
                >
                  <Grid item xs={6} textAlign="right">
                    Data
                  </Grid>
                  <Grid item xs={6}>
                    <TextField
                      sx={{ width: "26ch" }}
                      variant="outlined"
                      placeholder="Data"
                      value={data}
                      onChange={(e) => setData(e.target.value)}
                    />
                  </Grid>
                </Grid>
              </Grid>
            </Grid>
            <Grid item>
              <ZkConnectButton
                //Request proofs from your users for a groupId
                claimRequest={{
                  //groupId: "0x8837536887a7f6458977b10cc464df4b",
                  groupId: "0x7d48a27aa88de136fe09dad207f543c2"
                }}
                authRequest={{
                  authType: AuthType.ANON,
                }}
                messageSignatureRequest={messageSignatureRequest}
                config={zkConnectConfig}
                //After user redirection get a response containing his proofs
                onResponse={async (response) => {
                  console.log(response);
                }}
                onResponseBytes={async (bytes) => {
                  console.log(bytes);
                  setResponseBytes(bytes);
                }}
              />
            </Grid>
            <Grid item>
              <MButton variant="contained" 
                disabled={responseBytes === ''}
                onClick={async() => {
                  const zkConnectDummyModule = new ethers.Contract(zkConnectSafeModuleAddress, zkConnectDummyModuleAbi, library.getSigner());
                  await zkConnectDummyModule.execTransactionFromModule(
                    to,
                    value,
                    data,
                    0,
                    responseBytes,
                  );
                }}
              >
                Exec 🚀
              </MButton>
            </Grid>
          </Grid>
        </Box>
      </Body>
    </Container>
  );
}

export default App;
