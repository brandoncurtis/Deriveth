pragma solidity ^0.4.17;

import "https://github.com/DecentralizedDerivatives/Deriveth/Swap.sol";

contract Factory {
    address[] public newContracts;
    address public creator;
    address public oracleID; //address of Oracle
    uint public fee; //Cost of contract in Wei

    modifier onlyOwner{require(msg.sender == creator); _;}
    event Print(address _name, address _value);
    event FeeChange(uint _newValue);

    function Factory (address _oracleID, uint _fee) public{
        creator = msg.sender;  
        oracleID = _oracleID;
        fee = _fee;
    }

    function setFee(uint _fee) public onlyOwner{
      fee = _fee;
      FeeChange(fee);
    }

    //This is the function participants will call.  Pay the fee, get returned your new swap address
    function createContract () public payable returns (address){
        require(msg.value == fee);
        address newContract = new Swap(oracleID,msg.sender,creator);
        newContracts.push(newContract);
        Print(msg.sender,newContract); //This is an event and allows DDA/ participants to see when new contracts are pushed.
        return newContract;
    } 
    function withdrawFee() public onlyOwner {
        creator.transfer(this.balance);
    }
}

