CREATE OR ALTER FUNCTION GetCurrentRentals ( @uid UNIQUEIDENTIFIER )
    RETURNS @CurrentRentals Table (
        lock_id INT,
        rental_start_time DATETIME,
        rental_end_time DATETIME,
        rental_duration INT,
        total_cost DECIMAL
    )
    AS
    BEGIN
        SELECT
            lock_id,
            rental_start_time,
            rental_end_time,
            DATEDIFF(minute, rental_start_time, rental_end_time),
            DATEDIFF(year, rental_start_time, rental_end_time) * hourly_price
        FROM Rentals
        WHERE user_id = @uid AND ISNULL(rental_end_time) = 1;
        RETURN;
    END
GO