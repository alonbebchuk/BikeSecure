CREATE OR ALTER FUNCTION StartRental( @uid UNIQUEIDENTIFIER, @lid INT )
    RETURNS BIT
    AS
    BEGIN
        -- Check Lock Is Available
        DECLARE @IsLockAvailable BIT;
        SELECT @IsLockAvailable = ISNULL(user_id) FROM Locks WHERE lock_id = @lid;
        IF @IsLockAvailable = 1
            -- Acquire Lock Ownership
            UPDATE Locks SET user_id = @uid WHERE lock_id = @lid;
            -- Start Rental
            DECLARE @StationId INT;
            SELECT @StationId = station_id FROM Locks WHERE lock_id = @lid;
            DECLARE @HourlyRate DECIMAL;
            SELECT @HourlyRate = hourly_rate FROM Stations WHERE station_id = @StationId;
            INSERT INTO Rentals (user_id, lock_id, hourly_rate, rental_start_time) VALUES (@uid, @lid, @HourlyRate, GETDATE());
            -- Success
            RETURN 1;
        RETURN 0;
    END
GO