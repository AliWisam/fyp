// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.6.2;

contract Voting {

  // We use the struct datatype to store the voter information.
  struct voter {
    address voterAddress; // The address of the voter
    uint tokensBought;    // The total no. of tokens this voter owns
    uint[] tokensUsedPerCandidate; // Array to keep track of votes per candidate.
    
    
    /* We have an array of candidates initialized below.
     Every time this voter votes with his tokens, the value at that
     index is incremented. Example, if candidateList array declared
     below has ["Ali", "Ayaz", "Sibghat"] and this
     voter votes 10 tokens to Nick, the tokensUsedPerCandidate[1]
     will be incremented by 10.
     */
  }
       //it fetches voter info
    mapping (address => voter) public voterInfo;
  /* 
   The key of the mapping is candidate name stored as type bytes32 and value is
   an unsigned integer which used to store the vote count
   */
    mapping (bytes32 => uint) public votesReceived;

  /* Solidity doesn't let you return an array of strings yet. We will use an array of bytes32
   instead to store the list of candidates
   */
   
  bytes32[] public candidateList;

  uint public totalTokens; // Total no. of tokens available for this election
  uint public balanceTokens; // Total no. of tokens still available for purchase
  uint public tokenPrice; // Price per token

  /* When the contract is deployed on the blockchain, we will initialize
   the total number of tokens for sale, cost per token and all the candidates
   */
  constructor(uint tokens, uint pricePerToken, bytes32[] memory candidateNames) public {
    candidateList = candidateNames;
    totalTokens = tokens;
    balanceTokens = tokens;
    tokenPrice = pricePerToken;
  }
  
  function buy() payable public {
    uint tokensToBuy = msg.value / tokenPrice;
    
    require(tokensToBuy <= balanceTokens);
    
    voterInfo[msg.sender].voterAddress = msg.sender;
    voterInfo[msg.sender].tokensBought += tokensToBuy;
    balanceTokens -= tokensToBuy;
  }
  
  
   function voteForCandidate(bytes32 candidate, uint tokens) public {
    // Check to make sure user has enough tokens to vote
    // Increment vote count for candidate
    // Update the voter struct tokensUsedPerCandidate for this voter 
     
    uint availableTokens = voterInfo[msg.sender].tokensBought - totalTokensUsed(voterInfo[msg.sender].tokensUsedPerCandidate);
   
    require(tokens <= availableTokens, "You don't have enough tokens");
    votesReceived[candidate] += tokens;
     
    if(voterInfo[msg.sender].tokensUsedPerCandidate.length == 0) {
      for(uint i=0; i<candidateList.length; i++) {
        voterInfo[msg.sender].tokensUsedPerCandidate.push(0);
      }
    }
     
    uint index = indexOfCandidate(candidate);
    voterInfo[msg.sender].tokensUsedPerCandidate[index] += tokens;
     
  }
   
  function indexOfCandidate(bytes32 candidate) view public returns(uint) {
    for(uint i=0; i<candidateList.length; i++) {
      if (candidateList[i] == candidate) {
        return i;
      }
    }
    return uint(-1);
  }

  function totalTokensUsed(uint[] memory _tokensUsedPerCandidate) private pure returns (uint) {
    uint totalUsedTokens = 0;
    for(uint i=0; i<_tokensUsedPerCandidate.length; i++) {
    totalUsedTokens += _tokensUsedPerCandidate[i];
    }
    return totalUsedTokens;
  } 
  
    function voterDetails(address user) view public returns (uint, uint[] memory) {
    return (voterInfo[user].tokensBought, voterInfo[user].tokensUsedPerCandidate);
  }
   
  function tokensSold() public view returns (uint) {
    return totalTokens - balanceTokens;
  }
   
  function allCandidates() public view returns (bytes32[] memory) {
    return candidateList;
  }
   
  function totalVotesFor(bytes32 candidate) public view returns (uint) {
    return votesReceived[candidate];
  }

}
