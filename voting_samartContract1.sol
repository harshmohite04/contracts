// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Vote {
    //first entity
    struct Voter {
        string name;
        uint256 age;
        uint256 voterId;
        Gender gender; // Gender is enum
        uint256 voteCandidateId; //candidate id to whom the voter has voted
        address voterAddress; //EOA(External Owned Account) of the voter
    }

    //second entity
    struct Candidate {
        string name;
        string party;
        uint256 age;
        Gender gender;
        uint256 candidateId;
        address candidateAddress; //candidate EOA
        uint256 votes; //number of votes
    }

    //third entity
    address public electionCommission;
    address public winner;
    uint256 nextVoterId = 1;
    uint256 nextCandidateId = 1;

    //voting period
    uint256 startTime;
    uint256 endTime;
    bool stopVoting;

    mapping(uint256 => Voter) voterDetails;
    mapping(uint256 => Candidate) candidateDetails;

    enum VotingStatus {
        NotStarted,
        InProgress,
        Ended
    }
    enum Gender {
        NotSpecified,
        Male,
        Female,
        Other
    }

    constructor() {
        electionCommission = msg.sender; //msg.sender is a global variable
    }

    modifier isVotingOver() {
        require(
            block.timestamp <= endTime && stopVoting == false,
            "Voting time is over"
        );
        _;
    }

    // end time - 1720540700 - Tuesday, 9 July 2024 21:28:20
    // current time - 1720540861 - Tuesday, 9 July 2024 21:31:01

    modifier onlyCommissioner() {
        require(msg.sender == electionCommission, "Not authuorized");
        _;
    }

    modifier isValidAge(uint256 _age) {
        require(_age >= 18, "You are not Eligble");
        _;
    }

    function registerCandidate(
        string calldata _name,
        string calldata _party,
        uint256 _age,
        Gender _gender
    ) external isValidAge(_age) {
        require(
            isCandidateNotRegistered(msg.sender),
            "You have already registered"
        );
        require(nextCandidateId < 3, "Candidate Register is Full");
        require(
            msg.sender != electionCommission,
            "You can't be Candidate and electionCommission at same time"
        );
        candidateDetails[nextCandidateId] = Candidate({
            name: _name,
            party: _party,
            age: _age,
            gender: _gender,
            candidateId: nextCandidateId,
            candidateAddress: msg.sender,
            votes: 0
        });
        nextCandidateId++;
    }

    function isCandidateNotRegistered(address _person)
        private
        view
        returns (bool)
    {
        for (uint256 i = 1; i < nextCandidateId; i++) {
            if (candidateDetails[i].candidateAddress == _person) {
                return false;
            }
        }
        return true;
    }

    function getCandidateList() public view returns (Candidate[] memory) {
        Candidate[] memory candidateList = new Candidate[](nextCandidateId - 1);
        for (uint256 i = 0; i < candidateList.length; i++) {
            candidateList[i] = candidateDetails[i + 1];
        }
        return candidateList;
    }

    function isVoterNotRegistered(address _person) private view returns (bool) {
        for (uint256 i = 1; i < nextVoterId; i++) {
            if (voterDetails[i].voterAddress == _person) {
                return false;
            }
        }
        return true;
    }

    //    //first entity
    // struct Voter {
    //     string name;
    //     uint age;
    //     uint voterId;
    //     Gender gender; // Gender is enum
    //     uint voteCandidateId; //candidate id to whom the voter has voted
    //     address voterAddress; //EOA(External Owned Account) of the voter
    // }

    function registerVoter(
        string calldata _name,
        uint256 _age,
        Gender _gender
    ) external {
        require(isVoterNotRegistered(msg.sender), "You have already Voted");
        voterDetails[nextVoterId] = Voter({
            name: _name,
            age: _age,
            voterId: nextVoterId,
            gender: _gender,
            voteCandidateId: 0,
            voterAddress: msg.sender
        });
        nextVoterId++;
    }

    function getVoterList() public view returns (Voter[] memory) {
        Voter[] memory voterList = new Voter[](nextVoterId - 1);
        for (uint256 i = 0; i < voterList.length; i++) {
            voterList[i] = voterDetails[i + 1];
        }
        return voterList;
    }

    function castVote(uint256 _voterId, uint256 _candidateId)
        external
        isVotingOver
    {
        require(
            voterDetails[_voterId].voteCandidateId == 0,
            "you have already vote"
        );
        require(
            voterDetails[_voterId].voterAddress == msg.sender,
            "You dont belong to this account"
        );
        require(
            _candidateId >= 1 && _candidateId < 3,
            "Candidate is not correct"
        );
        voterDetails[_voterId].voteCandidateId = _candidateId;
        candidateDetails[_candidateId].votes++;
    }

    function setVotingPeriod(
        uint256 _startTimeDuration,
        uint256 _endTimeDuration
    ) external onlyCommissioner {
        startTime = block.timestamp + _startTimeDuration;
        endTime = startTime + _endTimeDuration;
    }

    function getVotingStatus() public view returns (VotingStatus) {
        if(startTime==0){
            return VotingStatus.NotStarted;
        }else if(endTime>block.timestamp && stopVoting==false){
            return VotingStatus.InProgress;
        }else{
            return VotingStatus.Ended;
        }
    }

    function announceVotingResult() external onlyCommissioner {
        uint maxVote=0;
        address winningCandidate;
        for(uint i = 1 ; i<nextCandidateId;i++){
            if(candidateDetails[i].votes>maxVote){
            maxVote=candidateDetails[i].votes;
            winningCandidate=candidateDetails[i].candidateAddress;
            }
        }
        require(maxVote > 0, "No votes cast.");
    winner = winningCandidate;
    }

    function emergencyStopVoting() public onlyCommissioner {
        stopVoting = true;
    }

    //if votingStatus==NotStarted then do this
    //else if votingStatus==Started then do that
    //else bla bla
}
