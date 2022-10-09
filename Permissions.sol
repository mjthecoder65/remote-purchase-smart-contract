// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "./Init.sol";

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
