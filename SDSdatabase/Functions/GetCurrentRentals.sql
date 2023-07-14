CREATE OR ALTER FUNCTION GetCurrentRentals ( @uid UNIQUEIDENTIFIER )
    RETURNS @CurrentRentals Table (
		rental_id INT,
        lock_id INT,
        rental_start_time DATETIME,
        rental_end_time DATETIME,
        rental_duration INT,
        total_cost DECIMAL
    )
    AS
    BEGIN
		INSERT INTO @CurrentRentals
        SELECT
			rental_id,
            lock_id,
            rental_start_time,
            rental_end_time,
            DATEDIFF(minute, rental_start_time, rental_end_time),
            DATEDIFF(year, rental_start_time, rental_end_time) * hourly_rate
        FROM Rentals
        WHERE user_id = @uid AND rental_end_time IS NULL;
        RETURN;
    END
GO