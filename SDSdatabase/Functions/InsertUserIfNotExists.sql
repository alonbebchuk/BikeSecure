CREATE OR ALTER PROCEDURE InsertUserIfNotExists( @uid UNIQUEIDENTIFIER )
    AS
    BEGIN
        INSERT INTO Users (user_id) 
        SELECT @uid AS user_id
        WHERE NOT EXISTS (SELECT 1 FROM Users WHERE user_id = @uid);
    END
GO