-- =============================================
-- Author: Cameron Phillips
-- Create date:  10/21/2021
-- Description:  
-- =============================================
CREATE OR ALTER PROCEDURE [league].[draft_driver] 
	@draft_year int,
	@draft_position int,
	@first_name nvarchar(100),
	@last_name nvarchar(100),
	@date_of_birth nvarchar(20),
	@alma_mater nvarchar(200),
	@jersey_num int = NULL,
	@position_id int = NULL,
	@roster_id int OUTPUT
AS
BEGIN
	DECLARE @person_id int, @player_id int;
	DECLARE @dob nvarchar(40)
	EXEC league.add_person @first_name, @last_name, @date_of_birth, @alma_mater, @person_id OUTPUT
	
	SELECT @person_id;

	EXEC [player].[add_player] @person_id, @player_id OUTPUT

	SELECT @player_id;

	EXEC [team].[draft_player] @draft_year, @draft_position, @player_id, @roster_id OUTPUT

	IF @roster_id IS NOT NULL AND @position_id IS NOT NULL
	BEGIN
		INSERT INTO team.roster_positions (roster_id, football_position_id)
		VALUES (@roster_id, @position_id)
	END

END