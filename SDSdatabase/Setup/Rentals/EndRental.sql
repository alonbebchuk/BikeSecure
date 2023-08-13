DROP PROCEDURE IF EXISTS EndRental;
GO
CREATE OR ALTER PROCEDURE EndRental
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

    IF @lockStatus = 1
    BEGIN
        DECLARE @now DATETIME;
        SET @now = GETDATE();

        INSERT INTO Rentals
            (
            -- Station Data
            station_id,
            station_name,
            latitude,
            longitude,
            -- Lock Data
            lock_id,
            lock_name,
            -- Rental Data
            user_id,
            hourly_rate,
            start_time,
            end_time,
            duration,
            cost
            )
        SELECT
            -- Station Data
            station_id,
            station_name,
            latitude,
            longitude,
            -- Lock Data
            id,
            name,
            -- Rental Data
            user_id,
            hourly_rate,
            start_time,
            @now,
            @now - start_time,
            DATEDIFF(HOUR, start_time, @now) * hourly_rate
        FROM
            Locks
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

        DELETE FROM Locks
        WHERE id = @lock_id AND deleted = 1;

        DELETE FROM Stations
        WHERE (SELECT COUNT(*) FROM Locks WHERE station_id = Stations.id) = 0;

        RETURN 1;
    END;

    RETURN 0;
END;
GO