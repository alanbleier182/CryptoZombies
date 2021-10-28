pragma solidity ^0.4.25;

import "./zombiefeeding.sol";

// Inherits from ZombieFeeding
contract ZombieHelper is ZombieFeeding {

  // You can pay ether to level up
  uint levelUpFee = 0.001 ether;

  // A simple modifier to make sure the zombie is above certain level
  modifier aboveLevel(uint _level, uint _zombieId) {
    require(zombies[_zombieId].level >= _level);
    _;
  }

  // A function to withdraw. Implements Open Zeppelin's onlyOwner contract
  function withdraw() external onlyOwner {
    address _owner = owner();
    _owner.transfer(address(this).balance);
  }

  // We can change the levelUpFee at any time with this function
  // Very useful given ether's σ (volatility)
  function setLevelUpFee(uint _fee) external onlyOwner {
    levelUpFee = _fee;
  }

  // Function has gotta be payable of course
  function levelUp(uint _zombieId) external payable {
    require(msg.value == levelUpFee);
    zombies[_zombieId].level = zombies[_zombieId].level.add(1);
  }

  // A function to change name. Only the owner of a given zombie can change it's name
  function changeName(uint _zombieId, string _newName) external aboveLevel(2, _zombieId) onlyOwnerOf(_zombieId) {
    zombies[_zombieId].name = _newName;
  }

  // If a zombie is above level 20 you can costumize it's dna
  function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) onlyOwnerOf(_zombieId) {
    zombies[_zombieId].dna = _newDna;
  }

  You can see a player's zombie army with this function
  function getZombiesByOwner(address _owner) external view returns(uint[]) {
    uint[] memory result = new uint[](ownerZombieCount[_owner]);
    uint counter = 0;
    for (uint i = 0; i < zombies.length; i++) {
      if (zombieToOwner[i] == _owner) {
        result[counter] = i;
        counter++;
      }
    }
    return result;
  }

}
