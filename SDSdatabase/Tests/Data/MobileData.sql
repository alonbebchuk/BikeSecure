DECLARE @user_id UNIQUEIDENTIFIER = CAST('11111111-1111-1111-1111-111111111111' AS UNIQUEIDENTIFIER);
DECLARE @manager_id UNIQUEIDENTIFIER = CAST('22222222-2222-2222-2222-222222222222' AS UNIQUEIDENTIFIER);

-- Station Table
INSERT INTO Stations (manager_id, station_name, location_latitude, location_longitude, hourly_rate)
VALUES
  (@manager_id, 'Rothschild Boulevard', 32.065527, 34.775338, 12.50),
  (@manager_id, 'Dizengoff Street', 32.077806, 34.771297, 11.75),
  (@manager_id, 'Allenby Street', 32.070581, 34.770361, 13.20),
  (@manager_id, 'Ben Yehuda Street', 32.086341, 34.770944, 10.85),
  (@manager_id, 'Rabin Square', 32.080203, 34.780570, 9.95),
  (@manager_id, 'Hayarkon Street', 32.093225, 34.769180, 14.30),
  (@manager_id, 'Ramat Aviv Mall', 32.113265, 34.804980, 12.00),
  (@manager_id, 'Sarona Market', 32.071859, 34.785594, 11.50),
  (@manager_id, 'Carmel Market', 32.067376, 34.769771, 10.25),
  (@manager_id, 'Habima Square', 32.072909, 34.779668, 12.75);

-- Lock Table
WITH LocksPattern AS (
    SELECT 
        station_id,
        1 AS lock_number,
        station_id AS total_locks
    FROM Stations
    UNION ALL
    SELECT 
        station_id,
        lock_number + 1,
        total_locks
    FROM LocksPattern
    WHERE lock_number < total_locks
      AND lock_number + 1 < 25
)
INSERT INTO Locks (station_id, user_id)
SELECT
    station_id,
    NULL
FROM LocksPattern;
UPDATE Locks
SET user_id = @user_id
WHERE lock_id IN (7, 10, 18, 23, 34, 45, 51);

-- Rental Table
WITH RentalStartTimes AS (
    SELECT 
        lock_id,
        station_id,
        DATEADD(HOUR, lock_id, '2023-07-21T00:00:00') AS rental_start_time
    FROM Locks
    WHERE user_id IS NOT NULL OR lock_id IN (8, 11, 24, 37, 43)
)
INSERT INTO Rentals (user_id, lock_id, station_name, location_latitude, location_longitude, hourly_rate, rental_start_time, rental_end_time)
SELECT 
    @user_id AS user_id,
    lock_id,
    station_name,
    location_latitude,
    location_longitude,
    hourly_rate,
    rental_start_time,
    IIF(lock_id IN (8, 11, 24, 37, 43), DATEADD(MINUTE, lock_id, '2023-07-21T00:00:00'), NULL)
FROM RentalStartTimes r
LEFT JOIN Stations s ON r.station_id = s.station_id;