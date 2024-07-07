// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

// Imports
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract PayPool is ReentrancyGuard {
    // Data
    uint public totalBalance;
    address public owner;
    address[] public depositAddresses;
    mapping(address => uint256) public allowances;

    struct DepositRecord {
        address depositor;
        uint256 amount;
        uint256 timestamp;
        DepositStatus status;
    }

    enum DepositStatus { Pending, Approved, Rejected }

    DepositRecord[] public depositHistory;

    // Events
    event Deposit(address indexed depositor, uint256 amount);
    event AddressAdded(address indexed depositor);
    event AddressRemoved(address indexed depositor);
    event AllowanceGranted(address indexed user, uint amount);
    event AllowanceRemoved(address indexed user);
    event FundsRetrieved(address indexed recipient, uint amount);
    event DepositApproved(uint256 index);
    event DepositRejected(uint256 index);

    modifier isOwner() {
        require(msg.sender == owner, "Not owner!");
        _;
    }

    modifier gotAllowance(address user) {
        require(hasAllowance(user), "This address has no allowance");
        _;
    }

    modifier canDepositTokens(address depositor) {
        require(canDeposit(depositor), "This address is not allowed to deposit tokens");
        _;
    }

    constructor() payable {
        totalBalance = msg.value;
        owner = msg.sender;
    }

    // Internal functions
    function hasAllowance(address user) internal view returns(bool) {
        return allowances[user] > 0;
    }

    function canDeposit(address depositor) internal view returns(bool) {
        for (uint i = 0; i < depositAddresses.length; i++) {
            if (depositAddresses[i] == depositor) {
                return true;
            }
        }
        return false;
    }

    // Execute Functions
    function addDepositAddress(address depositor) external isOwner {
        depositAddresses.push(depositor);
        emit AddressAdded(depositor);
    }

    function removeDepositAddress(uint index) external isOwner canDepositTokens(depositAddresses[index]) {
        address removedAddress = depositAddresses[index];
        depositAddresses[index] = depositAddresses[depositAddresses.length - 1];
        depositAddresses.pop();
        emit AddressRemoved(removedAddress);
    }

    function deposit() external canDepositTokens(msg.sender) payable {
        totalBalance += msg.value;
        DepositRecord memory newRecord = DepositRecord({
            depositor: msg.sender,
            amount: msg.value,
            timestamp: block.timestamp,
            status: DepositStatus.Pending
        });
        depositHistory.push(newRecord);
        emit Deposit(msg.sender, msg.value);
    }

    function approveDeposit(uint256 index) external isOwner {
        require(index < depositHistory.length, "Invalid index");
        depositHistory[index].status = DepositStatus.Approved;
        emit DepositApproved(index);
    }

    function rejectDeposit(uint256 index) external isOwner {
        require(index < depositHistory.length, "Invalid index");
        depositHistory[index].status = DepositStatus.Rejected;
        emit DepositRejected(index);
    }

    function getDepositHistory() public view returns (DepositRecord[] memory) {
        return depositHistory;
    }

    function retrieveBalance() external isOwner nonReentrant {
        uint balance = totalBalance;
        totalBalance = 0;
        (bool success, ) = owner.call{value: balance}("");
        require(success, "Transfer failed");
        emit FundsRetrieved(owner, balance);
    }

    function giveAllowance(uint amount, address user) external isOwner {
        require(totalBalance >= amount, "There are not enough tokens inside the pool to give allowance");
        allowances[user] = amount;
        unchecked {
            totalBalance -= amount;
        }
        emit AllowanceGranted(user, amount);
    }

    function removeAllowance(address user) external isOwner gotAllowance(user) {
        allowances[user] = 0;
        emit AllowanceRemoved(user);
    }

    function allowRetrieval() external gotAllowance(msg.sender) nonReentrant {
        uint amount = allowances[msg.sender];
        allowances[msg.sender] = 0;
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Retrieval failed");
        emit FundsRetrieved(msg.sender, amount);
    }
}
