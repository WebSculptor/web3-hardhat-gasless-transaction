import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import dotenv from "dotenv";

dotenv.config();

const { SEPOLIA_API_URL, ACCOUNT_PRIVATE_KEY } = process.env;

const config: HardhatUserConfig = {
  solidity: "0.8.24",
  gasReporter: {
    gasPrice: 10000000000,
  },
  networks: {
    sepolia: {
      url: SEPOLIA_API_URL!,
      accounts: [ACCOUNT_PRIVATE_KEY!],
    },
  },
};

export default config;
