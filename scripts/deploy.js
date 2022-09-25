data = require("../config");

async function main() {
    const [deployer] = await ethers.getSigners();

    console.log("Deploying contracts with the account:", deployer.address);
    console.log("Account balance:", (await deployer.getBalance()).toString());

    const OutsourcingFactory = await ethers.getContractFactory("OutsourcingFactory");
    const outsourcingFactory = await OutsourcingFactory.deploy(data.repuFactory);

    console.log("RepuFactory address:", data.repuFactory);
    console.log("OutsourcingFactory address:", outsourcingFactory.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });