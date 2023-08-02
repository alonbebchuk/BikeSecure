DROP PROCEDURE IF EXISTS InsertUserIfNotExists;
GO
CREATE OR ALTER PROCEDURE InsertUserIfNotExists(@user_id UNIQUEIDENTIFIER)
    AS
        INSERT INTO Users (user_id) 
        SELECT @user_id AS user_id
        WHERE NOT EXISTS (SELECT 1 FROM Users WHERE user_id = @user_id);
GO