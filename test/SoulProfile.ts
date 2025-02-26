import { expect } from "chai";
import { ethers } from "hardhat";

describe("SoulProfile", function () {
    it("Should create a profile", async function () {
        const [owner] = await ethers.getSigners();
        const SoulProfile = await ethers.getContractFactory("SoulProfile");
        const soulProfile = await SoulProfile.deploy();
        await soulProfile.deployed();

        await soulProfile.createProfile("Alice");
        const profile = await soulProfile.getProfile(owner.address);

        expect(profile[0]).to.equal("Alice");
    });

    it("Should set avatar", async function () {
        const [owner] = await ethers.getSigners();
        const SoulProfile = await ethers.getContractFactory("SoulProfile");
        const soulProfile = await SoulProfile.deploy();
        await soulProfile.deployed();

        await soulProfile.createProfile("Alice");
        await soulProfile.setAvatar("ipfs://QmAvatar123");
        const profile = await soulProfile.getProfile(owner.address);

        expect(profile[1]).to.equal("ipfs://QmAvatar123");
    });

    it("Should toggle visibility", async function () {
        const [owner] = await ethers.getSigners();
        const SoulProfile = await ethers.getContractFactory("SoulProfile");
        const soulProfile = await SoulProfile.deploy();
        await soulProfile.deployed();

        await soulProfile.createProfile("Alice");
        await soulProfile.setVisibility(false);
        const profile = await soulProfile.getProfile(owner.address);

        expect(profile[2]).to.equal(false);
    });
});
