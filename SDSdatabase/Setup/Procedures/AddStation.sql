DROP PROCEDURE IF EXISTS AddStation;
GO
CREATE PROCEDURE AddStation
    @station_url NVARCHAR(MAX),
    @station_name NVARCHAR(MAX),
    @location_latitude DECIMAL(9,6),
    @location_longitude DECIMAL(9,6),
    @hourly_rate DECIMAL(4,2)
AS
BEGIN
    INSERT INTO Stations
        (station_url, station_name, location_latitude, location_longitude, hourly_rate)
    VALUES
        (@station_url, @station_name, @location_latitude, @location_longitude, @hourly_rate);
END;
GO
