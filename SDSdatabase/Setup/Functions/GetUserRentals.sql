DROP FUNCTION IF EXISTS GetUserRentals;
GO
CREATE OR ALTER FUNCTION GetUserRentals(@user_id UNIQUEIDENTIFIER, @is_current BIT)
    RETURNS @UserRentals Table(
		rental_id INT,
        lock_id INT,
        station_name TEXT,
        rental_start_time DATETIME,
        rental_end_time DATETIME,
        rental_duration INT,
        total_cost DECIMAL(10,2))
    BEGIN
		INSERT INTO @UserRentals
        SELECT
			rental_id,
            lock_id,
            (SELECT station_name FROM Stations WHERE station_id = (SELECT station_id FROM Locks WHERE lock_id = Rentals.lock_id)) AS station_name,
            rental_start_time,
            ISNULL(rental_end_time, GetDate()),
            DATEDIFF(minute, rental_start_time, ISNULL(rental_end_time, GetDate())),
            DATEDIFF(hour, rental_start_time, ISNULL(rental_end_time, GetDate())) * hourly_rate
        FROM Rentals
        WHERE user_id = @user_id AND (
            (@is_current = 0 AND rental_end_time IS NOT NULL)
            OR
            (@is_current = 1 AND rental_end_time IS NULL)
        );
        RETURN;
    END;
GO