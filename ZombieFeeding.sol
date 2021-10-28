pragma solidity ^0.4.25;

import "./zombiefactory.sol";

// A kitty interface with the attributes found in their code
contract KittyInterface {
  function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
  );
}

contract ZombieFeeding is ZombieFactory {

  // Create interface
  KittyInterface kittyContract;

  // Using "onlyOwner" would throw an error at compilation
  modifier onlyOwnerOf(uint _zombieId) {
    require(msg.sender == zombieToOwner[_zombieId]);
    _;
  }

  // To interact with kitties, we need to create an interface and give it an address
  function setKittyContractAddress(address _address) external onlyOwner {
    kittyContract = KittyInterface(_address);
  }

  // uses timestamp now to calculate cooldownTime. uint32 is enough to prevent overflow until year 2038
  function _triggerCooldown(Zombie storage _zombie) internal {
    _zombie.readyTime = uint32(now + cooldownTime);
  }

  // Zombie can attack and feed now
  function _isReady(Zombie storage _zombie) internal view returns (bool) {
      return (_zombie.readyTime <= now);
  }

  // This function feeds the zombie and spawns a new zombie with new dna.
  // If the victim is a zombie-kitty, then the new zombie will be too.
  function feedAndMultiply(uint _zombieId, uint _targetDna, string _species) internal onlyOwnerOf(_zombieId) {
    Zombie storage myZombie = zombies[_zombieId];
    require(_isReady(myZombie));
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myZombie.dna + _targetDna) / 2;
    if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {
      newDna = newDna - newDna % 100 + 99;
    }
    // New zombies are all called "NoName"
    _createZombie("NoName", newDna);
    // Call _triggerCooldown at the end of the function
    _triggerCooldown(myZombie);
  }

  // You can feed on kitties too
  function feedOnKitty(uint _zombieId, uint _kittyId) public {
    uint kittyDna;
    // the kitty interface has 10 values: isGestating, isReady, etc...
    // We're only interested in its dna, that's why we have 9 commas here
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    // Passes "kitty" as the species, as well as the kittie's dna
    feedAndMultiply(_zombieId, kittyDna, "kitty");
  }
}
