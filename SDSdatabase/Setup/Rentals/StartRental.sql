DROP PROCEDURE IF EXISTS StartRental;
GO
CREATE OR ALTER PROCEDURE StartRental
    @user_id NVARCHAR(MAX),
    @lock_id UNIQUEIDENTIFIER,
    -- Station Secret Data
    @url NVARCHAR(MAX) OUTPUT,
    -- Lock Secret Data
    @mac NVARCHAR(MAX) OUTPUT,
    @secret BINARY(128) OUTPUT
AS
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
        @mac = mac,
        @secret = secret
    FROM
        Locks
    WHERE
        id = @lock_id;
END;
GO