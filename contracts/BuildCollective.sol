pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "./Ownable.sol";

contract BuildCollective is Ownable {
  struct User {
    string username;
    uint256 balance;
    bool registered;
  }

  struct Org{
    string name;
    address owner;
    address[] members;
    uint256 balance;
  }

  struct Project{
    string name;
    address owner;
    address[] contributors;
    uint256 balance;
  }

  struct Issue {
    string title;
    string description;
    string link;
    address owner; 
    uint256 reward; 
    bool resolved; 
  }

  mapping(address => User) private users;
  mapping(address => Org) private orgs; 
  mapping(address => Project[]) private projects;

  address[] public userReg;



  event UserSignedUp(address indexed userAddress, User indexed user);
  event OrgSignedUp(address indexed ownerAddress, Org indexed org);
  event ProjectCreated(address indexed ownerAddress, Project indexed project);




  function getUser(address _address) public view returns (User memory) {
    return users[_address];
  }
  function getAllUsers() external view returns (address[] memory) {
    return userReg;
  }

  function getOrg(address _address) public view returns (Org memory) {
    return orgs[_address];
  }

  function getProject(address _address) public view returns (Project[] memory){
    return projects[_address];
  }



  function signUp(string memory _name, uint256 _balance) public returns (User memory) {
    require(bytes(_name).length > 0, "User Name Is Empty");
    users[msg.sender] = User(_name, _balance, true);
    emit UserSignedUp(msg.sender, users[msg.sender]);
    userReg.push(msg.sender);
    return users[msg.sender];
  }

  function orgSignUp(string memory _name, address _owner, address[] memory _members, uint256 _balance) public returns (Org memory) {
    require(users[msg.sender].registered, "User Not Found");
    require(bytes(_name).length > 0, "Org Name Is Empty");
    orgs[msg.sender] = Org(_name, _owner, _members, _balance);
    emit OrgSignedUp(msg.sender, orgs[msg.sender]);
    return orgs[msg.sender];
  }

  function addProject(string memory _name, address _owner, address[] memory _contributors, uint256 _balance) public returns (Project memory) {
    require(users[msg.sender].registered, "User Not Found");
    require(bytes(_name).length > 0, "Project Name Is Empty");
    Project memory proj = Project(_name, _owner, _contributors, _balance);
    projects[msg.sender].push(proj);
    emit ProjectCreated(msg.sender, proj);
    return proj;
  }

  function addBalance(uint256 amount) public returns (bool) {
    require(users[msg.sender].registered, "User Not Found");
    users[msg.sender].balance += amount;
    return true;
  }




}
