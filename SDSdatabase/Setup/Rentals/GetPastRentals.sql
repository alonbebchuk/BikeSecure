DROP FUNCTION IF EXISTS GetPastRentals;
GO
CREATE OR ALTER FUNCTION GetPastRentals(@user_id NVARCHAR(MAX))
RETURNS @PastRentals Table
(
    -- Station Data
    station_name NVARCHAR(MAX) NOT NULL,
    latitude DECIMAL(9,6) NOT NULL,
    longitude DECIMAL(9,6) NOT NULL,
    hourly_rate DECIMAL(4,2) NOT NULL,
    -- Lock Data
    lock_id UNIQUEIDENTIFIER NOT NULL,
    lock_name NVARCHAR(MAX) NOT NULL,
    -- Rental Data
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
        latitude,
        longitude,
        hourly_rate,
        -- Lock Data
        lock_id,
        lock_name,
        -- Rental Data
        start_time,
        end_time,
        duration,
        cost
    FROM
        Rentals
    WHERE
        user_id = @user_id;

    RETURN;
END;
GO