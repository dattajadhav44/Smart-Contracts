pragma solidity ^0.4.23;

contract Compaign{
    struct Request {
        string description;
        uint value;
        address recipient;
        bool complete;
        uint approvalCount;
        mapping(address => bool) approvals;
    }
    Request[] public requests;
    address public manager;
    uint public minimumContrubution;
    mapping(address => bool) public approvers;
    uint public approversCount;
    
    constructor(uint minimum) public {
        manager = msg.sender;
        minimumContrubution = minimum;
    }
    
    modifier restricted() {
        if(msg.sender == manager){
            _;
        }
    }
    function Contrubute() public payable {
        require(msg.value > minimumContrubution);
        approvers[msg.sender] = true;
        approversCount++;
    }
    
    function createRequest(string description, uint value, address recipient) public restricted {
       Request memory newRequest = Request({
          description: description,
          value: value,
          recipient: recipient,
          complete: false,
          approvalCount: 0
       });
       
       requests.push(newRequest);
    }
       
    function approveRequest(uint index) public {
        
        Request storage request = requests[index];
        
        require(approvers[msg.sender]);
        require(!request.approvals[msg.sender]);
        
        request.approvalCount++;
        request.approvals[msg.sender] = true;
                               
    }
    
    function finalizeRequest(uint index) public restricted {
        Request storage request = requests[index];
        
        require(request.approvalCount > approversCount / 2);
        require(!request.complete);
        
        request.recipient.transfer(request.value);
        request.complete = true;
        
    }
    
    
}