const { expect } = require("chai");
const { BigNumber } = require("ethers");
const { hexStripZeros } = require("ethers/lib/utils");
const { ethers } = require("hardhat");

const provider = process.env.provider;
let owner, user1, user2, user3, user4, user5, user6, user7;
async function getAddresses() {
    [owner, user1, user2, user3, user4, user5, user6, user7] =
      await ethers.getSigners();
  }

async function deploy() {
    const NFT = await ethers.getContractFactory("BattleOfTheBlockchain");
    const nft = await NFT.deploy("BattleOfTheBlockchain", "BotB", "https://botbnft.mypinata.cloud/ipfs/Qmetbt47eKd353MWFWzUEW9TUUxKbTUTLNgVz4o5HsA1v3/");
    await nft.deployed();
    console.log("contract deployed:", nft.address);
    
  }
  describe("Deploying Contracts", async () => {
    it("Contracts Deployed", async () => {
      await deploy();
      await getAddresses();
    });
    describe("Transactions", async () => {
        it("Should whitelist addresses", async function() {
            const NFT = await ethers.getContractFactory("BattleOfTheBlockchain");
            const nft = await NFT.deploy("BattleOfTheBlockchain", "BotB", "https://botbnft.mypinata.cloud/ipfs/Qmetbt47eKd353MWFWzUEW9TUUxKbTUTLNgVz4o5HsA1v3/");
            await nft.deployed();
            await nft.whitelistUsers([user1.address, user2.address]);
        });
      });
  });
