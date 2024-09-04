// SPDX-License-Identifier: MIT
/*Your task is to create a ERC20 token and deploy it on the Avalanche network for Degen Gaming. The smart contract should have the following functionality:

Minting new tokens: The platform should be able to create new tokens and distribute them to players as rewards. Only the owner can mint tokens.
Transferring tokens: Players should be able to transfer their tokens to others.
Redeeming tokens: Players should be able to redeem their tokens for items in the in-game store.
Checking token balance: Players should be able to check their token balance at any time.
Burning tokens: Anyone should be able to burn tokens, that they own, that are no longer needed.*/
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "hardhat/console.sol";

contract DegenToken is ERC20, Ownable, ERC20Burnable {

    event RedeemTokens(address indexed redeemer, uint256 amount, string collectible);

    struct Collectible {
        string name;
        uint256 price;
        uint256 stock;
    }

    Collectible[] public catalog;

    mapping(uint256 => uint256) public collectibleStock;
    mapping(address => mapping(uint256 => uint256)) public userCollectibles;

    constructor() ERC20("Degen", "DGN") Ownable(msg.sender) {
        _initializeCatalog();
    }

    function _initializeCatalog() internal {
        catalog.push(Collectible("DGN Necklace", 250, 100));
        catalog.push(Collectible("DGN Ring", 280, 50));
        catalog.push(Collectible("DGN Softtoy", 380, 20));
        catalog.push(Collectible("DGN Earring", 420, 30));
        catalog.push(Collectible("DGN Cap", 180, 80));
        catalog.push(Collectible("DGN Backpack", 550, 10));
        catalog.push(Collectible("DGN Purse", 350, 50));

        for (uint256 i = 0; i < catalog.length; i++) {
            collectibleStock[i] = catalog[i].stock;
        }
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function getBalance() external view returns (uint256) {
        return balanceOf(msg.sender);
    }

    function transferTokens(address _receiver, uint256 _value) external {
        require(balanceOf(msg.sender) >= _value, "Insufficient Degen Tokens to transfer");
        transfer(_receiver, _value);
    }

    function burnTokens(uint256 _value) external {
        require(balanceOf(msg.sender) >= _value, "Insufficient Degen Tokens to burn");
        burn(_value);
    }

    function redeemTokens(uint256 _id) external {
        require(_id > 0 && _id <= catalog.length, "Invalid collectible ID");
        Collectible storage selectedCollectible = catalog[_id - 1];
        require(collectibleStock[_id - 1] > 0, "Collectible out of stock");
        require(balanceOf(msg.sender) >= selectedCollectible.price, "Insufficient Degen Tokens to redeem this collectible");

        _burn(msg.sender, selectedCollectible.price);
        emit RedeemTokens(msg.sender, selectedCollectible.price, selectedCollectible.name);

        collectibleStock[_id - 1]--;
        userCollectibles[msg.sender][_id - 1]++;
    }

    function getCatalog() external view returns (Collectible[] memory) {
        return catalog;
    }

    function getUserCollectibles(address _user) external view returns (uint256[] memory) {
        uint256[] memory ownedCollectibles = new uint256[](catalog.length);
        for (uint256 i = 0; i < catalog.length; i++) {
            ownedCollectibles[i] = userCollectibles[_user][i];
        }
        return ownedCollectibles;
    }
}
