// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;


import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BattleOfTheBlockchain is ERC721Enumerable, Ownable {

    using Strings for uint256;
 
    string public baseURI;
 
    string public baseExtension = ".json";
 
    uint256 private cost = 2 ether;
 
    uint256 private presaleCost = 1.75 ether;
 
    uint256 public maxSupply = 10000;
 
    uint256 public presaleNftPerAddress = 3;

    uint256 public maxMintAmount = 10;
 
    uint256 public presaleOpenTime;

    uint private blockTime;

    uint public presaleDuration= 60 minutes;
 
    bool public paused = false;
 
    mapping(address => bool) public whitelistedAddresses;
 
    mapping(address => uint256) public addressMintedBalance;

    event PresaleStarted(string _presaleStarted);

 
    constructor(
        string memory _name,
        string memory _symbol,
        string memory _initBaseURI
    ) ERC721(_name, _symbol) {
        setBaseURI(_initBaseURI);
        blockTime = block.timestamp;
    }
 
    // internal
    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
 
    }
 
    function setPresaleOpenTime(uint _presaleOpenTime) external onlyOwner {
        presaleOpenTime = _presaleOpenTime;
        emit PresaleStarted("Presale Started");
    }


    // public
    function mint(uint256 _mintAmount) external payable {
        require(!paused, "the contract is paused");
        uint256 supply = totalSupply();
        require(_mintAmount > 0, "need to mint at least 1 NFT");
        require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
        require(block.timestamp >= presaleOpenTime, "too soon");
        require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
        if(block.timestamp <= presaleOpenTime + presaleDuration) {
                require(whitelistedAddresses[msg.sender], "user is not whitelisted");
                uint256 ownerMintedCount = addressMintedBalance[msg.sender];
                require(ownerMintedCount + _mintAmount <= presaleNftPerAddress, "max NFT per address exceeded");
                require(msg.value >= presaleCost * _mintAmount, "insufficient funds");
        }else if (block.timestamp > presaleOpenTime + presaleDuration) {
            require(msg.value >= cost * _mintAmount, "insufficient funds");
        }
      
        for (uint256 i = 1; i <= _mintAmount; i++) {
            addressMintedBalance[msg.sender]++;
            _safeMint(msg.sender, supply + i);
        }
    }

    function getPrice() external view returns(uint){
      if(blockTime <= presaleOpenTime + presaleDuration) {
        return cost;
      }else{
          return presaleCost;
      }
    }
 
    function ownerTokenCount(address _owner)
        external
        view
        returns (uint256[] memory)
    {
        uint256 OwnerTokenCount = balanceOf(_owner);
        uint256[] memory tokenIds = new uint256[](OwnerTokenCount);
        for (uint256 i; i < OwnerTokenCount; i++) {
          tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
        }
        return tokenIds;
    }
 
    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
        _exists(tokenId),
        "ERC721Metadata: URI query for nonexistent token"
        );
        string memory currentBaseURI = _baseURI();
        return bytes(currentBaseURI).length > 0
            ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
            : "";
    }
    
    function setPresaleNftPerAddress(uint256 _limit) external onlyOwner {
        presaleNftPerAddress = _limit;
    }

    function setMaxMintAmount(uint256 _amount) external onlyOwner {
        maxMintAmount = _amount;
    }
    
    function setCost(uint256 _newCost) external onlyOwner {
        cost = _newCost;
    }
  
    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }
  
    function setBaseExtension(string memory _newBaseExtension) external onlyOwner {
        baseExtension = _newBaseExtension;
    }
  
    function pause(bool _state) external onlyOwner {
        paused = _state;
    }
    
    function whitelistUsers(address[] memory _users) external onlyOwner {
        for(uint i=0; i<_users.length; i++) {
          if(_users[i]!=address(0)){
             whitelistedAddresses[_users[i]] = true;
          }  
        }
    }

    function removeWhitelistUsers(address _users) external onlyOwner {
        whitelistedAddresses[_users] = false;
    }
    
    function withdraw() external payable onlyOwner {
        (bool os, ) = payable(owner()).call{value: address(this).balance}("");
        require(os);
    }
}
