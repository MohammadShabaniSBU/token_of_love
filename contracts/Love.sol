
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TokenOfLove is IERC20 {

    struct Friend {
        address outgoing;
        address friend;
        bool hasFriend;
        address[] incoming;
        bool thinkingAboutYou;
        uint256 lastDayOfThinking;
    }
    mapping(address => Friend) public friends;
    mapping (address => uint256) public balances;
    mapping (address => mapping (address => uint256)) public _allowances;


    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function name() external view  returns (string memory) {
        return _name;
    }
    function symbol() external view  returns (string memory) {
        return _symbol;
    }

    function daysSinceEpoch() public returns (uint256) {
        uint256 timestamp = block.timestamp;
        return timestamp / 86400;
    }

    function getHour() public  returns (uint256) {
        uint256 timestamp = block.timestamp;
        uint256 secondsInADay = 24 * 60 * 60;

        uint256 secondsSinceStartOfDay = timestamp % secondsInADay;

        uint256 hour = secondsSinceStartOfDay / 3600;

        return (hour+3)%24;
    }

    function getMinute() public  returns (uint256) {
        uint256 timestamp = block.timestamp;
        uint256 secondsInADay = 24 * 60 * 60;

        uint256 secondsSinceStartOfDay = timestamp % secondsInADay;

        uint256 remainingSecond = secondsSinceStartOfDay % 3600;

        uint256 minute = remainingSecond / 60;

        return (minute + 30) % 60;
    }

    
    function getSecond() public  returns (uint256) {
        uint256 timestamp = block.timestamp;
        uint256 secondsInADay = 24 * 60 * 60;

        uint256 secondsSinceStartOfDay = timestamp % secondsInADay;

        uint256 remainingSecond = secondsSinceStartOfDay % 3600;

        uint256 second = remainingSecond % 60;

        return second;
    }

    function weAreFriends (address toBeFriendAddress) external
    {

        Friend storage friend = friends[msg.sender];
        require(!friend.hasFriend , "Are you non-monogamous?");
        Friend storage toBeFriend = friends[toBeFriendAddress];
        require(!toBeFriend.hasFriend , "is he non-monogamous?");
        bool isFound = false;
        for (uint i = 0; i < friend.incoming.length; i++) {
            if (friend.incoming[i] == toBeFriendAddress) {
                isFound = true;
                friend.incoming[i] = friend.incoming[friend.incoming.length-1];
                friend.incoming.pop();
                break;
            }
        }
        if (isFound)
        {
            makeFriend(msg.sender ,toBeFriendAddress );
        }
        else {
            toBeFriend.incoming.push(msg.sender);
            friend.outgoing = toBeFriendAddress;
        }
    
    }
    function makeFriend(address friendAddress,address toBeFriendAddress) public
    {
        Friend storage toBeFriend = friends[toBeFriendAddress];
        require(toBeFriend.outgoing == friendAddress," he doesnt like you anymore :(");
        require(!toBeFriend.hasFriend," he found another one :(");
        toBeFriend.hasFriend = true;
        toBeFriend.friend = friendAddress;
        Friend storage friend = friends[friendAddress];
        friend.hasFriend = true;
        friend.friend = toBeFriendAddress;
    }

    function thoughtOfThem() external 
    {
        uint256 today = daysSinceEpoch();
        // require(getHour() >= 11 && getMinute() >= 11 && getSecond() >= 0 , "not the right time");
        // require(getHour() <= 11 && getMinute() <= 11 && getSecond() <= 59 , "not the right time");
        Friend storage friend = friends[msg.sender];
        // require(friend.hasFriend , "You are single my friend");
        // require(friend.lastDayOfThinking < today, "you have tought once today");
        friend.lastDayOfThinking = today;
        friend.thinkingAboutYou = true;
        if (friends[friend.friend].thinkingAboutYou)
        {
            _mint(msg.sender, friend.friend);
        }
    }

    function _mint(address friend1Address,address friend2Address) public {

        Friend storage friend1 = friends[friend1Address];
        Friend storage friend2 = friends[friend2Address];
        friend1.thinkingAboutYou = false;
        friend2.thinkingAboutYou = false;
        _allowances[friend1Address][friend2Address] +=100;
        _allowances[friend2Address][friend1Address] +=100;
        
    }

    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }


    function transfer(address to, uint256 value) external returns (bool) {
        address from = msg.sender;
        _transfer(from,to,value);
        return true;
    }

    function _transfer(address from,address to, uint256 value) public {
        require(balances[from] >=value,"insufficient funds");
        balances[from] -= value;
        balances[to] += value;

    }

    
    function allowance(address owner, address spender) external view returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 value) external returns (bool) {
        require(true == false ,"you are friends and friends do not need approval");
    }

    function balanceOf(address account) external view returns (uint256) { 
        return balances[account];
    }

    function transferFrom(address from, address to, uint256 value) external returns (bool) {
        require(_allowances[from][msg.sender] >= value, "you are not allowed");
        require(friends[msg.sender].hasFriend , "but you are not friends");
        require(from == friends[msg.sender].friend , "but you are not friends");
        _allowances[from][msg.sender] -= value;
        balances[to] += value;
        return true;
    }


    function weCut() external {
        Friend storage friend = friends[msg.sender];
        require(friend.hasFriend," but you dont have friends :(");
        Friend storage friend2 = friends[friend.friend];
        friend.hasFriend = false;
        friend2.hasFriend = false;
    }
    

    function get_allowance() external view returns (uint256)
    {
        return _allowances [msg.sender][friends[msg.sender].friend];
    }   

}

