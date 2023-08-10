DROP FUNCTION IF EXISTS GetLockData;
GO
CREATE OR ALTER FUNCTION GetLockData(@user_id NVARCHAR(MAX), @lock_id INT)
RETURNS INT
BEGIN
    DECLARE @lockStatus INT;
    SELECT @lockStatus =
        CASE
            WHEN user_id IS NULL THEN 0     -- Available (Unlocked)
            WHEN user_id = @user_id THEN 1  -- Owned (Locked by @user_id)
            ELSE NULL                       -- Unavailable (Locked by nor @user_id)
        END
    FROM Locks
    WHERE lock_id = @lock_id;

    RETURN @lockStatus;
END;
GO