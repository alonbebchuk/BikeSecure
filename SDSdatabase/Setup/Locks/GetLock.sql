DROP FUNCTION IF EXISTS GetLock;
GO
CREATE OR ALTER FUNCTION GetLock(@user_id NVARCHAR(MAX), @lock_id UNIQUEIDENTIFIER)
RETURNS @Locks Table
(
    lock_status INT NOT NULL,
    -- Station Data
    station_name NVARCHAR(MAX) NOT NULL,
    latitude DECIMAL(9,6) NOT NULL,
    longitude DECIMAL(9,6) NOT NULL,
    -- Lock Data
    lock_id UNIQUEIDENTIFIER NOT NULL,
    lock_name NVARCHAR(MAX) NOT NULL,
    -- Rental Data
    hourly_rate DECIMAL(4,2) NOT NULL,
    start_time DATETIME,
    end_time DATETIME,
    duration_days INT,
    duration_hours INT,
    cost AS CONVERT(DECIMAL(9,2), hourly_rate) * (24 * duration_days + duration_hours)
)
BEGIN
    DECLARE @lockStatus INT;
    SELECT @lockStatus = [dbo].[GetLockStatus](@user_id, @lock_id);

    DECLARE @now DATETIME;
    SET @now = GETDATE();

    WITH
    LockHourDifference
    AS
    (
        SELECT
            *,
            IIF(@lockStatus = 1, DATEDIFF(MINUTE, start_time, @now) / 60, NULL) AS hour_difference
        FROM
            Locks
        WHERE
            id = @lock_id
    )
    INSERT INTO @Locks
    SELECT
        @lockStatus,
        -- Station Data
        station_name,
        latitude,
        longitude,
        -- Lock Data
        id,
        name,
        -- Rental Data
        IIF(@lockStatus = 0, station_hourly_rate, hourly_rate),
        start_time,
        IIF(@lockStatus = 1, @now, NULL),
        IIF(@lockStatus = 1, hour_difference / 24, NULL),
        IIF(@lockStatus = 1, hour_difference % 24, NULL)
    FROM
        LockHourDifference;

    RETURN;
END;
GO