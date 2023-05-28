The two features added to the smart contract are Campaigns and Quest start and end times. These features provide enhanced functionality to manage multiple quests and restrict players from joining quests that have already ended.

The Campaigns feature allows the contract to organize quests under different campaigns. Each campaign can have its own set of quests. This enables better categorization and organization of quests.

The Quest start and end times feature adds time restrictions to each quest. Players can only join a quest if the current timestamp falls within the quest's start and end times.

This prevents players from joining quests that have already ended or haven't started yet. It ensures that quests are only active during specific time intervals, maintaining fairness and time-bound participation.

The modifications in the code introduce new data structures, such as the Campaign struct, and modify the existing Quest struct to include start and end time fields. The createQuest function is updated to assign start and end times to quests within campaigns. 

The joinQuest function checks if a quest is currently active before allowing players to join. The submitQuest function remains the same. Overall, these features enhance the contract's capabilities, enabling the management of campaigns and time-bound quests.
