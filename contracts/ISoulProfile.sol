// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.19;

interface ISoulProfile {
    struct DappAvatar {
        string avatarURI;
        string visibility;
    }

    event ProfileCreated(address indexed user, string did, string username);
    event AvatarUpdated(address indexed user, string avatarURI);
    event DappAvatarUpdated(address indexed user, address indexed dApp, string avatarURI, string visibility);
    event ProfileVisibilityUpdated(address indexed user, string visibility);

    function createProfile(string calldata username) external;
    function setProfileVisibility(string calldata visibility) external;
    function setDefaultAvatar(string calldata avatarURI) external;
    function setDappAvatar(address dApp, string calldata avatarURI, string calldata visibility) external;
    function getProfile(address user) external view returns (string memory, string memory, string memory);
    function getDefaultAvatar(address user) external view returns (string memory);
    function getDappAvatar(address user, address dApp) external view returns (string memory, string memory);
}
