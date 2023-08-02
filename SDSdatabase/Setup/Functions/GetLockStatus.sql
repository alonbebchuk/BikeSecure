DROP FUNCTION IF EXISTS GetLockStatus;
GO
CREATE OR ALTER FUNCTION GetLockStatus(@user_id UNIQUEIDENTIFIER, @lock_id INT)
    RETURNS INT
    BEGIN
        DECLARE @lockStatus INT;
        SELECT @lockStatus = CASE
                WHEN user_id IS NULL THEN 0 -- Available
                WHEN user_id = @user_id THEN 1 -- Owned
                ELSE -1 -- Unavailable
            END
        FROM Locks
        WHERE lock_id = @lock_id;
        RETURN IIF(@lockStatus IS NULL, -1, @lockStatus);
    END;
GO
