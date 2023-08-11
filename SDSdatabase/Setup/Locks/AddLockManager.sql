DROP PROCEDURE IF EXISTS AddLockManager;
GO
CREATE OR ALTER PROCEDURE AddLockManager
    @station_id INT,
    @name NVARCHAR(MAX),
    @mac NVARCHAR(MAX)
AS
BEGIN
    INSERT INTO Locks (
        -- Station Data
        station_id,
        station_name,
        station_hourly_rate,
        latitude,
        longitude,
        -- Station Secret Data
        url,
        -- Lock Data
        name,
        -- Lock Secret Data
        mac
    )
    SELECT
        -- Station Data
        id,
        name,
        hourly_rate,
        latitude,
        longitude,
        -- Station Secret Data
        url,
        -- Lock Data
        @name,
        -- Lock Secret Data
        @mac
    FROM Stations
    WHERE id = @station_id;
END;
GO