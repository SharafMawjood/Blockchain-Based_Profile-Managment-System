// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Profile {
    //Contract addaresses
    address public creator;
    address public owner;
    bool public ownership;
    string public hash;
    uint256 public contract_value;

    struct UserProfile {
        address ID;
        string name;
        string dob;
        string image;
    }

    event log(address indexed _name, string _message);

    mapping(address => UserProfile) private profiles;
    mapping(address => uint256) private contractCost;

    constructor(
        address _id,
        string memory _name,
        string memory _dob,
        string memory _image
    ) {
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

    function Pay() public payable onlyOwner {
        if (ownership != true) {
            contractCost[owner] += msg.value;
            if (contractCost[owner] > 10000 gwei) {
                ownership == true;
            }
        }

        require(
            contractCost[owner] > 1000 gwei,
            string.concat(
                "Insufficiant balance ",
                uint2str(1000 gwei),
                " more required"
            )
        );
        ownership = true;
    }

    function contractBalance() public view returns (uint256) {
        return contractCost[owner];
    }

    function update_name(string memory _name) public onlyCreator {
        string memory temp = profiles[owner].name;
        profiles[owner].name = _name;
        calcHash();
        emit log(
            msg.sender,
            string.concat(
                toAsciiString_address(owner),
                " name was updated from ",
                temp,
                " to ",
                profiles[owner].name,
                " by ",
                toAsciiString_address(creator)
            )
        );
    }

    function update_dob(string memory _dob) public onlyCreator {
        string memory temp = profiles[owner].dob;
        profiles[owner].dob = _dob;
        calcHash();
        emit log(
            msg.sender,
            string.concat(
                toAsciiString_address(owner),
                " name was updated from ",
                temp,
                " to ",
                profiles[owner].dob,
                " by ",
                toAsciiString_address(creator)
            )
        );
    }

    function update_image(string memory _image) public onlyCreator {
        string memory temp = profiles[owner].image;
        profiles[owner].image = _image;
        calcHash();
        emit log(
            msg.sender,
            string.concat(
                toAsciiString_address(owner),
                " name was updated from ",
                temp,
                " to ",
                profiles[owner].image,
                " by ",
                toAsciiString_address(creator)
            )
        );
    }

    function Create_profile(
        address _id,
        string memory _name,
        string memory _dob,
        string memory _image
    ) private {
        creator = msg.sender;
        owner = _id;
        profiles[_id] = UserProfile(_id, _name, _dob, _image);
        calcHash();
        emit log(
            msg.sender,
            string.concat(
                toAsciiString_address(address(this)),
                " was created by ",
                toAsciiString_address(creator),
                " for ",
                toAsciiString_address(creator)
            )
        );
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

    function toAsciiString_address(
        address x
    ) internal pure returns (string memory) {
        bytes memory s = new bytes(40);
        for (uint256 i = 0; i < 20; i++) {
            bytes1 b = bytes1(
                uint8(uint256(uint160(x)) / (2 ** (8 * (19 - i))))
            );
            bytes1 hi = bytes1(uint8(b) / 16);
            bytes1 lo = bytes1(uint8(b) - 16 * uint8(hi));
            s[2 * i] = char(hi);
            s[2 * i + 1] = char(lo);
        }
        return string(s);
    }

    function toAsciiString_bytes32(
        bytes32 _bytes32
    ) internal pure returns (string memory) {
        bytes memory bytesArray = new bytes(64);

        for (uint256 i = 0; i < 32; i++) {
            uint256 value = uint256(uint8(_bytes32[i]));
            bytes1 hi = bytes1(uint8((value >> 4) & 0xf));
            bytes1 lo = bytes1(uint8(value & 0xf));
            bytesArray[i * 2] = char(hi);
            bytesArray[i * 2 + 1] = char(lo);
        }
        return string(bytesArray);
    }

    function char(bytes1 b) internal pure returns (bytes1 c) {
        if (uint8(b) < 10) return bytes1(uint8(b) + 0x30);
        else return bytes1(uint8(b) + 0x57);
    }

    function calcHash() internal {
        string memory string_concat = string.concat(
            "0x",
            toAsciiString_address(profiles[owner].ID),
            profiles[owner].name,
            profiles[owner].dob,
            profiles[owner].image
        );
        hash = toAsciiString_bytes32(sha256(bytes(string_concat)));
    }

    function withdraw() public payable onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    function uint2str(
        uint256 _i
    ) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        while (_i != 0) {
            k = k - 1;
            uint8 temp = (48 + uint8(_i - (_i / 10) * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }
}
