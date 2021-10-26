-- =============================================
-- Author: Cameron Phillips
-- Create date:  10/21/2021
-- Description:  
-- =============================================
CREATE OR ALTER PROCEDURE [team].[draft_player] 
	-- Should take a draft Year and Draft Position, and person_id
	@draft_year int,
	@draft_position int,
	@player_id int,
	@roster_id int OUTPUT,
	@jersey_num int = NULL
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM player.player WHERE id = @player_id)
	BEGIN
		RAISERROR('Player Record does not exist', 18, 1)
	END ELSE IF NOT EXISTS (SELECT 1 FROM team.draft_asset WHERE league_season = @draft_year AND pick_position = @draft_position)
	BEGIN
		RAISERROR('Draft Asset does not exist', 18, 1)	
	END
	UPDATE team.draft_asset
	SET pick_player_id = @player_id,
		used = 1
	WHERE league_season = @draft_year AND pick_position = @draft_position

	INSERT INTO team.roster ([team_id], [player_id], [jersey_number])
	VALUES (
		(SELECT owner_team_id FROM team.draft_asset WHERE pick_player_id = @player_id),
		@player_id,
		COALESCE(@jersey_num,99)
		)
	SET @roster_id = SCOPE_IDENTITY()
END

