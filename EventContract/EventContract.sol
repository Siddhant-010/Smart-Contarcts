// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract EventContract{
    struct Event{
        address organizer;
        string name;
        uint date;
        uint ticketPrice;
        uint ticketCount;
        uint ticketRemain;
    }
    mapping(uint=>Event) public events;  // event no.=>event
    mapping(address=>mapping(uint=>uint)) public tickets; // particular address => (event no. =>No.of tickets)
    uint public nextId;

    function createEvent(string memory name,uint date, uint ticketprice, uint ticketCount) external{
        require(date>block.timestamp,"You can organize event for future update");
        require(ticketCount>0,"You can organize event only if you create more than 0 tickets");
        events[nextId]=Event(msg.sender,name,date, ticketprice,ticketCount,ticketCount);
        nextId++;
    }
    function buyTicket(uint id, uint quantity) external payable{
        require(events[id].date!=0,"Event does not exist");
        require(events[id].date>block.timestamp,"Event has already occured");
        Event storage _event=events[id];      // pointing _event=> events
        require(_event.ticketRemain>=quantity,"Not Enough tickets");
        require(msg.value==(_event.ticketPrice*quantity),"Not enough ether");
        _event.ticketRemain-=quantity;
        tickets[msg.sender][id]+=quantity;
    }
    function transferTicket(uint id,uint quantity,address to) external{
        require(events[id].date!=0,"Event does not exist");
        require(events[id].date>block.timestamp,"Event has already occured");
        require(tickets[msg.sender][id]>=quantity,"You dont have enough tickets");
        tickets[msg.sender][id]-=quantity;
        tickets[to][id]+=quantity;
    }

}