// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Conversions.sol";

contract Profile is Conversions {
    //Contract addaresses
    address payable public creator;
    bool public ownership;
    uint256 public contract_value;
    address[] private profiles;
    address[] private authorized_users;
    uint256 public create_fee = 10000 gwei;

    mapping(address => UserProfile) private profile_data;
    mapping(address => uint256) private client_balance;
    mapping(address => bool) private profile_ownership;
    mapping(address => bool) private privilege;
    mapping(address => uint256) private updates;

    struct UserProfile {
        string ID;
        address contract_address;
        string name;
        string dob;
        string home_address;
        string image;
        string hash;
    }

    event create_log(address indexed _name, string _message);
    event update_log(
        address indexed _name,
        address indexed _user,
        string _message
    );

    /*------------------------------------------------------------------------*/

    /*-------------------------------Constructor------------------------------*/

    constructor(
        string memory _id,
        string memory _name,
        string memory _dob,
        string memory _home_address,
        string memory _image
    ) {
        creator = payable(msg.sender);
        privilege[creator] = true;
        authorized_users.push(creator);
        Create_profile(_id, _name, _dob, _home_address, _image);
        profiles.push(creator);
        client_balance[creator] = 0;
    }

    /*------------------------------------------------------------------------*/

    /*--------------------------------Modifiers-------------------------------*/
    modifier onlyCreator() {
        require(msg.sender == creator, "You're not the creator");
        _;
    }

    modifier onlyAuthorized() {
        require(privilege[msg.sender] == true, "You're not Authorized");
        _;
    }

    modifier onlyOwner() {
        bool profile_check = false;
        for (uint256 i = 0; i < profiles.length; i++) {
            if (profiles[i] == msg.sender) {
                profile_check = true;
            }
        }

        if (profile_check != true) {
            revert();
        }
        _;
    }

    modifier ownershipGranted() {
        require(ownership = true, "The ownership hasn't been granted yet");
        _;
    }

    /*------------------------------------------------------------------------*/

    /*------------------------------Transactions------------------------------*/
    function Pay() public payable onlyOwner {
        if (profile_ownership[msg.sender] != true) {
            client_balance[msg.sender] += msg.value;
            if (client_balance[msg.sender] >= 10000) {
                profile_ownership[msg.sender] = true;
            }
        } else {
            revert();
        }
    }


    function request_ownership() public onlyOwner {
        require(
            profile_ownership[msg.sender] != false,
            "You already own a profile"
        );
        require(client_balance[msg.sender] >= create_fee);
        creator.transfer(create_fee);
        profile_ownership[msg.sender] = true;
    }

    // function upadate_profile() public onlyOwner {
    //     require(
    //         profile_ownership[msg.sender] != false,
    //         "You already own a profile"
    //     );
    //     require(client_balance[msg.sender] >= create_fee);
    //     creator.transfer(create_fee);
    //     profile_ownership[msg.sender] = true;
    // }

    function create_charge() internal {}

    function contractBalance() public view returns (uint256) {
        return client_balance[msg.sender];
    }

    /*------------------------------------------------------------------------*/

    /*-----------------------------Update Profile-----------------------------*/
    function update_name(address _id, string memory _name)
        public
        onlyAuthorized
    {
        string memory temp = profile_data[_id].name;
        profile_data[_id].name = _name;
        profile_data[_id].hash = calcHash(_id);
        profile_ownership[_id] = true;
        emit update_log(
            msg.sender,
            _id,
            string.concat(
                " Name was updated from ",
                temp,
                " to ",
                profile_data[_id].name
            )
        );
    }

    function update_dob(address _id, string memory _dob) public onlyAuthorized {
        string memory temp = profile_data[_id].dob;
        profile_data[_id].dob = _dob;
        profile_data[_id].hash = calcHash(_id);
        profile_ownership[_id] = true;
        emit update_log(
            msg.sender,
            _id,
            string.concat(
                " Date of birth was updated from ",
                temp,
                " to ",
                profile_data[_id].dob
            )
        );
    }

    function update_image(address _id, string memory _image)
        public
        onlyAuthorized
    {
        string memory temp = profile_data[_id].image;
        profile_data[_id].image = _image;
        profile_data[_id].hash = calcHash(_id);
        profile_ownership[_id] = true;
        emit update_log(
            msg.sender,
            _id,
            string.concat(
                " Image was updated from ",
                temp,
                " to ",
                profile_data[_id].image
            )
        );
    }

    function update_home_address(address _id, string memory _home_addr)
        public
        onlyAuthorized
    {
        string memory temp = profile_data[_id].home_address;
        profile_data[_id].home_address = _home_addr;
        profile_data[_id].hash = calcHash(_id);
        profile_ownership[_id] = true;
        emit update_log(
            msg.sender,
            _id,
            string.concat(
                " Home address was updated from ",
                temp,
                " to ",
                profile_data[_id].home_address
            )
        );
    }

    /*------------------------------------------------------------------------*/

    /*-----------------------------Create Profile-----------------------------*/
    function Create_profile(
        string memory _id,
        string memory _name,
        string memory _dob,
        string memory _home_address,
        string memory _image
    ) public {
        address _id_addr = stringToAddress(_id);
        profile_data[_id_addr] = UserProfile(
            _id,
            address(this),
            _name,
            _dob,
            _home_address,
            _image,
            ""
        );
        profile_data[_id_addr].hash = calcHash(_id_addr);
        profiles.push(_id_addr);
        privilege[_id_addr] = false;
        profile_ownership[_id_addr] = false;
        client_balance[creator] = 0;
        emit create_log(
            msg.sender,
            string.concat(" User profile was created ", _id, " created.")
        );
    }

    /*------------------------------------------------------------------------*/

    /*------------------------------Get Profile-------------------------------*/
    function get_user_profile(address _id)
        public
        view
        returns (
            string memory,
            string memory,
            string memory,
            string memory,
            string memory,
            string memory
        )
    {
        return (
            profile_data[_id].ID,
            profile_data[_id].name,
            profile_data[_id].dob,
            profile_data[_id].home_address,
            profile_data[_id].image,
            profile_data[_id].hash
        );
    }

    /*------------------------------------------------------------------------*/

    function calcHash(address _id) internal view returns (string memory) {
        string memory string_concat = string.concat(
            profile_data[_id].ID,
            profile_data[_id].name,
            profile_data[_id].dob,
            profile_data[_id].home_address,
            profile_data[_id].image
        );
        return toAsciiString_bytes32(sha256(bytes(string_concat)));
    }

    function authorize_user(address _id) public onlyCreator {
        privilege[_id] = true;
        authorized_users.push(_id);
    }

}
