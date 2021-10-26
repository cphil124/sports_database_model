-- Add Person Testing
-- Not pre-existing
BEGIN TRANSACTION;
DECLARE @per_id int;
EXEC league.add_person 'Tom', 'Brady', '10/10/1960', 'Michigan University', @id = @per_id OUTPUT;
SELECT @per_id;
ROLLBACK


-- Pre-existing Person
SELECT * FROM league.person;
IF NOT EXISTS (SELECT 1 FROM league.person WHERE 
				[first_name] = 'Tom' AND
				[last_name] = 'Brady' AND 
				[date_of_birth] = '10/10/1960' AND 
				[alma_mater] = 'Michigan University'
				)
BEGIN
	INSERT INTO league.person([first_name], [last_name], [date_of_birth], [alma_mater])
	VALUES ('Tom', 'Brady', '10/10/1960', 'Michigan University')
END
GO

DECLARE @per_id int;
EXEC league.add_person 'Tom', 'Brady', '10/10/1960', 'Michigan University', @id = @per_id OUTPUT;
SELECT @per_id;