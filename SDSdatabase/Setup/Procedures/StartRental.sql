DROP PROCEDURE IF EXISTS StartRental;
GO
CREATE OR ALTER PROCEDURE StartRental
    @user_id NVARCHAR(MAX),
    @lock_id INT
AS
BEGIN
    DECLARE @lockStatus INT;
    SELECT @lockStatus = GetLockStatus(@user_id, @lock_id);

    IF @lockStatus = 0 -- Available (Unlocked)
    BEGIN
        UPDATE Locks
            SET user_id = @user_id
            WHERE lock_id = @lock_id;

        INSERT INTO Rentals
            (user_id, lock_id, station_name, location_latitude, location_longitude, hourly_rate, rental_start_time)
        SELECT
            @user_id, lock_id, station_name, location_latitude, location_longitude, hourly_rate, GETDATE()
        FROM Locks JOIN Stations
            ON Locks.station_id = Stations.station_id
        WHERE lock_id = @lock_id;

        RETURN 1;
    END;

    RETURN 0;
END;
GO