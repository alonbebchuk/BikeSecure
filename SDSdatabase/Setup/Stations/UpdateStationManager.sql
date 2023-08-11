DROP PROCEDURE IF EXISTS UpdateStationManager;
GO
CREATE OR ALTER PROCEDURE UpdateStationManager
    @station_id INT,
    @hourly_rate DECIMAL(4,2)
AS
BEGIN
    UPDATE Stations
    SET hourly_rate = @hourly_rate
    WHERE id = @station_id;

    UPDATE Locks
    SET station_hourly_rate = @hourly_rate
    WHERE station_id = @station_id;
END;
GO