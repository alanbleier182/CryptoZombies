pragma solidity ^0.4.25;

import "./zombiehelper.sol";

// Inherits from ZombieHelper
contract ZombieAttack is ZombieHelper {
  uint randNonce = 0;
  uint attackVictoryProbability = 70;

  // This function uses the present timestamp to produce a random number between 1 and 100
  // to calculate zombie's winning chances
  function randMod(uint _modulus) internal returns(uint) {
    randNonce = randNonce.add(1);
    return uint(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % _modulus;
  }

  // The basic attack function
  function attack(uint _zombieId, uint _targetId) external onlyOwnerOf(_zombieId) {
    Zombie storage myZombie = zombies[_zombieId];
    Zombie storage enemyZombie = zombies[_targetId];
    uint rand = randMod(100);
    // If zombie wins, the win count is increased, its level is increased and enemy's zombie's loss count is increased
    // then feedAndMultiplied is called to produce a new zombie.
    // feedAndMuktiply also calls _triggerCooldown, so no neew to call it here.
    if (rand <= attackVictoryProbability) {
      myZombie.winCount = myZombie.winCount.add(1);
      myZombie.level = myZombie.level.add(1);
      enemyZombie.lossCount = enemyZombie.lossCount.add(1);
      feedAndMultiply(_zombieId, enemyZombie.dna, "zombie");
      // If zombie losses its loss count is increased and enemy's zombie's win count is increased
      // _triggerCooldown is called after a loss too, but this time the function has to be explicitly called
    } else {
      myZombie.lossCount = myZombie.lossCount.add(1);
      enemyZombie.winCount = enemyZombie.winCount.add(1);
      _triggerCooldown(myZombie);
    }
  }
}
