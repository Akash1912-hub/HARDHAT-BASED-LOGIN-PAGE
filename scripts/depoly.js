// scripts/deploy.js

const Web3 = require("web3").default;
const fs = require("fs");
const path = require("path");

async function main() {
    // Set up Web3 with Hardhat's provider
    const web3 = new Web3("http://127.0.0.1:8545"); // Default Hardhat network URL

    // Load the compiled contract ABI and bytecode
    const contractPath = path.resolve(__dirname, "../artifacts/contracts/login.sol/LoginDapp.json");
    const contractJson = JSON.parse(fs.readFileSync(contractPath, "utf8"));
    const contractABI = contractJson.abi;
    const contractBytecode = contractJson.bytecode;

    // Get the list of accounts
    const accounts = await web3.eth.getAccounts();
    const deployer = accounts[0];
    console.log("Deploying contracts with the account:", deployer);

    // Create contract instance
    const LoginContract = new web3.eth.Contract(contractABI);

    // Deploy contract
    const loginInstance = await LoginContract.deploy({ data: contractBytecode })
        .send({ from: deployer, gas: 3000000 });

    console.log("login contract deployed to:", loginInstance.options.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
