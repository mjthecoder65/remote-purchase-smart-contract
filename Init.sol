
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;


contract Init {
    uint public itemPrice;
    address payable public sellerAddr;
    address payable public buyerAddr;
      
    enum State {Created, Locked, Release, InActive }
    State public state;

    constructor() payable {
        sellerAddr = payable(msg.sender); // By default msg.sender is not payable.
        itemPrice = msg.value / 2 ;
    }

    function getBuyer() external view returns(address) {
        return buyerAddr;
    }

    function getSeller() external view returns(address){
        return sellerAddr;
    }
}
