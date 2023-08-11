DROP FUNCTION IF EXISTS GetCurrentRentalsManager;
GO
CREATE OR ALTER FUNCTION GetCurrentRentalsManager(@station_id INT)
RETURNS @CurrentRentals Table
(
    -- Station Data
    station_name NVARCHAR(MAX) NOT NULL,
    -- Lock Data
    lock_name NVARCHAR(MAX) NOT NULL,
    -- Rental Data
    user_id NVARCHAR(MAX) NOT NULL,
    hourly_rate DECIMAL(4,2) NOT NULL,
    start_time DATETIME NOT NULL
)
BEGIN
    INSERT INTO @CurrentRentals
    SELECT
        -- Station Data
        station_name,
        -- Lock Data
        name,
        -- Rental Data
        user_id,
        hourly_rate,
        start_time
    FROM
        Locks
    WHERE
        station_id = @station_id
        AND
        user_id IS NOT NULL;

    RETURN;
END;
GO