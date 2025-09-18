// SPDX-License-Identifier: MIT
pragma solidity 0.8.20; //Do not change the solidity version as it negatively impacts submission grading

import "./ExampleExternalContract.sol";

contract Staker {
    ExampleExternalContract public exampleExternalContract;
    uint256 public deadline;

    constructor(address exampleExternalContractAddress) {
      exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
      deadline = block.timestamp + 72 hours;
    }

    // Collect funds in a payable `stake()` function and track individual `balances` with a mapping:
    // (Make sure to add a `Stake(address,uint256)` event and emit it for the frontend `All Stakings` tab to display)
    mapping (address => uint256) public balances;
    uint256 public constant threshold = 1 ether;
    bool public openForWithdraw = false;
    bool public executed = false;

    event Stake(address indexed sender, uint256 amount);

    function stake() public payable {
      require(block.timestamp < deadline, "Staking period is over!");
      
      balances[msg.sender] += msg.value;

      emit Stake(msg.sender, msg.value);
    }

    function execute() public {
      require(block.timestamp >= deadline, "Deadline not yet reached");
      require(!executed, "Already executed");

      if (address(this).balance >= threshold) {
        executed = true;
        exampleExternalContract.complete{value: address(this).balance}();
      } else {
        openForWithdraw = true;
      }
    }

    function timeLeft() public view returns (uint256) {
      if (block.timestamp >= deadline) {
        return 0;
      }
      return deadline - block.timestamp;
    }

    function withdraw() public {
        require(block.timestamp >= deadline, "Deadline not yet reached");
        require(address(this).balance < threshold, "Threshold was met");
        
        uint256 userBalance = balances[msg.sender];
        require(userBalance > 0, "Nothing to withdraw");
        
        balances[msg.sender] = 0;
        (bool sent, ) = msg.sender.call{value: userBalance}("");
        require(sent, "Withdraw failed");
    }

    // https://solidity-by-example.org/sending-ether/
    // Function to receive Ether. msg.data must be empty
    // If you want people to be able to send ETH to your contract, use this 
    receive() external payable {
      stake();
    }
}
