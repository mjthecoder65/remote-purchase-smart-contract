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


contract Permissions is Init {
    /// The function cannot be called at the current state.
    error InvalidState();
    
    /// Only the Buyer can call this function
    error  OnlyBuyer();


    // Only the Seller can call this function
    error  OnlySeller();

    modifier inState(State state_) {
        if (state != state_) {
            revert InvalidState();
        }
        _;
    }

    modifier onlyBuyer() {
        if (msg.sender != buyerAddr) {
            revert OnlyBuyer();
        }
        _;
    }

     modifier onlySeller() {
        if (msg.sender != sellerAddr) {
            revert OnlySeller();
        }
        _;
    }
}


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

