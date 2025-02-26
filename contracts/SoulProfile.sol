// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./ISoulProfile.sol";

contract SoulProfile is Ownable, ISoulProfile {
    struct Profile {
        string username;
        string did;
        string avatar;
        string visibility;
        mapping(address => DappAvatar) dappAvatars;
    }

    mapping(address => Profile) private profiles;

    constructor() Ownable(msg.sender) {}

    modifier onlyProfileOwner() {
        require(bytes(profiles[msg.sender].did).length > 0, "Profile does not exist");
        _;
    }

    function createProfile(string calldata username) external override {
        require(bytes(username).length > 0, "Username cannot be empty");
        require(bytes(profiles[msg.sender].did).length == 0, "Profile already exists");

        profiles[msg.sender].username = username;
        profiles[msg.sender].did = string(abi.encodePacked("did:ethereum:", Strings.toHexString(msg.sender)));
        profiles[msg.sender].visibility = "public"; // Default visibility

        emit ProfileCreated(msg.sender, profiles[msg.sender].did, username);
    }

    function setProfileVisibility(string calldata visibility) external override onlyProfileOwner {
        require(keccak256(bytes(visibility)) == keccak256("public") || keccak256(bytes(visibility)) == keccak256("private"), "Invalid visibility");
        profiles[msg.sender].visibility = visibility;
        emit ProfileVisibilityUpdated(msg.sender, visibility);
    }

    function setDefaultAvatar(string calldata avatarURI) external override onlyProfileOwner {
        profiles[msg.sender].avatar = avatarURI;
        emit AvatarUpdated(msg.sender, avatarURI);
    }

    function setDappAvatar(address dApp, string calldata avatarURI, string calldata visibility) external override onlyProfileOwner {
        require(dApp != address(0), "Invalid dApp address");
        require(keccak256(bytes(visibility)) == keccak256("public") || keccak256(bytes(visibility)) == keccak256("private"), "Invalid visibility");

        profiles[msg.sender].dappAvatars[dApp] = DappAvatar(avatarURI, visibility);
        emit DappAvatarUpdated(msg.sender, dApp, avatarURI, visibility);
    }

    function getProfile(address user) external view override returns (string memory, string memory, string memory) {
        Profile storage profile = profiles[user];
        return (profile.username, profile.did, profile.visibility);
    }

    function getDefaultAvatar(address user) external view override returns (string memory) {
        return profiles[user].avatar;
    }

    function getDappAvatar(address user, address dApp) external view override returns (string memory, string memory) {
        DappAvatar storage dappAvatar = profiles[user].dappAvatars[dApp];
        return (dappAvatar.avatarURI, dappAvatar.visibility);
    }
}
