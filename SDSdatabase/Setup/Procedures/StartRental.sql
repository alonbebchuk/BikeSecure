DROP PROCEDURE IF EXISTS StartRental;
GO
CREATE OR ALTER PROCEDURE StartRental(@user_id UNIQUEIDENTIFIER, @lock_id INT)
    AS
    BEGIN
        DECLARE @lockRentalStatus INT;
        EXEC @lockRentalStatus = GetLockRentalStatus @user_id, @lock_id;
        IF @lockRentalStatus = 0 -- Available
            BEGIN
                UPDATE Locks
                SET user_id = @user_id
                WHERE lock_id = @lock_id;

                INSERT INTO Rentals (
                    user_id,
                    lock_id,
                    station_name,
                    location_latitude,
                    location_longitude,
                    hourly_rate,
                    rental_start_time
                )
                SELECT
                    @user_id,
                    lock_id,
                    station_name,
                    location_latitude,
                    location_longitude,
                    hourly_rate,
                    GETDATE()
                FROM Locks JOIN Stations
                ON Locks.station_id = Stations.station_id
                WHERE lock_id = @lock_id;

                RETURN 1;
            END;
        RETURN 0;
    END;
GO