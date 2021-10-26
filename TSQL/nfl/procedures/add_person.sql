-- =============================================
-- Author: Cameron Phillips
-- Create date:  10/22/2021
-- Description:  Adds a person to league.person or returns their pre-existing person_id
-- =============================================
CREATE OR ALTER PROCEDURE [league].[add_person] 
	@first_name nvarchar(50),
	@last_name nvarchar(50),
	@date_of_birth date,
	@alma_mater nvarchar(150),
	@id int OUTPUT
AS 
BEGIN
	SELECT @id = id FROM [league].[person] 
	WHERE first_name = @first_name
		AND last_name = @last_name
		AND date_of_birth = @date_of_birth
		AND alma_mater = @alma_mater
	IF @id IS NULL
	BEGIN
		INSERT INTO [league].[person] ([first_name], [last_name], [date_of_birth], [alma_mater]) 
		VALUES (@first_name, @last_name, COALESCE(@date_of_birth, '1/1/2000'), COALESCE(@alma_mater, 'NA'))
		SELECT @id = SCOPE_IDENTITY()
	END
	RETURN
END