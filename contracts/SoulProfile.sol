// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.19;

contract SoulProfile {
    struct Profile {
        string username;
        string avatar;
        bool isPublic;
    }

    mapping(address => Profile) private profiles;

    event ProfileCreated(address indexed user, string username);
    event AvatarUpdated(address indexed user, string avatar);
    event VisibilityUpdated(address indexed user, bool isPublic);

    function createProfile(string calldata username) external {
        require(bytes(profiles[msg.sender].username).length == 0, "Profile exists");
        profiles[msg.sender] = Profile(username, "", true);
        emit ProfileCreated(msg.sender, username);
    }

    function setAvatar(string calldata avatar) external {
        require(bytes(profiles[msg.sender].username).length > 0, "No profile");
        profiles[msg.sender].avatar = avatar;
        emit AvatarUpdated(msg.sender, avatar);
    }

    function setVisibility(bool isPublic) external {
        require(bytes(profiles[msg.sender].username).length > 0, "No profile");
        profiles[msg.sender].isPublic = isPublic;
        emit VisibilityUpdated(msg.sender, isPublic);
    }

    function getProfile(address user) external view returns (string memory, string memory, bool) {
        require(profiles[user].isPublic || msg.sender == user, "Private profile");
        Profile memory profile = profiles[user];
        return (profile.username, profile.avatar, profile.isPublic);
    }
}
