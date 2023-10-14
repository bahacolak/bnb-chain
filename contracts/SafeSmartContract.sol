// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SafeSmartContract {
    mapping(address => Compartment) public userCompartments;

    struct Compartment {
        uint256 lockedAmount;
        uint256 lockDuration;
        uint256 reward;
    }

    event TokensLocked(address indexed user, uint256 amount, uint256 duration);
    event RewardCalculated(address indexed user, uint256 reward);

    function lockTokens(uint256 duration) public payable {
        require(duration > 0, "Kilitleme suresi sifirdan buyuk olmalidir.");
        require(msg.value > 0, "Kilitleme miktari sifirdan buyuk olmalidir.");

        userCompartments[msg.sender].lockedAmount += msg.value;
        userCompartments[msg.sender].lockDuration = duration;
        userCompartments[msg.sender].reward = 0;

        emit TokensLocked(msg.sender, msg.value, duration);
    }

    function calculateReward() public {
        require(userCompartments[msg.sender].lockDuration > 0, "Kilitleme suresi tanimlanmamis.");
        require(block.timestamp >= (block.timestamp + userCompartments[msg.sender].lockDuration), "Kilitleme suresi dolmadan odul hesaplanamaz.");

        uint256 reward = calculateRewardLogic();
        userCompartments[msg.sender].reward += reward;

        emit RewardCalculated(msg.sender, reward);
    }

    function calculateRewardLogic() private view returns (uint256) {
    require(userCompartments[msg.sender].lockDuration > 0, "Kilitleme suresi tanimlanmamis.");
    
    uint256 lockDuration = userCompartments[msg.sender].lockDuration;
    uint256 lockedAmount = userCompartments[msg.sender].lockedAmount;
    uint256 reward = lockedAmount * lockDuration / 100;

    return reward;
}


    function withdrawReward() public {
        uint256 reward = userCompartments[msg.sender].reward;
        require(reward > 0, "Cekecek odul bulunamadi.");

        userCompartments[msg.sender].reward = 0;
        payable(msg.sender).transfer(reward);
    }
}
