DROP FUNCTION IF EXISTS GetPastRentals;
GO
CREATE OR ALTER FUNCTION GetPastRentals(@user_id NVARCHAR(MAX))
RETURNS @PastRentals Table
(
    -- Station Data
    station_name NVARCHAR(MAX) NOT NULL,
    latitude DECIMAL(9,6) NOT NULL,
    longitude DECIMAL(9,6) NOT NULL,
    -- Lock Data
    lock_id UNIQUEIDENTIFIER NOT NULL,
    lock_name NVARCHAR(MAX) NOT NULL,
    -- Rental Data
    hourly_rate DECIMAL(4,2) NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    duration_days INT NOT NULL,
    duration_hours INT NOT NULL,
    cost DECIMAL(9,2) NOT NULL
)
BEGIN
    INSERT INTO @PastRentals
    SELECT
        -- Station Data
        station_name,
        latitude,
        longitude,
        -- Lock Data
        lock_id,
        lock_name,
        -- Rental Data
        hourly_rate,
        start_time,
        end_time,
        duration_days,
        duration_hours,
        cost
    FROM
        Rentals
    WHERE
        user_id = @user_id;

    RETURN;
END;
GO