require("@nomicfoundation/hardhat-toolbox");
require("hardhat-deploy");


const dotenv = require('dotenv');
dotenv.config();

const PRIVATE_KEY = process.env.PRIVATE_KEY;
const CELOSCAN_API_KEY = process.env.CELOSCAN_API_KEY;

module.exports = {
  solidity: "0.8.17",
  networks: {
    alfajores: {
      url: "https://alfajores-forno.celo-testnet.org",
      accounts: [PRIVATE_KEY]
    },
    celo: {
      url: "https://forno.celo.org",
      accounts: [PRIVATE_KEY]
    }
  },
  celoScan: {
    apiKey: CELOSCAN_API_KEY
  },
  abiExporter: {
    path: "./abi",
    clear: true,
    flat: true,
    spacing: 2
  }
};
