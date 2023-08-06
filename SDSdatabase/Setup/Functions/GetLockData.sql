DROP FUNCTION IF EXISTS GetLockData;
GO
CREATE OR ALTER FUNCTION GetLockData(@user_id TEXT, @lock_id INT)
    RETURNS @LockData Table (
        lock_status INT NOT NULL,
        lock_id INT NOT NULL,
        station_name TEXT,
        location_latitude DECIMAL(9,6),
        location_longitude DECIMAL(9,6),
        hourly_rate DECIMAL(4,2),
        rental_start_time DATETIME,
        rental_end_time DATETIME
    )
    BEGIN
        DECLARE @lockStatus INT;
        SELECT @lockStatus = CASE
            WHEN user_id IS NULL THEN 0     -- Available
            WHEN user_id = @user_id THEN 1  -- Owned
            ELSE NULL                       -- Unavailable
        END
        FROM Locks WHERE lock_id = @lock_id;

        IF @lockStatus = 0
            INSERT INTO @LockData (lock_status, lock_id, station_name, location_latitude, location_longitude, hourly_rate)
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
        ELSE IF @lockStatus = 1
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
        ELSE
            INSERT INTO @LockData (lock_status, lock_id)
            VALUES (-1, @lock_id);

        RETURN;
    END;
GO
