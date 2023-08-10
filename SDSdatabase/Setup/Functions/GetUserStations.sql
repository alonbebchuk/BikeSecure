DROP FUNCTION IF EXISTS GetUserStations;
GO
CREATE OR ALTER FUNCTION GetUserStations(@user_id NVARCHAR(MAX))
RETURNS @UserStations Table (
    station_name NVARCHAR(MAX) NOT NULL,
    location_latitude DECIMAL(9,6) NOT NULL,
    location_longitude DECIMAL(9,6) NOT NULL,
    hourly_rate DECIMAL(4,2) NOT NULL,
    available_locks INT NOT NULL,
    user_owned_locks INT NOT NULL
)
BEGIN
    INSERT INTO @UserStations
    SELECT
        station_name,
        location_latitude,
        location_longitude,
        hourly_rate,
        (SELECT COUNT(*)
        FROM Locks
        WHERE Locks.station_id = Stations.station_id AND user_id IS NULL) AS available_locks,
        (SELECT COUNT(*)
        FROM Locks
        WHERE Locks.station_id = Stations.station_id AND user_id = @user_id) AS user_owned_locks
    FROM Stations;
    RETURN;
END;
GO