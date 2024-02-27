// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./SocialMediaPlatform.sol";

contract SocialMediaPlatformFactory {
    event PlatformCreated(address indexed platform, address indexed owner);

    mapping(address => bool) public isPlatform;

    function createPlatform() external {
        SocialMediaPlatform platform = new SocialMediaPlatform();
        isPlatform[address(platform)] = true;
        emit PlatformCreated(address(platform), msg.sender);
    }
}
