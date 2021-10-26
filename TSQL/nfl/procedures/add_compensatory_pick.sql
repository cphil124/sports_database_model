-- =============================================
-- Author: Cameron Phillips
-- Create date:  10/21/2021
-- Description:  
-- =============================================
CREATE OR ALTER PROCEDURE league.add_compensatory_pick
	@pick_round int,
	@pick_team_id int
AS
BEGIN
	IF @pick_round > 7 OR @pick_round < 3
	BEGIN
		RAISERROR('Compensatory Picks can only be added in the 3rd-7th rounds',18,1)
	END
	DECLARE @year int = (SELECT MAX([league_season]) + 1 FROM [team].[draft_asset] WHERE used = 1)
	DECLARE @next_pick_position int = (SELECT MAX(pick_position)+1 FROM [team].[draft_asset] WHERE league_season = @year AND pick_round = @pick_round)

	INSERT INTO team.draft_asset ([owner_team_id], [original_team_id], [league_season], [pick_round], [pick_player_id], [pick_position], [compensatory], [used])
	VALUES (@pick_team_id, @pick_team_id, @year, @pick_round, -1, @next_pick_position, 1, 0);

	UPDATE team.draft_asset 
	SET pick_position = pick_position + 1 
	--WHERE league_season = @year AND pick_round > @pick_round;
	WHERE league_season = 2001 AND pick_round > 3;
END



