DROP FUNCTION IF EXISTS GetStations;
GO
CREATE OR ALTER FUNCTION GetStations(@user_id NVARCHAR(MAX))
RETURNS @Stations Table
(
    -- Station Data
    id INT NOT NULL,
    name NVARCHAR(MAX) NOT NULL,
    hourly_rate DECIMAL(4,2) NOT NULL,
    latitude DECIMAL(9,6) NOT NULL,
    longitude DECIMAL(9,6) NOT NULL,
    -- Station Calculated Data
    lock_count INT NOT NULL,
    free_lock_count INT NOT NULL,
    owned_lock_count INT NOT NULL,
    -- Soft Delete Flag
    deleted BIT NOT NULL
)
BEGIN
    DECLARE @manager BIT;
    SET @manager = IIF(@user_id IS NULL, 1, 0);

    WITH
        StationLockCounts
        (
            station_id,
            lock_count,
            free_lock_count,
            owned_lock_count
        )
        AS
        (
            SELECT
                Stations.id,
                SUM(1),
                SUM(IIF(user_id IS NULL, 1, 0)),
                SUM(IIF(user_id = @user_id , 1, 0))
            FROM
                Stations INNER JOIN Locks
                ON
                Stations.id = Locks.station_id
            GROUP BY
                Stations.id
        )
    INSERT INTO @Stations
    SELECT
        -- Station Data
        Stations.id,
        Stations.name,
        Stations.hourly_rate,
        Stations.latitude,
        Stations.longitude,
        -- Station Calculated Data
        StationLockCounts.lock_count,
        StationLockCounts.free_lock_count,
        StationLockCounts.owned_lock_count,
        -- Soft Delete Flag
        Stations.deleted
    FROM
        Stations INNER JOIN StationLockCounts
        ON
        Stations.id = StationLockCounts.station_id
    WHERE (@manager = 1 OR deleted = 0);

    RETURN;
END;
GO