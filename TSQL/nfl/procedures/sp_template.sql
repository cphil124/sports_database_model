-- =============================================
-- Author: Cameron Phillips
-- Create date:  10/21/2021
-- Description:  
-- =============================================
CREATE PROCEDURE [schema].[table]
    -- @person_id int
    -- @draft_asset_id int
AS 
    SET XACT_ABORT ON;
    BEGIN TRANSACTION;
        BEGIN TRY
            [Draft player code]
        END TRY
        BEGIN CATCH
            SELECT ERROR_MESSAGE() AS [Error Message]
                ,ERROR_LINE() AS ErrorLine
                ,ERROR_NUMBER() AS [Error Number]  
                ,ERROR_SEVERITY() AS [Error Severity]  
                ,ERROR_STATE() AS [Error State]  
            ROLLBAC
        END CATCH
    COMMIT
END



