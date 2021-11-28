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

  struct Bug {
    string title;
    string description;
    uint256 reward; 
    string[] proposals;
    address[] proposers;
    string fix;
    bool pending;
    bool resolved; 
    uint256 projId;
  }

  struct Project{
    string name;
    address owner;
    address[] contributors;
    uint256 balance;
    uint256 bugId;
  }


  uint256 private pid = 0;

  mapping(address => User) private users;
  mapping(address => Org) private orgs; 
  mapping(address => Project[]) private projects;
  mapping(address => Bug[]) private bugs;

  address[] public userReg;


  mapping(address => Org[]) private orgrefs; 
  mapping(address => Project[]) private projectrefs; 



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

  function getBugs(address _address) public view returns (Bug[] memory){
    return bugs[_address];
  }

  function getOrgRefs(address _address) public view returns (Org[] memory){
    return orgrefs[_address];
  }
  function getProjectRefs(address _address) public view returns (Project[] memory){
    return projectrefs[_address];
  }



  function signUp(string memory _name, uint256 _balance) public returns (User memory) {
    require(bytes(_name).length > 0, "User Name Is Empty");
    require(!listContains(userReg, msg.sender), "User Already Exists");
    users[msg.sender] = User(_name, _balance, true);
    emit UserSignedUp(msg.sender, users[msg.sender]);
    userReg.push(msg.sender);
    return users[msg.sender];
  }

  function orgSignUp(string memory _name, address _owner, address[] memory _members, uint256 _balance) public returns (Org memory) {
    require(users[msg.sender].registered, "User Not Found");
    require(bytes(_name).length > 0, "Org Name Is Empty");
    require(users[msg.sender].balance >= _balance, "Balace not Sufficient");
    orgs[msg.sender] = Org(_name, _owner, _members, _balance);
    emit OrgSignedUp(msg.sender, orgs[msg.sender]);
    users[msg.sender].balance = users[msg.sender].balance - _balance;
    return orgs[msg.sender];
  }

  function addProject(string memory _name, address _owner, address[] memory _contributors, uint256 _balance) public returns (Project memory) {
    require(users[msg.sender].registered, "User Not Found");
    require(bytes(_name).length > 0, "Project Name Is Empty");
    require(users[msg.sender].balance >= _balance, "Balace not Sufficient");
    Project memory proj = Project(_name, _owner, _contributors, _balance, pid);
    pid++;
    projects[msg.sender].push(proj);
    emit ProjectCreated(msg.sender, proj);
    users[msg.sender].balance = users[msg.sender].balance - _balance;
    return proj;
  }

  function addBalance(uint256 amount) public returns (bool) {
    require(users[msg.sender].registered, "User Not Found");
    users[msg.sender].balance += amount;
    return true;
  }


  function addMember(address _member) public{
    require(users[msg.sender].registered, "User Not Found");
    require(users[_member].registered, "Member Not Found");
    require(!listContains(orgs[msg.sender].members, _member), "Member Already Exists");
    orgs[msg.sender].members.push(_member);
    orgrefs[_member].push(orgs[msg.sender]);
  }

  function addContributor(address _member, uint256 _idx) public{
    require(users[msg.sender].registered, "User Not Found");
    require(users[_member].registered, "Member Not Found");
    require(!listContains(projects[msg.sender][_idx].contributors, _member), "Contributor Already Exists");
    projects[msg.sender][_idx].contributors.push(_member);
    projectrefs[_member].push(projects[msg.sender][_idx]);
  }

  function donateProject(address _owner, uint256 _idx, uint256 _amount) public{
    require(users[msg.sender].registered, "User Not Found");
    require(users[msg.sender].balance >= _amount, "Balace not Sufficient");
    projects[_owner][_idx].balance = projects[_owner][_idx].balance + _amount;
    users[msg.sender].balance = users[msg.sender].balance - _amount;
  }



  function addBug(uint256 _bugid, string memory _title, string memory _description, uint256 _reward) public{
    require(users[msg.sender].registered, "User Not Found");
    require(users[msg.sender].balance >= _reward, "Balace not Sufficient");
    string[] memory proposals;
    address[] memory proposers;
    string memory fix;
    bool  pending = false;
    bool resolved = false;
    Bug memory bug = Bug(_title, _description, _reward, proposals, proposers, fix, pending, resolved, _bugid);
    bugs[msg.sender].push(bug); 
    users[msg.sender].balance = users[msg.sender].balance - _reward; 
  }

  function proposeFix(address _owner, uint256 _idx, string memory _fix) public{
    bugs[_owner][_idx].proposals.push(_fix); 
    bugs[_owner][_idx].proposers.push(msg.sender); 
    bugs[_owner][_idx].pending = true;
  }

  function acceptFix(uint256 _idx, address _proposer) public{
    bugs[msg.sender][_idx].resolved = true; 
    bugs[msg.sender][_idx].fix = bugs[msg.sender][_idx].proposals[findIdx(bugs[msg.sender][_idx].proposers, _proposer)];
    users[_proposer].balance += bugs[msg.sender][_idx].reward;
  }

     

  function listContains(address[] memory lst, address a) private returns(bool){
    bool r = false;
    for (uint i=0; i<lst.length; i++) {
        if(lst[i] == a){r = true;}  
    }
    return r;
  }
  function findIdx(address[] memory lst, address a) private returns(uint256){
    uint256 r = 0;
    for (uint i=0; i<lst.length; i++) {
        if(lst[i] == a){r = i;}  
    }
    return r;
  }

}
