import { ethers } from "hardhat";

async function main() {
    const SoulProfile = await ethers.getContractFactory("SoulProfile");
    const soulProfile = await SoulProfile.deploy();

    await soulProfile.deployed();
    console.log(`SoulProfile deployed to: ${soulProfile.address}`);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
