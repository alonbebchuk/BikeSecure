DROP PROCEDURE IF EXISTS StartRental;
GO
CREATE OR ALTER PROCEDURE StartRental
    @user_id NVARCHAR(MAX),
    @lock_id UNIQUEIDENTIFIER,
    -- Station Secret Data
    @url NVARCHAR(MAX) OUTPUT,
    -- Lock Secret Data
    @secret BINARY(128) OUTPUT,
    @mac NVARCHAR(MAX) OUTPUT
AS
BEGIN
    DECLARE @lockStatus INT;
    SELECT @lockStatus = [dbo].[GetLockStatus](@user_id, @lock_id);

    IF @lockStatus = 0
    BEGIN
        DECLARE @now DATETIME;
        SET @now = GETDATE();

        UPDATE Locks
            SET
                -- Rental Data
                user_id = @user_id,
                hourly_rate = station_hourly_rate,
                start_time = @now
            WHERE
                id = @lock_id;

        SELECT
            -- Station Secret Data
            @url = url,
            -- Lock Secret Data
            @secret = secret,
            @mac = mac
        FROM
            Locks
        WHERE
            id = @lock_id;

        RETURN 1;
    END;

    RETURN 0;
END;
GO