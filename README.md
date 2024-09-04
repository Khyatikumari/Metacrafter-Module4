# Metacrafter Module4
This is a smart contract in the form of Token for Degen Gaming where several functionalities can be performed.

# Getting Started
Executing program Steps to be followed inorder to run the contract seamlessly:

The Avalanche Fuji C-Chain's AVAX tokens, which serve as test credit, must first be accepted. The discount code must be entered when requesting tokens via the core web application. Our contract can be tested using the 0.5 AVAX that we will receive each day. Choosing Environment as Injected Provider - Metamask will allow us to return to Remix and then deploy the contract. The address of the deployed contract will now be copied, pasted into Snowtrace Testnet, and we will click on "Verify andpublish contracts." Next, we will select Fuji as the chain, click "verify," input the new contract's address, and then choose the version of the compiler specified in the solidity file. Once everything is finished, we will carry out the contract's transactions, which will be recorded in Snowtrace.

# code
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


# Working
After the Contract is deployed we can perform the following operations in it:

Minting Tokens: Producing fresh tokens (only the owner may do this). Burning Tokens: Burn all of the Smart Contract's tokens. RedeemTokens: Use Tokens to purchase various goods. Transfer Tokens: Move a token to another address from one address. GetBalance: Determine the balance of a specific address at a specific moment.

In addition, the file must be flattened because the verification portal does not support standard import statements and the JSON format needs to be flexible.

# Authors
Khyati
