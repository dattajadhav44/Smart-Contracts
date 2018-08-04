pragma solidity ^0.4.23;

contract Milaap {
    
    struct Petient {
        uint PetientId;
        address hospital;
        uint deadline;
        string desease;
    }
    
    Petient[] public PetientDetails;    
    address public manager;
    address public donator;
    mapping(address => uint) balanceOf;
    
    constructor(uint petientId, address hospital, uint deadline, string desease) public payable {
        Petient memory newPetient = Petient({
            petientId: petientId,
            hospital: hospital,
            deadline: deadline,
            desease: desease
        });
        manager = msg.sender;
        balanceOf[msg.sender] = msg.value;
        PetientDetails.push(newPetient);
    }
    
    function donate(address _reciever, uint _amount) public payable returns(bool success) {
        require(PetientDetails.deadline >= _amount && PetientDetails.deadline >= balanceOf[_reciever] && balanceOf[msg.sender] >= _amount);
        require(balanceOf[_reciever] + _amount >= _amount);
        balanceOf[msg.sender] -= _amount;
        balanceOf[_reciever] += _amount;
        donator = _reciever;
        return success;
    }
    
    function checkBalanceOfMilaap() public view returns(uint) {
        return balanceOf[manager];
    }
    
    function getBalance() public view returns(uint) {
        return balanceOf[donator];
    }
    
}