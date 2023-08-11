DROP PROCEDURE IF EXISTS DeleteStationManager;
GO
CREATE OR ALTER PROCEDURE DeleteStationManager
    @station_id INT
AS
BEGIN
    DELETE FROM Stations
    WHERE id = @station_id;

    DELETE FROM Locks
    WHERE
        station_id = @station_id
        AND
        user_id IS NULL;

    UPDATE Locks
    SET deleted = 1
    WHERE
        station_id = @station_id
        AND
        user_id IS NOT NULL;
END;
GO