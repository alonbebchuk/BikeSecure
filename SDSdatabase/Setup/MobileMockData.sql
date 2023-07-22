DECLARE @user_id UNIQUEIDENTIFIER = '123e4567-e89b-12d3-a456-426614174000';
DECLARE @manager_id UNIQUEIDENTIFIER = '987e6543-a21b-23d4-c456-314159265358';

INSERT INTO Users (user_id) VALUES (@user_id);

INSERT INTO Managers (manager_id) VALUES (@manager_id);

INSERT INTO Stations (manager_id, station_name, hourly_rate, location_latitude, location_longitude)
VALUES
  (@manager_id, 'Rothschild Boulevard', 12.50, 32.065527, 34.775338),
  (@manager_id, 'Dizengoff Street', 11.75, 32.077806, 34.771297),
  (@manager_id, 'Allenby Street', 13.20, 32.070581, 34.770361),
  (@manager_id, 'Ben Yehuda Street', 10.85, 32.086341, 34.770944),
  (@manager_id, 'Rabin Square', 9.95, 32.080203, 34.780570),
  (@manager_id, 'Hayarkon Street', 14.30, 32.093225, 34.769180),
  (@manager_id, 'Ramat Aviv Mall', 12.00, 32.113265, 34.804980),
  (@manager_id, 'Sarona Market', 11.50, 32.071859, 34.785594),
  (@manager_id, 'Carmel Market', 10.25, 32.067376, 34.769771),
  (@manager_id, 'Habima Square', 12.75, 32.072909, 34.779668);

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
INSERT INTO Locks (station_id, lock_key, user_id)
SELECT
    station_id,
    NEWID(),
    NULL
FROM LocksPattern;
UPDATE Locks
SET user_id = @user_id
WHERE lock_id IN (7, 10, 18, 23, 34, 45, 51);

WITH RentalStartTimes AS (
    SELECT 
        lock_id,
        station_id,
        DATEADD(HOUR, lock_id, '2023-07-21T00:00:00') AS rental_start_time
    FROM Locks
    WHERE user_id IS NOT NULL
)
INSERT INTO Rentals (user_id, lock_id, hourly_rate, rental_start_time, rental_end_time)
SELECT 
    @user_id AS user_id,
    lock_id,
    hourly_rate,
    rental_start_time,
    NULL
FROM RentalStartTimes r
LEFT JOIN Stations s ON r.station_id = s.station_id;

WITH RentalStartTimes AS (
    SELECT 
        lock_id,
        station_id,
        DATEADD(MINUTE, lock_id, '2023-07-21T00:00:00') AS rental_start_time
    FROM Locks
    WHERE lock_id IN (8, 11, 18, 24, 37, 43)
)
INSERT INTO Rentals (user_id, lock_id, hourly_rate, rental_start_time, rental_end_time)
SELECT 
    @user_id AS user_id,
    lock_id,
    hourly_rate,
    rental_start_time,
    DATEADD(HOUR, lock_id % 24, rental_start_time) AS rental_end_time
FROM RentalStartTimes r
LEFT JOIN Stations s ON r.station_id = s.station_id;