DROP FUNCTION IF EXISTS GetLockPublicData;
GO
CREATE OR ALTER FUNCTION GetLockPublicData(@user_id NVARCHAR(MAX), @lock_id INT)
RETURNS @LockData Table(
    lock_status INT NOT NULL,
    lock_id INT NOT NULL,
    station_name NVARCHAR(MAX),
    location_latitude DECIMAL(9,6),
    location_longitude DECIMAL(9,6),
    hourly_rate DECIMAL(4,2),
    rental_start_time DATETIME,
    rental_end_time DATETIME
)
BEGIN
    DECLARE @lockStatus INT;
    SELECT @lockStatus = GetLockStatus(@user_id, @lock_id);

    IF @lockStatus = 0 -- Available (Unlocked)
    BEGIN
        INSERT INTO @LockData
            (
            lock_status,
            lock_id,
            station_name,
            location_latitude,
            location_longitude,
            hourly_rate
            )
        SELECT
            0,
            lock_id,
            station_name,
            location_latitude,
            location_longitude,
            hourly_rate
        FROM Locks JOIN Stations
            ON Locks.station_id = Stations.station_id
        WHERE lock_id = @lock_id;
    END;
    ELSE IF @lockStatus = 1 -- Owned (Locked by @user_id)
    BEGIN
        INSERT INTO @LockData
        SELECT
            1,
            lock_id,
            station_name,
            location_latitude,
            location_longitude,
            hourly_rate,
            rental_start_time,
            GETDATE()
        FROM Rentals
        WHERE lock_id = @lock_id
            AND rental_end_time IS NULL;
    END;
    ELSE -- Unavailable (Locked by not @user_id)
    BEGIN
        INSERT INTO @LockData
            (lock_status, lock_id)
        VALUES
            (-1, @lock_id);
    END;

    RETURN;
END;
GO
