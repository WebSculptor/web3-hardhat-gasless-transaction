import { ethers } from "hardhat";
// scripts/deploy.js
async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  const SocialMediaPlatform = await ethers.getContractFactory(
    "SocialMediaPlatform"
  );
  const socialMediaPlatform = await SocialMediaPlatform.deploy();

  console.log("SocialMediaPlatform address:", socialMediaPlatform.target);

  const SocialMediaPlatformFactory = await ethers.getContractFactory(
    "SocialMediaPlatformFactory"
  );
  const socialMediaPlatformFactory = await SocialMediaPlatformFactory.deploy();

  console.log(
    "SocialMediaPlatformFactory address:",
    socialMediaPlatformFactory.target
  );
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
