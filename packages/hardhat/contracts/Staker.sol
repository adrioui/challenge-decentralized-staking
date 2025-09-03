// SPDX-License-Identifier: MIT
pragma solidity 0.8.20; //Do not change the solidity version as it negatively impacts submission grading

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

contract Staker {
    ExampleExternalContract public exampleExternalContract;

    constructor(address exampleExternalContractAddress) {
        exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
    }

    // Collect funds in a payable `stake()` function and track individual `balances` with a mapping:
    // (Make sure to add a `Stake(address,uint256)` event and emit it for the frontend `All Stakings` tab to display)
    mapping (address => uint256) public balance;
    uint256 public constant threshold = 1 ether;

    event Stake(address indexed sender, uint256 amount);

    function stake(uint256 amount) public payable {
      require(amount <= threshold, "You pass the threshold!");
      
      balance[msg.sender] += amount;

      emit Stake(msg.sender, balance[msg.sender]);
    }

    // After some `deadline` allow anyone to call an `execute()` function
    // If the deadline has passed and the threshold is met, it should call `exampleExternalContract.complete{value: address(this).balance}()`

    // If the `threshold` was not met, allow everyone to call a `withdraw()` function to withdraw their balance

    // Add a `timeLeft()` view function that returns the time left before the deadline for the frontend

    // Add the `receive()` special function that receives eth and calls stake()

    // https://solidity-by-example.org/sending-ether/
    // Function to receive Ether. msg.data must be empty
    // If you want people to be able to send ETH to your contract, use this 
    receive() external payable {}
}
