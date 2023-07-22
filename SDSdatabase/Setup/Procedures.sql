-- Drop Procedures If Exist
DROP PROCEDURE IF EXISTS InsertUserIfNotExists;
DROP PROCEDURE IF EXISTS StartRental;
DROP PROCEDURE IF EXISTS EndRental;

-- InsertUserIfNotExists Procedure
-- Params: user_id
-- If user_id not in Users table insert user_id into table
GO
CREATE OR ALTER PROCEDURE InsertUserIfNotExists(@user_id UNIQUEIDENTIFIER)
    AS
        INSERT INTO Users (user_id) 
        SELECT @user_id AS user_id
        WHERE NOT EXISTS (SELECT 1 FROM Users WHERE user_id = @user_id);
GO

-- StartRental Procedure
-- Returns: is_success (0 on failure and 1 on success)
-- If lock lock_id is free, give user user_id ownership of lock lock_id, and insert rental into Rentals table
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

-- EndRental Procedure
-- Params: user_id and lock_id
-- If rental rental_id is a current rental which belongs to user user_id, free rental lock, and update rental's rental_end_time
GO
CREATE OR ALTER PROCEDURE EndRental(@user_id UNIQUEIDENTIFIER, @rental_id INT)
    AS
    BEGIN
        DECLARE @ruser_id UNIQUEIDENTIFIER, @lock_id INT, @rentalEndTime DATETIME;
        SELECT @ruser_id = user_id, @lock_id = lock_id, @rentalEndTime = rental_end_time FROM Rentals WHERE rental_id = @rental_id;
        IF @ruser_id = @user_id AND @rentalEndTime IS NULL
            BEGIN
                UPDATE Locks SET user_id = NULL WHERE lock_id = @lock_id;
                UPDATE Rentals SET rental_end_time = GETDATE() WHERE rental_id = @rental_id;
                RETURN 1;
            END;
        RETURN 0;
    END;
GO