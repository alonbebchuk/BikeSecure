-- Drop Functions If Exist
DROP FUNCTION IF EXISTS AcquireLockKey;
DROP FUNCTION IF EXISTS GetUserRentals;

-- AcquireLockKey Function
-- Params: user_id and lock_id
-- Returns: lock_key if user user_id owns lock lock_id
GO
CREATE OR ALTER FUNCTION AcquireLockKey(@user_id UNIQUEIDENTIFIER, @lock_id INT)
    RETURNS UNIQUEIDENTIFIER
    BEGIN
        RETURN (SELECT lock_key FROM Locks WHERE lock_id = @lock_id AND user_id = @user_id);
    END;
GO

-- GetUserRentals Function
-- Params: user_id and is_current
-- Returns: information on all user user_id's rentals which have(is_current=0)/haven't(is_current=1) ended
GO
CREATE OR ALTER FUNCTION GetUserRentals(@user_id UNIQUEIDENTIFIER, @is_current BIT)
    RETURNS @UserRentals Table (
		rental_id INT,
        lock_id INT,
        rental_start_time DATETIME,
        rental_end_time DATETIME,
        rental_duration INT,
        total_cost DECIMAL(10,2)
    )
    BEGIN
		INSERT INTO @UserRentals
        SELECT
			rental_id,
            lock_id,
            rental_start_time,
            rental_end_time,
            DATEDIFF(minute, rental_start_time, rental_end_time),
            DATEDIFF(hour, rental_start_time, rental_end_time) * hourly_rate
        FROM Rentals
        WHERE user_id = @user_id AND (
            (@is_current = 0 AND rental_end_time IS NOT NULL)
            OR
            (@is_current = 1 AND rental_end_time IS NULL)            
        );
        RETURN;
    END;
GO