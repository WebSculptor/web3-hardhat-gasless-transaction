// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract SocialMediaPlatform {
    address public owner;

    mapping(address => bool) public isAdmin;
    mapping(address => bool) public isUser;
    mapping(address => string) public userName;
    mapping(address => uint) public userRole;
    mapping(uint => bool) public groupExists;
    mapping(uint => address) public groupAdmin;
    mapping(address => mapping(uint => bool)) public userGroupMembership;
    mapping(uint256 => string[]) public comments;

    struct NFT {
        address owner;
        string mediaURI;
        string description;
        uint256 groupId;
        uint256 timestamp;
    }

    NFT[] public nfts;

    event NFTCreated(
        uint256 indexed nftId,
        address indexed owner,
        uint256 groupId,
        string mediaURI,
        string description,
        uint256 timestamp
    );
    event CommentAdded(
        uint256 indexed nftId,
        address indexed commenter,
        string comment,
        uint256 timestamp
    );

    enum Roles {
        User,
        Moderator,
        Admin
    }

    modifier onlyAdmin() {
        require(isAdmin[msg.sender], "Not an admin");
        _;
    }

    modifier onlyUser() {
        require(isUser[msg.sender], "Not a user");
        _;
    }

    modifier onlyAdminOrModerator() {
        require(
            isAdmin[msg.sender] ||
                userRole[msg.sender] == uint(Roles.Moderator),
            "Not authorized"
        );
        _;
    }

    constructor() {
        owner = msg.sender;
        isAdmin[msg.sender] = true;
        isUser[msg.sender] = true;
    }

    function registerUser(string memory _userName) external {
        require(!isUser[msg.sender], "User already registered");
        isUser[msg.sender] = true;
        userName[msg.sender] = _userName;
        userRole[msg.sender] = uint(Roles.User);
    }

    function promoteUser(address _userAddress, uint _role) external onlyAdmin {
        require(_role > userRole[_userAddress], "Cannot demote user");
        userRole[_userAddress] = _role;
        if (_role == uint(Roles.Admin)) {
            isAdmin[_userAddress] = true;
        }
    }

    function demoteUser(address _userAddress) external onlyAdmin {
        require(
            userRole[_userAddress] > uint(Roles.User),
            "Cannot demote user"
        );
        userRole[_userAddress]--;
        if (userRole[_userAddress] < uint(Roles.Admin)) {
            isAdmin[_userAddress] = false;
        }
    }

    function createGroup(uint _groupId) external onlyAdmin {
        require(!groupExists[_groupId], "Group already exists");
        groupExists[_groupId] = true;
        groupAdmin[_groupId] = msg.sender;
    }

    function joinGroup(uint _groupId) external onlyUser {
        userGroupMembership[msg.sender][_groupId] = true;
    }

    function createNFT(
        string memory _mediaURI,
        string memory _description,
        uint256 _groupId
    ) external onlyUser {
        uint256 nftId = nfts.length;
        nfts.push(
            NFT(msg.sender, _mediaURI, _description, _groupId, block.timestamp)
        );
        emit NFTCreated(
            nftId,
            msg.sender,
            _groupId,
            _mediaURI,
            _description,
            block.timestamp
        );
    }

    function commentOnNFT(
        uint256 _nftId,
        string memory _comment
    ) external onlyUser {
        require(_nftId < nfts.length, "Invalid NFT ID");
        comments[_nftId].push(_comment);
        emit CommentAdded(_nftId, msg.sender, _comment, block.timestamp);
    }

    function getNFTCount() external view returns (uint256) {
        return nfts.length;
    }

    function getNFT(
        uint256 _nftId
    )
        external
        view
        returns (address, string memory, string memory, uint256, uint256)
    {
        require(_nftId < nfts.length, "Invalid NFT ID");
        NFT memory nft = nfts[_nftId];
        return (
            nft.owner,
            nft.mediaURI,
            nft.description,
            nft.groupId,
            nft.timestamp
        );
    }

    function getCommentsCount(uint256 _nftId) external view returns (uint256) {
        require(_nftId < nfts.length, "Invalid NFT ID");
        return comments[_nftId].length;
    }

    function getComment(
        uint256 _nftId,
        uint256 _index
    ) external view returns (string memory) {
        require(_nftId < nfts.length, "Invalid NFT ID");
        require(_index < comments[_nftId].length, "Invalid comment index");
        return comments[_nftId][_index];
    }
}
