DROP FUNCTION IF EXISTS GetLockStatus;
GO
CREATE OR ALTER FUNCTION GetLockStatus(@user_id NVARCHAR(MAX), @lock_id UNIQUEIDENTIFIER)
RETURNS INT
BEGIN
    DECLARE @lockStatus INT;
    SELECT
        @lockStatus = CASE
            WHEN user_id IS NULL AND deleted = 0 THEN 0
            WHEN user_id = @user_id THEN 1
            ELSE -1
        END
    FROM
        Locks
    WHERE
        id = @lock_id;

    RETURN @lockStatus;
END;
GO