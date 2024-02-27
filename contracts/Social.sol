// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import ".././contracts/interface/INFTFactory.sol";

contract Social{
     NftFactoryInterface public nftFactory;

    constructor(address _nftFactoryAddress) {
        nftFactory = NftFactoryInterface(_nftFactoryAddress);
    }

    error ALREADY_REGISTERED();
    error INVALID_ADDRESS();
    error INVALID();
    error USER_HAS_NOT_CREATED_A_POST_YET();
    error POST_DOES_NOT_EXIST();
    error GROUP_ALREADY_CREATED();


    uint totalLikes;
    uint totalNFTS;
    address owner;

    enum Roles{
        isAdmin,
        User
    }

    struct Groups{
        uint id;
        string groupName;
        address[] members;
        bool isFilled;
           
    }

    struct Users{
        string name;
        uint8 age;
        uint id;
        Groups groups;
        Post post;
        bool isregistered;
      Roles roles;
    }

    struct Post{
        uint id;
        string title;
        string comment;
        bool like;


    }

    

    mapping(uint => mapping(address => Users)) users;
    // mapping (address => Users) users;
    Users[] usersArray;
    Post[] postArray;

    function registerUser(
        string memory _name,
        uint8 _age,
        uint8 _id

    ) public {
          if (!users[_id][msg.sender].isregistered){
            revert("ALREADY_REGISTERED");
        }
        Users memory newUser = users[_id][msg.sender];
        newUser.name = _name;
        newUser.age = _age;
        newUser.id = _id;

        usersArray.push(newUser);

    }


     function createPost(
        uint _id, 
        string memory _title, 
        string memory _comment, 
        bool _like, address _to, 
        uint256 _tokenId
        ) 
          public {
            
        if (_to == address(0)) {
            revert("INVALID_ADDRESS");
        }


        Post memory newPost = Post({
            id: _id,
            title: _title,
            comment: _comment,
            like: _like

            
        });
        postArray.push(newPost);
        nftFactory.createNFT(_to, _tokenId);
        totalNFTS = totalNFTS + 1;
    }

      function likePost(uint _postId) public {

         if (users[_postId][msg.sender].post.id == 0) {
        revert("USER_HAS_NOT_CREATED_A_POST_YET");
    }

    if (users[_postId][msg.sender].id == 0) {
        revert("POST_DOES_NOT_EXIST");
    }

        Users memory post = users[_postId][msg.sender];
        require(!post.post.like, "POST_ALREADY_LIKED");

        post = users[_postId][msg.sender];
        post.post.like= true;

        usersArray.push(post);
        totalLikes = totalLikes + 1;
    }

    function commentPost(uint _postId, string memory _comment) public{

        if (users[_postId][msg.sender].post.id == 0) {
        revert("USER_HAS_NOT_CREATED_A_POST_YET");
    }
        if(users[_postId][msg.sender].id == 0){
            revert("INVALID");
        }
        Users memory post = users[_postId][msg.sender];

        post = users[_postId][msg.sender];
        post.post.comment = _comment;

        usersArray.push(post);

    }

     function getPostForUser(uint _postId) public view returns (Post memory) {
         if (users[_postId][msg.sender].id == 0) {
        revert("POST_DOES_NOT_EXIST");
    }

          if (users[_postId][msg.sender].post.id == 0) {
        revert("USER_HAS_NOT_CREATED_A_POST_YET");
    }

        return users[_postId][msg.sender].post;
    }
    function getUserLikes() public view returns(uint){
        return totalLikes;

    }

    function GrantRole(Roles userRole, address _user, uint _id) private Onlyowner() {
       
         require(users[_id][_user].isregistered, "user not registered");
        if(userRole == Roles.isAdmin){
         users[_id][_user].roles = Roles.isAdmin;

        }


        }

function createGroup(
        uint _id,
        string memory _groupName
    ) public  Onlyowner()
    {

        Users memory  group = users[_id][msg.sender];
        if (!group.groups.isFilled){
            revert("GROUP_ALREADY_CREATED");
        }
        group.groups.groupName = _groupName;


    }

    function addMembertoGroup(uint _id) public {
        Users storage user = users[_id][msg.sender];
        user.groups.members.push(msg.sender);

    }

     modifier Onlyowner() {
            require(msg.sender == owner, "only owner can call this function");
            _;
        }

    }

      
























