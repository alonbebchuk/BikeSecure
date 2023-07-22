-- User Table
INSERT INTO Users (user_id)
VALUES ('11111111-1111-1111-1111-111111111111'),
       ('22222222-2222-2222-2222-222222222222');

-- Manager Table
INSERT INTO Managers (manager_id)
VALUES ('11111111-1111-1111-1111-111111111111');

-- Station Table
INSERT INTO Stations (manager_id, hourly_rate, location_latitude, location_longitude)
VALUES ('11111111-1111-1111-1111-111111111111', 10.50, 37.7749, -122.4194), -- station_id=1
       ('11111111-1111-1111-1111-111111111111', 8.75, 34.0522, -118.2437);  -- station_id=2

-- Lock Table
INSERT INTO Locks (station_id, lock_key, user_id)
VALUES (1, 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', NULL),                                   -- lock_id=1
       (2, 'cccccccc-cccc-cccc-cccc-cccccccccccc', '11111111-1111-1111-1111-111111111111'); -- lock_id=2

-- Rental Table
INSERT INTO Rentals (user_id, lock_id, hourly_rate, rental_start_time, rental_end_time)
VALUES ('11111111-1111-1111-1111-111111111111', 2, 8.75, '2023-07-13 15:30:00', NULL),                   -- rental_id=1
       ('11111111-1111-1111-1111-111111111111', 1, 10.50, '2023-07-13 12:00:00', '2023-07-13 13:30:00'), -- rental_id=2
       ('22222222-2222-2222-2222-222222222222', 1, 8.75, '2023-07-13 15:30:00', NULL);                   -- rental_id=3