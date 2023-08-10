DROP PROCEDURE IF EXISTS AddStation;
GO
CREATE PROCEDURE AddLock
    @station_id INT,
    @lock_key NVARCHAR(MAX),
    @lock_mac NVARCHAR(MAX)
AS
BEGIN
    INSERT INTO Locks
        (station_id, lock_key, lock_mac)
    VALUES
        (@station_id, @lock_key, @lock_mac);
END;
GO