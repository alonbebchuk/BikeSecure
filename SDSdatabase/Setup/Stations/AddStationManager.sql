DROP PROCEDURE IF EXISTS AddStationManager;
GO
CREATE OR ALTER PROCEDURE AddStationManager
    -- Station Data
    @name NVARCHAR(MAX),
    @hourly_rate DECIMAL(4,2),
    @latitude DECIMAL(9,6),
    @longitude DECIMAL(9,6),
    -- Station Secret Data
    @url NVARCHAR(MAX)
AS
BEGIN
    INSERT INTO Stations
        (
        -- Station Data
        name,
        hourly_rate,
        latitude,
        longitude,
        -- Station Secret Data
        url
        )
    VALUES
        (
            -- Station Data
            @name,
            @hourly_rate,
            @latitude,
            @longitude,
            -- Station Secret Data
            @url
        );
END;
GO