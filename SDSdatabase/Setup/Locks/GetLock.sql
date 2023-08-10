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
    hourly_rate DECIMAL(4,2) NOT NULL,
    -- Lock Data
    lock_id UNIQUEIDENTIFIER NOT NULL,
    lock_name NVARCHAR(MAX) NOT NULL,
    -- Rental Data
    start_time DATETIME NOT NULL
)
BEGIN
    INSERT INTO @Locks
    SELECT
        [dbo].[GetLockStatus](@user_id, @lock_id),
        -- Station Data
        station_name,
        latitude,
        longitude,
        hourly_rate,
        -- Lock Data
        id,
        name,
        -- Rental Data
        start_time
    FROM
        Locks
    WHERE
        id = @lock_id;

    RETURN;
END;
GO