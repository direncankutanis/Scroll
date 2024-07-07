# BasicDAO Contract

This is a simple Decentralized Autonomous Organization (DAO) contract written in Solidity. It allows users to create proposals, vote on them, and execute them based on predefined rules.

## Contract Deployment on Scroll Sepholia Testnet

The `basicDAO` contract has been successfully deployed on the Scroll Sepholia Testnet.

- **Contract Address**: 0x1377c2b607be56f1cd079292a8249c50e5663704
- **Testnet Address**: 0x4e364d825E648586F4C25a5EEB4F70608ea3B5Ec
- **Transaction Hash**: [0x1fa57a167565d263456182d01385cf6dc3897e1bdca935a26bb84c6f048dc4ec](https://scroll.io/tx/0x1fa57a167565d263456182d01385cf6dc3897e1bdca935a26bb84c6f048dc4ec)
- **Transaction Action**: Contract Deployment
- **Block**: 5278321
- **Timestamp**: Jul-07-2024 09:34:55 AM UTC

## Features

- **Proposal Creation**: Users can create proposals with a description and a voting deadline.
- **Voting**: Members can vote on proposals within the specified voting duration.
- **Execution**: Proposals can be executed if they meet the required support threshold after the voting period ends.
- **Ownership**: The contract owner has exclusive rights to execute proposals.

## Contract Details

- **Owner**: The owner is the address that deployed the contract and has special privileges, including the ability to execute proposals.
- **Voting Duration**: Defines how long (in seconds) each proposal remains open for voting.

## Contract Functions

### `createProposal`

Creates a new proposal with a description. Each proposal gets a unique identifier and includes details such as creation time, deadline, and initial vote counts.

### `vote`

Allows a member to vote (support or oppose) a proposal. Each member can vote only once per proposal.

### `executeProposal`

Executes a proposal if it has received enough support and the voting period has ended.

### `getProposalDetails`

Retrieves details of a specific proposal by its identifier, including description, creation time, deadline, vote counts, and execution status.

## Usage

1. **Deploying the Contract**: Deploy the `basicDAO` contract, specifying the voting duration in seconds.
2. **Creating Proposals**: Call `createProposal` with a description to propose actions.
3. **Voting**: Members can vote using the `vote` function within the specified voting period.
4. **Execution**: After the voting period ends, the owner can execute proposals that received sufficient support.

## Example

Deploy the contract with a 7-day voting duration:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract YourDAOName {
    // Contract code here
}
```

Replace `YourDAOName` with the actual name of your contract. Use this template to set up and manage decentralized decision-making processes efficiently within your organization.

## Contact

For questions or support, contact the contract owner at direnkutanis@gmail.com.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.