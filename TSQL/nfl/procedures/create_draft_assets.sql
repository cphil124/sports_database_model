-- =============================================
-- Author: Cameron Phillips
-- Create date:  10/21/2021
-- Description:  
-- =============================================
CREATE OR ALTER PROCEDURE league.create_draft_assets
	@league_year int
AS
BEGIN
	DECLARE @preexisting_count int, @fresh_count int;;
	CREATE TABLE #draft_stage (team_id int, round_num int)
	
	DECLARE @i int = 0, @rounds int = 7
	WHILE(@i < @rounds)
	BEGIN
		SET @i = @i + 1
		INSERT INTO #draft_stage (team_id, round_num)
		SELECT id, @i
		FROM team.nfl_team
	END

	SET @preexisting_count = (SELECT COUNT(1) FROM team.draft_asset WHERE league_season = @league_year)
	SET @fresh_count = (SELECT COUNT(1) FROM #draft_stage)
	IF (@fresh_count < @preexisting_count)
	BEGIN
		PRINT(@league_year + ' has pre-existing compensatory picks. Please manually deelte before reloading.' )
		RAISERROR('Draft Assets already exist with additional compensatory picks added. Please delete old assets before generating new ones ', 18, 1)

	END ELSE BEGIN
		DELETE FROM team.draft_asset WHERE league_season = @league_year;
		DECLARE @used bit = 0;
		-- Check if draft has already taken place
		IF @league_year  < YEAR(GETDATE()) OR (YEAR(GETDATE()) = @league_year AND DATENAME(dayofyear , GetDate()) > DATENAME(dayofyear, DATEFROMPARTS(@league_year, 4, 28)))
		BEGIN
			SET @used = 1
		END
		INSERT INTO team.draft_asset ([owner_team_id], [original_team_id], [league_season], [pick_round], [compensatory], [used])
		SELECT team_id, team_id, @league_year, round_num, 0, @used FROM #draft_stage
	END
END