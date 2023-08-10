DROP FUNCTION IF EXISTS GetStationLocks;
GO
CREATE FUNCTION GetStationLocks(@station_id INT)
RETURNS @StationLocks TABLE(
    lock_id INT NOT NULL,
    lock_key NVARCHAR(MAX) NOT NULL,
    lock_mac NVARCHAR(MAX) NOT NULL
)
AS
BEGIN
    INSERT INTO @StationLocks
        (lock_id, lock_key, lock_mac)
    SELECT
        lock_id, lock_key, lock_mac
    FROM Locks
    WHERE station_id = @station_id;

    RETURN;
END;
GO
