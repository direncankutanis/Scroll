// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract basicDAO {
    struct Proposal {
        uint id;
        string description;
        uint creationTime;
        uint deadline;
        uint yesVotes;
        uint noVotes;
        bool executed;
        address[] voters; 
    }

    mapping(uint => Proposal) public proposals;
    uint public proposalCount;
    address public owner;
    uint public votingDuration; 

    event ProposalCreated(uint indexed proposalId, string description, uint deadline);
    event Voted(uint indexed proposalId, address indexed voter, bool supportsProposal);
    event ProposalExecuted(uint indexed proposalId, uint yesVotes, uint noVotes);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can execute this");
        _;
    }

    constructor(uint _votingDuration) {
        owner = msg.sender;
        votingDuration = _votingDuration;
    }

    /// @dev Creates a new proposal with the given description.
    function createProposal(string memory _description) public {
        uint currentTime = block.timestamp;
        uint deadline = currentTime + votingDuration;

        proposalCount++; // Increment proposalCount to get a unique proposalId

        // Initialize an empty array of type address for voters
        address[] memory emptyVoters;

        proposals[proposalCount] = Proposal({
            id: proposalCount,
            description: _description,
            creationTime: currentTime,
            deadline: deadline,
            yesVotes: 0,
            noVotes: 0,
            executed: false,
            voters: emptyVoters
        });

        emit ProposalCreated(proposalCount, _description, deadline);
    }

    /// @dev Allows a voter to vote on a proposal.
    function vote(uint _proposalId, bool _supportsProposal) public {
        Proposal storage proposal = proposals[_proposalId];
        require(!proposal.executed, "Proposal already executed");
        require(!isVoter(_proposalId, msg.sender), "You have already voted");
        require(block.timestamp < proposal.deadline, "Voting period has ended");

        if (_supportsProposal) {
            proposal.yesVotes++;
        } else {
            proposal.noVotes++;
        }

        proposal.voters.push(msg.sender); // Add the voter to the array of voters

        emit Voted(_proposalId, msg.sender, _supportsProposal);
    }

    /// @dev Checks if a voter has already voted on a proposal.
    function isVoter(uint _proposalId, address _voter) internal view returns (bool) {
        Proposal storage proposal = proposals[_proposalId];
        for (uint i = 0; i < proposal.voters.length; i++) {
            if (proposal.voters[i] == _voter) {
                return true;
            }
        }
        return false;
    }

    /// @dev Executes a proposal if conditions are met.
    function executeProposal(uint _proposalId) public onlyOwner {
        Proposal storage proposal = proposals[_proposalId];
        require(!proposal.executed, "Proposal already executed");
        require(block.timestamp >= proposal.deadline, "Voting period has not ended yet");
        require(proposal.yesVotes > proposal.noVotes, "Proposal did not receive enough support");

        proposal.executed = true;

        emit ProposalExecuted(_proposalId, proposal.yesVotes, proposal.noVotes);

        // Implement your logic here for proposal execution
    }

    /// @dev Retrieves details of a proposal.
    function getProposalDetails(uint _proposalId) public view returns (
        uint id,
        string memory description,
        uint creationTime,
        uint deadline,
        uint yesVotes,
        uint noVotes,
        bool executed
    ) {
        Proposal storage proposal = proposals[_proposalId];
        return (
            proposal.id,
            proposal.description,
            proposal.creationTime,
            proposal.deadline,
            proposal.yesVotes,
            proposal.noVotes,
            proposal.executed
        );
    }
}
