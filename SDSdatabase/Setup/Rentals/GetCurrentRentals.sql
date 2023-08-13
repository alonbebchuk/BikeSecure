DROP FUNCTION IF EXISTS GetCurrentRentals;
GO
CREATE OR ALTER FUNCTION GetCurrentRentals(@user_id NVARCHAR(MAX))
RETURNS @CurrentRentals Table
(
    -- Station Data
    station_name NVARCHAR(MAX) NOT NULL,
    latitude DECIMAL(9,6) NOT NULL,
    longitude DECIMAL(9,6) NOT NULL,
    -- Lock Data
    lock_id UNIQUEIDENTIFIER NOT NULL,
    lock_name NVARCHAR(MAX) NOT NULL,
    -- Rental Data
    hourly_rate DECIMAL(4,2) NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    duration_days INT NOT NULL,
    duration_hours INT NOT NULL,
    cost AS CONVERT(DECIMAL(9,2), hourly_rate) * (24 * duration_days + duration_hours)
)
BEGIN
    DECLARE @now DATETIME;
    SET @now = GETDATE();

    WITH
        CurrentRentalHourDifferences
        AS
        (
            SELECT
                *,
                DATEDIFF(MINUTE, start_time, @now) / 60 AS hour_difference
            FROM
                Locks
            WHERE
                user_id = @user_id
        )
    INSERT INTO @CurrentRentals
    SELECT
        -- Station Data
        station_name,
        latitude,
        longitude,
        -- Lock Data
        id,
        name,
        -- Rental Data
        hourly_rate,
        start_time,
        @now,
        hour_difference / 24,
        hour_difference % 24
    FROM
        CurrentRentalHourDifferences

    RETURN;
END;
GO