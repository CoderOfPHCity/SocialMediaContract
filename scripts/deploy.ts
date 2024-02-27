import { ethers } from "hardhat";

async function main() {


 const lock = await ethers.deployContract("Social");

  await lock.waitForDeployment();
   const Nft = await ethers.deployContract("NftFactory");

   await Nft.waitForDeployment();
 

}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
