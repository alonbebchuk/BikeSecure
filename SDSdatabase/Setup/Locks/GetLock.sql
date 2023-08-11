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
    start_time DATETIME
)
BEGIN
    DECLARE @lockStatus INT;
    SELECT @lockStatus = [dbo].[GetLockStatus](@user_id, @lock_id);

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
        IIF(@lockStatus = 1, hourly_rate, station_hourly_rate),
        start_time
    FROM
        Locks
    WHERE
        id = @lock_id;

    RETURN;
END;
GO