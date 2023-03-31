// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Crowdfunding {
    struct Campaign {
        string imgURL;
        string title;
        string story;
        uint amount;
        uint deadline;
        uint raisedAmount;
        uint noOfContributors;
        address payable owner;
        bool completed;
    }

    mapping(uint => Campaign) public campaign;
    mapping(uint => mapping(address => uint)) public contribution;
    uint number = 1;

    function createCampaign(
        string memory _imgURL,
        string memory _title,
        string memory _story,
        uint _amount,
        uint _deadline
    ) external {
        Campaign memory newCampaign;
        newCampaign.imgURL = _imgURL;
        newCampaign.title = _title;
        newCampaign.story = _story;
        newCampaign.amount = _amount * 1 ether;
        newCampaign.deadline = block.timestamp + _deadline;
        newCampaign.owner = payable(msg.sender);
        newCampaign.completed = false;

        campaign[number] = newCampaign;
        number++;
    }

    function fundCampaign(uint id) external payable {
        require(
            campaign[id].deadline >= block.timestamp,
            "Campaign do not exist!"
        );
        require(msg.value >= 0);
        require(
            campaign[id].amount != campaign[id].raisedAmount,
            "Funding is completed!!"
        );

        campaign[id].raisedAmount += msg.value;
        contribution[id][msg.sender] += msg.value;
        campaign[id].noOfContributors++;
    }

    function withdhdrawFunds(uint id) external {
        require(campaign[id].owner == msg.sender, "Only owner can it!!");
        require(campaign[id].completed == false);
        require(
            campaign[id].amount == campaign[id].raisedAmount,
            "Funding is not completed!!"
        );

        payable(campaign[id].owner).transfer(campaign[id].amount);
        campaign[id].completed = true;
    }
}
