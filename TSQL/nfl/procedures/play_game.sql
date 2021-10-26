-- =============================================
-- Author: Cameron Phillips
-- Create date:  10/21/2021
-- Description:  
-- =============================================
CREATE OR ALTER PROCEDURE [league].[play_game] 
	@game_id int,
	@home_team_score int,
	@away_team_score int,
	@update_override bit = 0
AS
BEGIN
	IF EXISTS (SELECT 1 FROM league.game WHERE id = @game_id AND played = 1) AND @update_override = 0
	BEGIN
		RAISERROR('Game has already been played and recorded. If an update is needed, please use override option',18,1)
	END ELSE IF NOT EXISTS (SELECT 1 FROM league.game WHERE id = @game_id)
	BEGIN
		RAISERROR('Game not been scheduled.',18,1)
	END 
	UPDATE league.game 
	SET 
		home_team_final_score = @home_team_score, 
		away_team_final_score = @away_team_score,
		played = 1
	WHERE id = @game_id
END