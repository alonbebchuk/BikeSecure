TRUNCATE TABLE Rentals;
TRUNCATE TABLE Stations
TRUNCATE TABLE Locks;
TRUNCATE TABLE Managers;
TRUNCATE TABLE Users;

-- User Table
INSERT INTO Users (user_id)
VALUES ('11111111-1111-1111-1111-111111111111'),
       ('22222222-2222-2222-2222-222222222222');

-- Manager Table
INSERT INTO Managers (manager_id)
VALUES ('33333333-3333-3333-3333-333333333333'),
       ('44444444-4444-4444-4444-444444444444');

-- Station Table
INSERT INTO Stations (station_id, manager_id, hourly_rate, location_latitude, location_longitude)
VALUES (1, '33333333-3333-3333-3333-333333333333', 10.50, 37.7749, -122.4194),
       (2, '44444444-4444-4444-4444-444444444444', 8.75, 34.0522, -118.2437);

-- Lock Table
INSERT INTO Locks (lock_id, station_id, lock_key, user_id)
VALUES (1, 1, 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', NULL),
       (2, 1, 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '22222222-2222-2222-2222-222222222222'),
       (3, 2, 'cccccccc-cccc-cccc-cccc-cccccccccccc', '11111111-1111-1111-1111-111111111111');

-- Rental Table
INSERT INTO Rentals (rental_id, user_id, lock_id, hourly_rate, rental_start_time, rental_end_time)
VALUES (1, '22222222-2222-2222-2222-222222222222', 1, 10.50, '2023-07-13 09:00:00', '2023-07-13 10:30:00'),
       (2, '11111111-1111-1111-1111-111111111111', 1, 10.50, '2023-07-13 12:00:00', '2023-07-13 13:30:00'),
       (3, '11111111-1111-1111-1111-111111111111', 3, 8.75, '2023-07-13 15:30:00', NULL),
       (4, '22222222-2222-2222-2222-222222222222', 2, 10.50, '2023-07-13 17:00:00', NULL);
