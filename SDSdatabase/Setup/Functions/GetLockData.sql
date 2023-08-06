DROP FUNCTION IF EXISTS GetLockData;
GO
CREATE OR ALTER FUNCTION GetLockData(@user_id UNIQUEIDENTIFIER, @lock_id INT)
    RETURNS @LockData Table (
        lock_status INT NOT NULL,
        lock_id INT,
        station_name TEXT,
        location_latitude DECIMAL(9,6),
        location_longitude DECIMAL(9,6),
        hourly_rate DECIMAL(4,2),
        rental_start_time DATETIME,
        rental_end_time DATETIME
    )
    BEGIN
        DECLARE @lockStatus INT;
        SELECT @lockStatus = IIF(user_id IS NULL, 0, IIF(user_id = @user_id, 1, -1)) FROM Locks WHERE lock_id = @lock_id;

        IF @lockStatus = 0 -- Available
            INSERT INTO @LockData (lock_status, lock_id, station_name, hourly_rate)
            SELECT
                @lockStatus,
                lock_id,
                location_latitude,
                location_longitude,
                station_name,
                hourly_rate
            FROM Locks JOIN Stations
            ON Locks.station_id = Stations.station_id
            WHERE lock_id = @lock_id;
        ELSE IF @lockStatus = 1 -- Owned
            INSERT INTO @LockData
            SELECT
                @lockStatus,
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
        ELSE -- Unavailable
            INSERT INTO @LockData (lock_status, lock_id)
            VALUES (@lockStatus, @lock_id);

        RETURN;
    END;
GO
