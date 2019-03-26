pragma solidity ^0.4.25;

// Import's Oppen Zeppelin's "ownable" (to verify owner) and "safemath" (to prevent overflows) contracts.
import "./ownable.sol";
import "./safemath.sol";

// This program creates a zombie factory.
// All created Zombies are permanently stored in the blockchain.

contract ZombieFactory is Ownable {

  // Preventing overflows
  // Maybe new versions of Solidity will to this be default, but in the meantime...
  using SafeMath for uint256;
  using SafeMath32 for uint32;
  using SafeMath16 for uint16;

  event NewZombie(uint zombieId, string name, uint dna);

  // We use the 16 digits to display zombie's appereance
  uint dnaDigits = 16;
  uint dnaModulus = 10 ** dnaDigits;
  uint cooldownTime = 1 days;

  struct Zombie {
    string name;
    uint dna;
    uint32 level;
    uint32 readyTime;
    uint16 winCount;
    uint16 lossCount;
  }

  // Zombie's are stored in an array
  Zombie[] public zombies;

  mapping (uint => address) public zombieToOwner;
  mapping (address => uint) ownerZombieCount;

  // Creates zombies
  function _createZombie(string _name, uint _dna) internal {
    // A new zombie is created (level 1, 0 wins and losses) and push into the array
    // First element of the array is zero, so substract 1
    uint id = zombies.push(Zombie(_name, _dna, 1, uint32(now + cooldownTime), 0, 0)) - 1;
    // This zombie belongs to its creator
    zombieToOwner[id] = msg.sender;
    // Add 1 to zombie count
    ownerZombieCount[msg.sender] = ownerZombieCount[msg.sender].add(1);
    // Inform the front-end about the creation of the zombie
    emit NewZombie(id, _name, _dna);
  }

  // The hash is calculated from the name as its seed, and made into a 16-digit unsigned integer
  function _generateRandomDna(string _str) private view returns (uint) {
    uint rand = uint(keccak256(abi.encodePacked(_str)));
    return rand % dnaModulus;
  }

  // Creates a random zombie for the first time
  function createRandomZombie(string _name) public {
    // This has to be the very first zombie
    require(ownerZombieCount[msg.sender] == 0);
    // Calculate dna hash
    uint randDna = _generateRandomDna(_name);
    randDna = randDna - randDna % 100;
    // Calls the _createZombie function with the randomized dna
    _createZombie(_name, randDna);
  }

}

