DROP FUNCTION IF EXISTS GetPastRentalsManager;
GO
CREATE OR ALTER FUNCTION GetPastRentalsManager(@station_id INT)
RETURNS @PastRentals Table
(
    -- Station Data
    station_name NVARCHAR(MAX) NOT NULL,
    -- Lock Data
    lock_name NVARCHAR(MAX) NOT NULL,
    -- Rental Data
    user_id NVARCHAR(MAX) NOT NULL,
    hourly_rate DECIMAL(4,2) NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    duration TIME NOT NULL,
    cost DECIMAL(9,2) NOT NULL
)
BEGIN
    INSERT INTO @PastRentals
    SELECT
        -- Station Data
        station_name,
        -- Lock Data
        lock_name,
        -- Rental Data
        user_id,
        hourly_rate,
        start_time,
        end_time,
        duration,
        cost
    FROM
        Rentals
    WHERE
        station_id = @station_id;

    RETURN;
END;
GO