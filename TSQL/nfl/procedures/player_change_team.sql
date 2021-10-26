-- =============================================
-- Author: Cameron Phillips
-- Create date:  10/21/2021
-- Description:  
-- =============================================
CREATE OR ALTER PROCEDURE [player].[change_team] 
	@player_id int,
	@team_id int,
	@roster_id int OUTPUT
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
	BEGIN TRANSACTION;
		IF NOT EXISTS (SELECT 1 FROM player.player WHERE id = @player_id)
		BEGIN
			RAISERROR('Person has not yet b	een added to player.player table',18, 1);
		END 

		UPDATE [team].[roster] SET team_id = @team_id WHERE player_id = @player_id;
		IF @@ROWCOUNT = 0
		BEGIN
			INSERT [team].[roster]([team_id], [player_id]) 
			VALUES(
					COALESCE(@team_id, 0),
					@player_id
					);
		END
	END
	COMMIT;
	SET @roster_id = SCOPE_IDENTITY()
	RETURN

