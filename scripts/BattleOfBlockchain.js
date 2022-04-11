const hre = require("hardhat");

async function main() {

  const NFT = await hre.ethers.getContractFactory("BattleOfTheBlockchain");
  const NFTTokens = await NFT.deploy("Battle of the Blockchains", "BotB", "https://botbnft.mypinata.cloud/ipfs/Qmetbt47eKd353MWFWzUEW9TUUxKbTUTLNgVz4o5HsA1v3/");

  await NFTTokens.deployed();

  console.log("Contract deployed to:", NFTTokens.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

