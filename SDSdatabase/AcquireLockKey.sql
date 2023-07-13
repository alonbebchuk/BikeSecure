CREATE OR ALTER FUNCTION AcquireLockKey( @uid UNIQUEIDENTIFIER, @lid INT )
    RETURNS UNIQUEIDENTIFIER
    AS
    BEGIN
        RETURN (
            SELECT lock_key FROM Locks WHERE lock_id = @lid AND user_id = @uid
        );
    END
GO