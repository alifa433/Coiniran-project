// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    struct Poll {
        string title;
        string[] options;
        mapping(address => uint256) votes;
        uint256 closingDate;
        bool closed;
    }

    Poll[] public polls;
    address public owner;

    event PollCreated(uint256 pollId, string title);
    event Voted(uint256 pollId, uint256 optionId);

    constructor() {
        owner = msg.sender;
    }

    function createPoll(string memory _title, string[] memory _options, uint256 _closingDate) public {
        require(msg.sender == owner, "Only the owner can create polls");
        require(_options.length > 1, "At least two options required");

        Poll memory newPoll;
        newPoll.title = _title;
        newPoll.options = _options;
        newPoll.closingDate = _closingDate;
        polls.push(newPoll);

        emit PollCreated(polls.length - 1, _title);
    }

    function vote(uint256 _pollId, uint256 _optionId) public {
        require(_pollId < polls.length, "Poll does not exist");
        require(block.timestamp <= polls[_pollId].closingDate, "Poll is closed");
        require(_optionId < polls[_pollId].options.length, "Invalid option");

        polls[_pollId].votes[msg.sender] = _optionId;

        emit Voted(_pollId, _optionId);
    }

    function closePoll(uint256 _pollId) public {
        require(msg.sender == owner, "Only the owner can close polls");
        require(_pollId < polls.length, "Poll does not exist");

        polls[_pollId].closed = true;
    }

    function getPollCount() public view returns (uint256) {
        return polls.length;
    }
}
