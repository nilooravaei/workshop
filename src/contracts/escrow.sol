pragma solidity ^0.4.19;

/*
Simple escrow contract that mediates disputes using a trusted arbiter
*/
contract Escrow {
    
    enum State {AWAITING_PAYMENT, AWAITING_DELIVERY, COMPLETE}
    State public currentState;
    
    modifier buyerOnly() { require(msg.sender == buyer); _; }
    modifier sellerOnly() { require(msg.sender == seller); _; }
    modifier inState(State expectedState) { require(currentState == expectedState); _; }
    
    address public buyer;
    address public seller;
    
    function Escrow(address _buyer, address _seller){
        buyer = _buyer;
        seller = _seller;
    }
    
    function confirmPayment() buyerOnly inState(State.AWAITING_PAYMENT) payable {
        currentState = State.AWAITING_DELIVERY;
    }
    
    function confirmDelivery() buyerOnly inState(State.AWAITING_DELIVERY) {
        seller.send(this.balance);
        currentState = State.COMPLETE;
    }
}
