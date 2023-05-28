// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract StackUp {

    //variables required
    enum PlayerQuestStatus {
        NOT_JOINED,
        JOINED,
        SUBMITTED
    }

    struct Quest {
        uint256 questId;
        uint256 numberOfPlayers;
        string title;
        uint8 reward;
        uint256 numberOfRewards;
        uint256 startTime;
        uint256 endTime;
    }

    struct Campaign {
        uint256 campaignId;
        mapping(uint256 => Quest) quests;
        uint256 nextQuestId;
    }

    address public admin;
    mapping(uint256 => Campaign) public campaigns;
    uint256 public nextCampaignId;

    mapping(address => mapping(uint256 => PlayerQuestStatus)) public playerQuestStatuses;

    constructor() {
        admin = msg.sender;
    }

    // Create a new quest within a campaign
    function createQuest(
        uint256 campaignId,
        string calldata title_,
        uint8 reward_,
        uint256 numberOfRewards_,
        uint256 startTime_,
        uint256 endTime_
    ) 
    
    external campaignExists(campaignId) {
        // quest creation access only for admin 
        require(msg.sender == admin, "Only the admin can create quests");
        Campaign storage campaign = campaigns[campaignId];
        campaign.quests[campaign.nextQuestId].questId = campaign.nextQuestId;
        campaign.quests[campaign.nextQuestId].title = title_;
        campaign.quests[campaign.nextQuestId].reward = reward_;
        campaign.quests[campaign.nextQuestId].numberOfRewards = numberOfRewards_;
        campaign.quests[campaign.nextQuestId].startTime = startTime_;
        campaign.quests[campaign.nextQuestId].endTime = endTime_;
        campaign.nextQuestId++;
    }

    // Join a quest within a campaign
    function joinQuest(uint256 campaignId, uint256 questId) external campaignExists(campaignId) questExists(campaignId, questId) {
        //Joined or submitted quest
        require(playerQuestStatuses[msg.sender][questId] == PlayerQuestStatus.NOT_JOINED, "Player has already joined/submitted this quest");
        Campaign storage campaign = campaigns[campaignId];
        Quest storage thisQuest = campaign.quests[questId];
        // if the quest is inactive
        require(block.timestamp >= thisQuest.startTime && block.timestamp <= thisQuest.endTime,"Quest is not currently active");
        //count the number of players
        playerQuestStatuses[msg.sender][questId] = PlayerQuestStatus.JOINED;
        thisQuest.numberOfPlayers++;
    }

    // Submit a quest within a campaign
    function submitQuest(uint256 campaignId, uint256 questId) external campaignExists(campaignId) questExists(campaignId, questId) {
        //Join quest to attempt the quest
        require(playerQuestStatuses[msg.sender][questId] == PlayerQuestStatus.JOINED, "Player must first join the quest");
        playerQuestStatuses[msg.sender][questId] = PlayerQuestStatus.SUBMITTED;
    }

    // Modifier to check if a campaign exists
    modifier campaignExists(uint256 campaignId) {
        require(campaigns[campaignId].nextQuestId > 0, "Campaign does not exist");
        _;
    }

    // Modifier to check if a quest exists within a campaign
    modifier questExists(uint256 campaignId, uint256 questId) {
        require(campaigns[campaignId].quests[questId].reward != 0, "Quest does not exist");
        _;
    }
}
