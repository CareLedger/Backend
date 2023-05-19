const { ethers } = require('hardhat');



async function main() {
  const [deployer] = await ethers.getSigners();

  console.log('Deploying contracts with the account:', deployer.address);

  const HealthRecordSystem = await ethers.getContractFactory('HealthRecordSystem');
  const healthRecordSystem = await HealthRecordSystem.deploy();

  console.log('Contract address:', healthRecordSystem.address);

}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });