// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "json-dm-utils/contracts/JsonParser.sol";

contract Profile {
    //Contract addaresses
    address public creator;
    address public owner;
    bool public ownership;
    bytes32 hash;

    struct UserProfile {
        address ID;
        string name;
        string dob;
        string image;
    }

    mapping(address => UserProfile) private profiles;

    constructor(
        address _id,
        string memory _name,
        string memory _dob,
        string memory _image
    ) {
        creator = msg.sender;
        owner = _id;
        Create_profile(_id, _name, _dob, _image);
    }

    modifier onlyCreator() {
        require(msg.sender == creator, "You're not the creator");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You're not the Owner");
        _;
    }

    modifier ownershipGranted() {
        require(ownership = true, "The ownership hasn't been granted yet");
        _;
    }

    function Pass_ownership() public payable onlyOwner {
        ownership = true;
    }

    function update_name(string memory _name) public {
        profiles[owner].name = _name;
    }

    function Create_profile(
        address _id,
        string memory _name,
        string memory _dob,
        string memory _image
    ) private {
        profiles[_id] = UserProfile(_id, _name, _dob, _image);
    }

    function getUserProfile(
        address _id
    )
        public
        view
        returns (address, string memory, string memory, string memory)
    {
        return (
            profiles[_id].ID,
            profiles[_id].name,
            profiles[_id].dob,
            profiles[_id].image
        );
    }
}
