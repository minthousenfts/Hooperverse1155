
const main = async () => {
    const nftContractFactory = await hre.ethers.getContractFactory("Hooperverse");
    const nftContract = await nftContractFactory.deploy();

    await nftContract.deployed();
    
    console.log("Hooperverse deployed to: ", nftContract.address);
};

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.log(error);
        process.exit(1);
    });
