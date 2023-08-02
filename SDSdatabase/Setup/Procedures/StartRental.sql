DROP PROCEDURE IF EXISTS StartRental;
GO
CREATE OR ALTER PROCEDURE StartRental(@user_id UNIQUEIDENTIFIER, @lock_id INT)
    AS
    BEGIN
        DECLARE @isLockFree BIT;
        SELECT @isLockFree = 1 FROM Locks WHERE lock_id = @lock_id AND user_id IS NULL;
        IF @isLockFree = 1
            BEGIN
                UPDATE Locks SET user_id = @user_id WHERE lock_id = @lock_id;
                DECLARE @stationId INT;
                SELECT @stationId = station_id FROM Locks WHERE lock_id = @lock_id;
                DECLARE @hourlyRate DECIMAL(4,2);
                SELECT @hourlyRate = hourly_rate FROM Stations WHERE station_id = @stationId;
                INSERT INTO Rentals (user_id, lock_id, hourly_rate, rental_start_time) VALUES (@user_id, @lock_id, @hourlyRate, GETDATE());
                RETURN 1;
            END;
        RETURN 0;
    END;
GO