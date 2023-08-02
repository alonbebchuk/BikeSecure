DROP FUNCTION IF EXISTS GetLockRentalStatus;
GO
CREATE OR ALTER FUNCTION GetLockRentalStatus(@user_id UNIQUEIDENTIFIER, @lock_id INT)
    RETURNS INT
    BEGIN
        RETURN (
            SELECT
                CASE
                    WHEN user_id IS NULL THEN 0 -- Available
                    WHEN user_id = @user_id THEN 1 -- Owned
                    ELSE -1 -- Unavailable
                END
            FROM Locks
            WHERE lock_id = @lock_id
        );
    END;
GO
