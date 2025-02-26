import { expect } from "chai";
import { ethers, Contract, Wallet, JsonRpcProvider } from "ethers";
import * as dotenv from "dotenv";

dotenv.config(); // Load environment variables

describe("SoulProfile", function () {
  let deployer: Wallet;
  let user: Wallet;
  let soulProfile: Contract;

  // Set up provider and wallets
  const provider = new JsonRpcProvider(process.env.BASE_SEPOLIA_RPC_URL);
  const deployerWallet = new Wallet(process.env.PRIVATE_KEY!, provider);

  before(async function () {
    // Deploy contract
    const SoulProfileArtifact = await import("../artifacts/contracts/SoulProfile.sol/SoulProfile.json");
    if (!SoulProfileArtifact.abi.some((item: any) => item.name === "createProfile")) {
      throw new Error("createProfile method not found in SoulProfile ABI");
    }
    const SoulProfileFactory = new ethers.ContractFactory(
      SoulProfileArtifact.abi,
      SoulProfileArtifact.bytecode,
      deployerWallet
    );

    soulProfile = (await SoulProfileFactory.deploy()) as Contract;
    await soulProfile.waitForDeployment();

    // Ensure it's typed correctly as an ethers.Contract
    soulProfile = soulProfile as Contract;

    // Create a test user wallet
    const randomWallet = Wallet.createRandom();
    user = new Wallet(randomWallet.privateKey, provider);
  });

  it("Should create a profile", async function () {
    const username = "testuser";
    const tx = await soulProfile.connect(user).createProfile(username);
    await tx.wait();

    // Fetch profile
    const [storedUsername, did, visibility] = await soulProfile.getProfile(user.address);
    
    expect(storedUsername).to.equal(username);
    expect(did).to.contain("did:ethereum:");
    expect(visibility).to.equal("public");
  });

  it("Should update the default avatar", async function () {
    const avatarURI = "https://ipfs.io/ipfs/bafkreibcoa4cppbvwi5e2fa2io3bbwlyrvqy7jggegr4cqpyjkbwzjle4m";

    const tx = await soulProfile.connect(user).setDefaultAvatar(avatarURI);
    await tx.wait();

    const storedAvatar = await soulProfile.getDefaultAvatar(user.address);
    expect(storedAvatar).to.equal(avatarURI);
  });

  it("Should set dApp-specific avatars", async function () {
    const dappAddress = "0x1234567890abcdef1234567890abcdef12345678";
    const avatarURI = "https://ipfs.io/ipfs/bafkreibcoa4cppbvwi5e2fa2io3bbwlyrvqy7jggegr4cqpyjkbwzjle4m";
    const visibility = "private";

    const tx = await soulProfile.connect(user).setDappAvatar(dappAddress, avatarURI, visibility);
    await tx.wait();

    const [storedAvatar, storedVisibility] = await soulProfile.getDappAvatar(user.address, dappAddress);
    expect(storedAvatar).to.equal(avatarURI);
    expect(storedVisibility).to.equal(visibility);
  });
});
