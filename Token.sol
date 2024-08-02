// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol"; import "@openzeppelin/contracts/access/Ownable.sol"; import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol"; import "hardhat/console.sol";

contract DegenToken is ERC20, Ownable, ERC20Burnable {

event TokensRedeemed(address indexed redeemer, uint256 amount, string item);

struct Item {
    string name;
    uint256 price;
    uint256 stock;
}

Item[] public items;

mapping(uint256 => uint256) public itemStock;

constructor() ERC20("Degen", "DGN") Ownable(msg.sender) {
    _initializeItems();
}

function _initializeItems() internal {
    items.push(Item("1. Degen T-Shirt ", 100, 100));
    items.push(Item("2. Degen Coffee Mug ", 200, 50));
    items.push(Item("3. Degen Mystery Box ", 300, 20));
    items.push(Item("4. Degen Hoodie", 400, 30));
    items.push(Item("5. Degen Cap", 150, 80));
    items.push(Item("6. Degen Backpack", 500, 10));
    items.push(Item("7. Degen Gaming Mouse", 250, 50));
    items.push(Item("8. Degen Keyboard", 300, 40));
    items.push(Item("9. Degen Headset", 350, 25));
    items.push(Item("10. Degen Mouse Pad", 100, 150));
    items.push(Item("11. Degen Gaming Chair", 1000, 5));
    items.push(Item("12. Degen Monitor", 1500, 8));
    items.push(Item("13. Degen Console", 2000, 3));
    items.push(Item("14. Degen PC", 2500, 2));

    // Initialize item stock mapping
    for (uint256 i = 0; i < items.length; i++) {
        itemStock[i] = items[i].stock;
    }
}

function mint(address to, uint256 amount) public onlyOwner {
    _mint(to, amount);
}

function getBalance() external view returns (uint256) {
    return balanceOf(msg.sender);
}

function transferTokens(address _receiver, uint256 _value) external {
    require(balanceOf(msg.sender) >= _value, "You do not have enough Degen Tokens");
    transfer(_receiver, _value);
}

function burnTokens(uint256 _value) external {
    require(balanceOf(msg.sender) >= _value, "You do not have enough Degen Tokens");
    burn(_value);
}

function redeemTokens(uint256 _choice) external {
    require(_choice > 0 && _choice <= items.length, "Invalid choice");
    Item storage item = items[_choice - 1];
    require(itemStock[_choice - 1] > 0, "Item out of stock");
    require(balanceOf(msg.sender) >= item.price, "You do not have enough Degen Tokens to redeem this item");

    _burn(msg.sender, item.price);
    emit TokensRedeemed(msg.sender, item.price, item.name);

    itemStock[_choice - 1]--;
}

function storeItems() external view returns (Item[] memory) {
    return items;
}
}