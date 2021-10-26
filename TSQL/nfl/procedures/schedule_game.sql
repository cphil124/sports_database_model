-- =============================================
-- Author: Cameron Phillips
-- Create date:  10/21/2021
-- Description:  
-- =============================================
CREATE OR ALTER PROCEDURE [league].[schedule_game] 
	@home_team_code int,
	@away_team_code int,
	@date date,
	@week_type int,
	@league_season int
AS
BEGIN
	DECLARE @home_team_id int, @away_team_id int, @stadium_id int, @league_season_week_id int;

	SELECT @league_season_week_id = id
	FROM league.season_week
	WHERE  league_season = @league_season AND league_week_type = @week_type

	IF EXISTS (SELECT 1 FROM league.game WHERE league_season_week = @week_type 
					AND home_team_id = @home_team_id AND away_team_id = @away_team_id)
	BEGIN
		RAISERROR('Game is already scheduled. If an update is needed, update existing record, or delete and reschedule',18,1)
	END ELSE BEGIN
		SELECT @stadium_id = hs.stadium_id FROM team.nfl_team t INNER JOIN team.home_stadium hs ON hs.team_id = t.id

		INSERT INTO league.game ([league_season_week], [game_date], [home_team_id], [away_team_id], [game_stadium], [played])
		VALUES (@league_season_week_id, @date, @home_team_id, @away_team_id, @stadium_id, 0)
	END
END 