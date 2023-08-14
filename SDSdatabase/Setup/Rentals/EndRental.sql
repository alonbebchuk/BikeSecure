DROP PROCEDURE IF EXISTS EndRental;
GO
CREATE OR ALTER PROCEDURE EndRental
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

    WITH
        RentalHourDifference
        AS
        (
            SELECT
                *,
                DATEDIFF(MINUTE, start_time, @now) / 60 AS hour_difference
            FROM
                Locks
            WHERE
                id = @lock_id
        )
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
        duration_days,
        duration_hours
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
        hour_difference / 24,
        hour_difference % 24
    FROM
        RentalHourDifference;

    UPDATE Locks
            SET
                -- Rental Data
                user_id = NULL,
                hourly_rate = NULL,
                start_time = NULL
            WHERE
                id = @lock_id;

    DELETE FROM Locks
        WHERE id = @lock_id AND deleted = 1;

    DELETE FROM Stations
        WHERE (
            SELECT COUNT(*)
            FROM Locks
            WHERE station_id = Stations.id
        ) = 0;

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