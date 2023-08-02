DROP FUNCTION IF EXISTS GetUserRentals;
GO
CREATE OR ALTER FUNCTION GetUserRentals(@user_id UNIQUEIDENTIFIER, @is_current BIT)
    RETURNS @UserRentals Table (
        station_name TEXT NOT NULL,
        location_latitude DECIMAL(9,6) NOT NULL,
        location_longitude DECIMAL(9,6) NOT NULL,
        hourly_rate DECIMAL(4,2) NOT NULL,
        rental_start_time DATETIME,
        rental_end_time DATETIME
    )
    BEGIN
		INSERT INTO @UserRentals
        SELECT
            station_name,
            location_latitude,
            location_longitude,
            hourly_rate,
            rental_start_time,
            rental_end_time
        FROM Rentals
        WHERE user_id = @user_id
            AND @is_current = IIF(rental_end_time IS NULL, 1, 0);
        RETURN;
    END;
GO