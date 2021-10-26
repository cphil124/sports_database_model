DECLARE @tom_person_id int = (SELECT id FROM league.person WHERE first_name = 'Tom' AND last_name = 'Brady')
DECLARE @tm_id int = (SELECT id FROM team.nfl_team WHERE team_name = 'New England Patriots')
DECLARE @pos_id int = (SELECT id FROM player.football_positions WHERE position_name = 'Quarterback')
DECLARE @tom_player_id int;
DECLARE @jersey_num int = 12;
IF NOT EXISTS (SELECT 1 FROM player.player WHERE person_id = @tom_person_id)
BEGIN
	EXEC player.add_player @tom_person_id, @player_id = @tom_player_id OUTPUT
END
ELSE 
BEGIN
	SELECT @tom_player_id = id FROM player.player WHERE person_id = @tom_person_id;
END
DECLARE @ros_id int;

-- Non-Existent Player
BEGIN TRAN
BEGIN TRY 
	EXEC [player].[change_team] 99, @tm_id, @pos_id, @jersey_num, @roster_id = @ros_id
	SELECT * FROM team.roster
END TRY
BEGIN CATCH
	PRINT('Non-Existent Player Test Passed')
END CATCH
ROLLBACK


-- Player Exists, no position
BEGIN TRAN
	EXEC [player].[change_team] @tom_player_id, @tm_id, NULL, @jersey_num, @roster_id = @ros_id
	IF EXISTS (SELECT 1 FROM team.roster WHERE player_id = @tom_player_id AND [player_roster_position_id] = -1)
	BEGIN
		PRINT('No Position Provided Test Passed')
	END
ROLLBACK

-- Without Jersey # provided
BEGIN TRAN
	EXEC [player].[change_team] @tom_player_id, @tm_id, @pos_id, NULL, @roster_id = @ros_id
	IF EXISTS (SELECT 1 FROM team.roster WHERE player_id = @tom_player_id AND [jersey_number] = 0)
	BEGIN
		PRINT('No Jersey Provided Test Passed')
	END
ROLLBACK

-- No Jersey # or Position provided
BEGIN TRAN
	EXEC [player].[change_team] @tom_player_id, @tm_id, NULL, NULL, @roster_id = @ros_id
	IF EXISTS (SELECT 1 FROM team.roster WHERE player_id = @tom_player_id AND [jersey_number] = 0 AND [player_roster_position_id] = -1)
	BEGIN
		PRINT('No Jersey or Position Provided Test Passed')
	END
ROLLBACK

-- No Team Provided
BEGIN TRAN
	EXEC [player].[change_team] @tom_player_id, NULL, @pos_id, @jersey_num, @roster_id = @ros_id
	IF EXISTS (SELECT 1 FROM team.roster WHERE player_id = @tom_player_id AND [jersey_number] = 0 AND [player_roster_position_id] = -1)
	BEGIN
		PRINT('No Team Test Passed')
	END
ROLLBACK

-- Nothing Provided
BEGIN TRAN
	EXEC [player].[change_team] @tom_player_id, NULL, NULL, NULL, @roster_id = @ros_id
	IF EXISTS (SELECT 1 FROM team.roster WHERE player_id = @tom_player_id AND [jersey_number] = 0 AND [player_roster_position_id] = -1)
	BEGIN
		PRINT('Nothing but Player Test Passed')
	END
ROLLBACK

-- Everything 
BEGIN TRAN
	EXEC [player].[change_team] @tom_player_id, @tm_id, @pos_id, @jersey_num, @roster_id = @ros_id
	IF EXISTS (SELECT 1 FROM team.roster WHERE player_id = @tom_player_id  
				AND [player_roster_position_id] = @pos_id
				AND [jersey_number] = @jersey_num
				AND [team_id] = @tm_id)
	BEGIN
		PRINT('Happy Path Test Passed')
	END
ROLLBACK
