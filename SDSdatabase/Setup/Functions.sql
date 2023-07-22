-- Drop Functions If Exist
DROP FUNCTION IF EXISTS AcquireLockKey;
DROP FUNCTION IF EXISTS GetUserRentals;

-- IsLockFree Function
-- Params: lock_id
-- Returns: 1 if lock is free
GO
CREATE OR ALTER FUNCTION IsLockFree(@lock_id INT)
    RETURNS BIT
    BEGIN
        RETURN (SELECT CASE WHEN user_id IS NULL THEN 1 ELSE 0 END FROM Locks WHERE lock_id = @lock_id);
    END;
GO

-- GetLockKey Function
-- Params: user_id and lock_id
-- Returns: lock_key if user user_id owns lock lock_id
GO
CREATE OR ALTER FUNCTION GetLockKey(@user_id UNIQUEIDENTIFIER, @lock_id INT)
    RETURNS UNIQUEIDENTIFIER
    BEGIN
        RETURN (SELECT lock_key FROM Locks WHERE lock_id = @lock_id AND user_id = @user_id);
    END;
GO

-- GetStationInformation Function
-- Returns: information on all stations
GO
CREATE OR ALTER FUNCTION GetStationInformation(@user_id UNIQUEIDENTIFIER)
    RETURNS @StationInformation Table (
            station_name TEXT,
            hourly_rate DECIMAL(4,2),
            location_latitude DECIMAL,
            location_longitude DECIMAL,
            total_locks INT,
            available_locks INT,
            user_owned_locks INT,
            is_full BIT
    )
    BEGIN
        INSERT INTO @StationInformation
        SELECT
		    station_name,
            hourly_rate,
            location_latitude,
            location_longitude,
            (SELECT COUNT(*) FROM Locks WHERE station_id = Stations.station_id) AS total_locks,
            (SELECT COUNT(*) FROM Locks WHERE station_id = Stations.station_id AND user_id IS NULL) AS available_locks,
            (SELECT COUNT(*) FROM Locks WHERE station_id = Stations.station_id AND user_id = @user_id) AS user_owned_locks,
            (SELECT CASE WHEN COUNT(*) = COUNT(user_id) THEN 1 ELSE 0 END FROM Locks WHERE station_id = Stations.station_id) AS is_full
        FROM Stations;
        RETURN;
    END;
GO

-- GetUserRentals Function
-- Params: user_id and is_current
-- Returns: information on all user user_id's rentals which have(is_current=0)/haven't(is_current=1) ended
GO
CREATE OR ALTER FUNCTION GetUserRentals(@user_id UNIQUEIDENTIFIER, @is_current BIT)
    RETURNS @UserRentals Table (
		rental_id INT,
        lock_id INT,
        station_name TEXT,
        rental_start_time DATETIME,
        rental_end_time DATETIME,
        rental_duration INT,
        total_cost DECIMAL(10,2)
    )
    BEGIN
		INSERT INTO @UserRentals
        SELECT
			rental_id,
            lock_id,
            (SELECT station_name FROM Stations WHERE station_id = (SELECT station_id FROM Locks WHERE lock_id = Rentals.lock_id)) AS station_name,
            rental_start_time,
            ISNULL(rental_end_time, GetDate()),
            DATEDIFF(minute, rental_start_time, ISNULL(rental_end_time, GetDate())),
            DATEDIFF(hour, rental_start_time, ISNULL(rental_end_time, GetDate())) * hourly_rate
        FROM Rentals
        WHERE user_id = @user_id AND (
            (@is_current = 0 AND rental_end_time IS NOT NULL)
            OR
            (@is_current = 1 AND rental_end_time IS NULL)            
        );
        RETURN;
    END;
GO