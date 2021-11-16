pragma solidity >=0.4.22 <0.9.0;

contract Project{

    uint256 idCount = 0;
    uint256 contributorCount = 0;
    struct Pers{
        uint256 _id;
        string _name;
        address _balance;
    }
    address owner;
    string public name;
    address balance;
    Pers[] public contributors;


    struct Bug{
        string name;
        uint256 bounty;
        bool completed;
    }

    function addContributor(uint256 _id, string memory _name, address _balance) public{
        contributors.push(Pers(_id, _name, _balance));
        contributorCount ++;
    }

}