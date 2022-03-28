pragma solidity ^0.8.2;

import "@openzeppelin/contracts@4.3.1/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.3.1/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts@4.3.1/access/Ownable.sol";
import "@openzeppelin/contracts@4.3.1/utils/Counters.sol";

contract TestNft is ERC721, ERC721Enumerable, Ownable{
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    uint256 public mintRate = 0.01 ether;
    uint public MAX_SUPPLY=100;

    constructor()ERC721("TestNFT","TNFT"){}

    function _baseURI() internal pure override returns(string memory){
        return "https://api.testnft.com/tokens/";
    }

    function safeMint(address to)public payable{
        require(totalSupply()<MAX_SUPPLY,"Cannot mint more");
        require(msg.value>= mintRate,"Not Enough ether send");
        _tokenIdCounter.increment();
        _safeMint(to,_tokenIdCounter.current());
    }

    // override for solidity 

    function _beforeTokenTransfer(address from, address to , uint tokenId) internal override(ERC721,ERC721Enumerable){
        return super._beforeTokenTransfer(from,to,tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view 
        override(ERC721,ERC721Enumerable)
        returns(bool)
        {
            super.supportsInterface(interfaceId);
        }

    function withdraw() public onlyOwner{
        require(address(this).balance > 0 ,"Balance is 0");
        payable(owner()).transfer(address(this).balance);
    }


}