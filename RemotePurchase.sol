// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "./Permissions.sol";


contract RemotePurchase is Permissions {
    function confirmPurchase() external inState(State.Created) payable {
        require(msg.value == 2 * itemPrice, "Please send in 2 times the purchase amount");
        buyerAddr = payable(msg.sender);
        state = State.Locked;
    }

    function confirmReceived() external onlyBuyer inState(State.Locked) {
        state = State.Release;
        buyerAddr.transfer(itemPrice);
    }

    function paySeller() external onlySeller inState(State.Locked) {
        state = State.InActive;
        sellerAddr.transfer(3 * itemPrice);
    }


    function abort() external onlySeller inState(State.Created) {
        state = State.InActive;
        sellerAddr.transfer(address(this).balance);
    }
}

