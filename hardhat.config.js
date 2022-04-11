require("@nomiclabs/hardhat-waffle");
require('@nomiclabs/hardhat-ethers');
require("@nomiclabs/hardhat-etherscan");

const { mnemonic } = require('./secrets.json');

module.exports = {
  defaultNetwork: "testnetAVAX",
  networks: {
    dev: {
      url: "https://babel-api.testnet.iotex.io",
      accounts: ['6523efad680162db51ada4436f1b2fc7d58908248dfe39214f55e9c523047664'],
      chainId: 4690,
      gas: 8500000,
      gasPrice: 1000000000000
    },
    testnetBNB: {
      url: "https://data-seed-prebsc-1-s1.binance.org:8545",
      chainId: 97,
      gasPrice: 25000000000,
      accounts: {mnemonic: mnemonic}
    },
    Ropsten: {
      url: "https://ropsten.infura.io/v3/de5b93aaea364af99ea72f28becda82a",
      chainId: 3,
      gasPrice: 25000000000,
      accounts: {mnemonic: mnemonic}
    },
    testnetAVAX: {
      url: "https://api.avax-test.network/ext/bc/C/rpc",
      chainId: 43113,
      gasPrice: 25000000000,
      accounts: {mnemonic: mnemonic}
    },
  },
      etherscan: {
      apiKey: {      
        avalancheFujiTestnet: "S2EI1WDSF6HFZIDYWRJF2I5M38UXRRE4G9"
      }
      // apiKey: "S2EI1WDSF6HFZIDYWRJF2I5M38UXRRE4G9"
    },
    solidity: {
      version: "0.8.4",
      settings: {
        optimizer: {
          enabled: true
        }

       }
      },
};
