-- New Player
DECLARE @per_id int;
DECLARE @play_id int;
BEGIN TRAN
SELECT * FROM league.person;
SELECT @per_id = id FROM league.person WHERE first_name = 'Tom' AND last_name = 'Brady'
DELETE FROM player.player WHERE person_id = @per_id;
EXEC player.add_player @per_id, @player_id = @play_id OUTPUT;
SELECT @play_id;
SELECT * FROM player.player;
ROLLBACK
GO

-- Pre-existing Player
DECLARE @per_id int;
DECLARE @play_id int;
BEGIN TRAN
SELECT * FROM league.person;
SELECT @per_id = id FROM league.person WHERE first_name = 'Tom' AND last_name = 'Brady'
IF NOT EXISTS (SELECT 1 FROM player.player WHERE id = @per_id)
BEGIN
	INSERT INTO player.player (person_id, active) VALUES (@per_id, 1)
END
EXEC player.add_player @per_id, @player_id = @play_id OUTPUT;
SELECT @play_id;
SELECT * FROM player.player;
ROLLBACK
GO

-- Non-Existent Person
DECLARE @per_id int;
DECLARE @play_id int;
BEGIN TRAN
SELECT * FROM league.person;
SELECT @per_id = MAX(id)+1 FROM league.person
BEGIN TRY
	EXEC player.add_player @per_id, @player_id = @play_id OUTPUT;
	PRINT('Test Failed')
END TRY
BEGIN CATCH
	PRINT('Test Passed')
END CATCH
ROLLBACK
GO

-- On Prem SQL Server
DROP DATABASE IF EXISTS nfl2;
DBCC CLONEDATABASE (
	[nfl], [nfl2]
) WITH VERIFY_CLONEDB

-- Azure SQL
CREATE DATABASE nfl3 AS COPY OF localhost.nfl;
SELECT * FROM team.nfl_team