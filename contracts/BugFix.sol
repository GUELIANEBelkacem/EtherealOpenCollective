pragma solidity >=0.4.22 <0.9.0;

contract BugFix{

    uint public numPers  = 0;
    uint public numOrg  = 0;


    struct Pers{
        uint _id;
        string _name;
        address _account;
    }

    struct Org{
        uint _id;
        string _name;
        string _owner;
        string[] _members;
        address _account;
    }


}