-- =============================================
-- Author: Cameron Phillips
-- Create date:  10/22/2021
-- Description:  Adds a player to player.player or returns their pre-existing player_id
-- =============================================
CREATE OR ALTER PROCEDURE [player].[add_player] 
	@person_id int,
	@player_id int OUTPUT
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM league.person WHERE id = @person_id)
	BEGIN
		RAISERROR('Person Record does not exist. Please provide a valid person id',18,1)
	END
	ELSE
	BEGIN
		SELECT @player_id = id FROM [player].[player] WHERE person_id = @person_id
		IF @player_id IS NULL
		BEGIN
			INSERT INTO [player].[player] (person_id, active)
			VALUES (@person_id, 1)
			SET @player_id = SCOPE_IDENTITY()
		END
		SELECT @player_id
		RETURN
	END
END