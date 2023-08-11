DROP PROCEDURE IF EXISTS DeleteLockManager;
GO
CREATE OR ALTER PROCEDURE DeleteLockManager
    @lock_id UNIQUEIDENTIFIER
AS
BEGIN
    DECLARE @free BIT;
    SELECT
        @free = IIF(user_id IS NULL, 1, 0)
    FROM Locks
    WHERE id = @lock_id;

    IF @free = 1
    BEGIN
        DELETE FROM Locks
        WHERE id = @lock_id;
    END;
    ELSE
    BEGIN
        UPDATE Locks
        SET deleted = 1
        WHERE id = @lock_id;
    END;
END;
GO