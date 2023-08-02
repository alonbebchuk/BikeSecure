DROP FUNCTION IF EXISTS GetUserStations;
GO
CREATE OR ALTER FUNCTION GetUserStations(@user_id UNIQUEIDENTIFIER)
    RETURNS @UserStations Table(
            station_name TEXT,
            hourly_rate DECIMAL(4,2),
            location_latitude DECIMAL,
            location_longitude DECIMAL,
            available_locks INT,
            user_owned_locks INT)
    BEGIN
        INSERT INTO @UserStations
        SELECT
		    station_name,
            hourly_rate,
            location_latitude,
            location_longitude,
            (SELECT COUNT(*) FROM Locks WHERE station_id = Stations.station_id AND user_id IS NULL) AS available_locks,
            (SELECT COUNT(*) FROM Locks WHERE station_id = Stations.station_id AND user_id = @user_id) AS user_owned_locks
        FROM Stations;
        RETURN;
    END;
GO