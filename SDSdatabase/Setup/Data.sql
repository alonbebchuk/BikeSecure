INSERT INTO Stations
    (
    -- Station Data
    name,
    latitude,
    longitude,
    hourly_rate,
    -- Station Secret Data
    url
    )
VALUES
    ('Rothschild Boulevard 1', 32.065920, 34.773546, 8.50, 'rothschild1_url'),
    ('Allenby Street 23', 32.071081, 34.770131, 9.75, 'allenby23_url'),
    ('Dizengoff Street 56', 32.079060, 34.774771, 7.00, 'dizengoff56_url'),
    ('Ben Yehuda Street 12', 32.075175, 34.768674, 11.25, 'benyehuda12_url'),
    ('Nahalat Binyamin Street 8', 32.066709, 34.772862, 10.50, 'nahalatbinyamin8_url'),
    ('Herzl Street 40', 32.067747, 34.772158, 9.00, 'herzl40_url'),
    ('Hayarkon Street 100', 32.084224, 34.768315, 12.00, 'hayarkon100_url'),
    ('Ibn Gabirol Street 72', 32.076618, 34.782895, 6.50, 'ibngabirol72_url'),
    ('King George Street 20', 32.070835, 34.770655, 10.25, 'kinggeorge20_url'),
    ('Shenkin Street 8', 32.066509, 34.772424, 8.75, 'shenkin8_url');

INSERT INTO Locks
    (
    id,
    -- Station Data
    station_id,
    station_name,
    latitude,
    longitude,
    hourly_rate,
    -- Station Secret Data
    url,
    -- Lock Data
    name,
    -- Lock Secret Data
    secret,
    mac,
    -- Rental Data
    user_id,
    start_time
    )
VALUES
    ('29E351E1-609F-43B6-96D4-631AF7458F27', 1, 'Rothschild Boulevard 1', 32.065920, 34.773546, 8.50, 'rothschild1_url', 'Lock A', 'locksecret123A', '00:1A:2B:3C:4D:5E', 'user_413046ae5f07424db6ba9da0c4340a24', '2023-08-10 14:30:00'),
    (NEWID(), 1, 'Rothschild Boulevard 1', 32.065920, 34.773546, 8.50, 'rothschild1_url', 'Lock B', 'locksecret456B', '00:1A:2B:3C:4D:5F', NULL, NULL),
    (NEWID(), 1, 'Rothschild Boulevard 1', 32.065920, 34.773546, 8.50, 'rothschild1_url', 'Lock C', 'locksecret789C', '00:1A:2B:3C:4D:6A', 'user123', DATEADD(HOUR, 1, '2023-08-10 14:30:00')),
    ('99B4BBB2-751F-43DD-AEA9-7F7D10C0C914', 2, 'Allenby Street 23', 32.071081, 34.770131, 9.75, 'allenby23_url', 'Lock A', 'locksecret123A', '00:1A:2B:3C:4D:7E', 'user123', DATEADD(HOUR, 2, '2023-08-10 14:30:00')),
    (NEWID(), 2, 'Allenby Street 23', 32.071081, 34.770131, 9.75, 'allenby23_url', 'Lock B', 'locksecret456B', '00:1A:2B:3C:4D:7F', 'user_413046ae5f07424db6ba9da0c4340a24', DATEADD(HOUR, 3, '2023-08-10 14:30:00')),
    (NEWID(), 2, 'Allenby Street 23', 32.071081, 34.770131, 9.75, 'allenby23_url', 'Lock C', 'locksecret789C', '00:1A:2B:3C:4D:8A', NULL, NULL),
    ('85a412cf-9f85-407a-96c0-55bba6f7d4c2', 3, 'Dizengoff Street 56', 32.079060, 34.774771, 7.00, 'dizengoff56_url', 'Lock A', 'locksecret123A', '00:1A:2B:3C:4D:9E', NULL, NULL),
    (NEWID(), 3, 'Dizengoff Street 56', 32.079060, 34.774771, 7.00, 'dizengoff56_url', 'Lock B', 'locksecret456B', '00:1A:2B:3C:4D:9F', 'user123', DATEADD(HOUR, 4, '2023-08-10 14:30:00')),
    (NEWID(), 3, 'Dizengoff Street 56', 32.079060, 34.774771, 7.00, 'dizengoff56_url', 'Lock C', 'locksecret789C', '00:1A:2B:3C:4D:0A', 'user_413046ae5f07424db6ba9da0c4340a24', DATEADD(HOUR, 5, '2023-08-10 14:30:00')),
    ('3EDC862E-6A3F-4E0A-A11C-29BF8708A2D2', 4, 'Ben Yehuda Street 12', 32.075175, 34.768674, 11.25, 'benyehuda12_url', 'Lock A', 'locksecret123A', '00:1A:2B:3C:4D:1E', 'user_413046ae5f07424db6ba9da0c4340a24', DATEADD(HOUR, 6, '2023-08-10 14:30:00')),
    (NEWID(), 4, 'Ben Yehuda Street 12', 32.075175, 34.768674, 11.25, 'benyehuda12_url', 'Lock B', 'locksecret456B', '00:1A:2B:3C:4D:1F', NULL, NULL),
    (NEWID(), 4, 'Ben Yehuda Street 12', 32.075175, 34.768674, 11.25, 'benyehuda12_url', 'Lock C', 'locksecret789C', '00:1A:2B:3C:4D:2A', 'user123', DATEADD(HOUR, 7, '2023-08-10 14:30:00')),
    ('417B31CE-6ED7-4C4A-BFB3-4A7464DFA842', 5, 'Nahalat Binyamin Street 8', 32.066709, 34.772862, 10.50, 'nahalatbinyamin8_url', 'Lock A', 'locksecret123A', '00:1A:2B:3C:4D:3E', 'user123', DATEADD(HOUR, 8, '2023-08-10 14:30:00')),
    (NEWID(), 5, 'Nahalat Binyamin Street 8', 32.066709, 34.772862, 10.50, 'nahalatbinyamin8_url', 'Lock B', 'locksecret456B', '00:1A:2B:3C:4D:3F', 'user_413046ae5f07424db6ba9da0c4340a24', DATEADD(HOUR, 9, '2023-08-10 14:30:00')),
    (NEWID(), 5, 'Nahalat Binyamin Street 8', 32.066709, 34.772862, 10.50, 'nahalatbinyamin8_url', 'Lock C', 'locksecret789C', '00:1A:2B:3C:4D:4A', NULL, NULL),
    ('7A3F48E9-CB85-4506-B963-3E93F8F3D12D', 6, 'Herzl Street 40', 32.067747, 34.772158, 9.00, 'herzl40_url', 'Lock A', 'locksecret123A', '00:1A:2B:3C:4D:5E', NULL, NULL),
    (NEWID(), 6, 'Herzl Street 40', 32.067747, 34.772158, 9.00, 'herzl40_url', 'Lock B', 'locksecret456B', '00:1A:2B:3C:4D:5F', 'user123', DATEADD(HOUR, 10, '2023-08-10 14:30:00')),
    (NEWID(), 6, 'Herzl Street 40', 32.067747, 34.772158, 9.00, 'herzl40_url', 'Lock C', 'user_413046ae5f07424db6ba9da0c4340a24', '00:1A:2B:3C:4D:6A', 'user_413046ae5f07424db6ba9da0c4340a24', DATEADD(HOUR, 11, '2023-08-10 14:30:00')),
    ('8B4D7E6F-9840-4ED4-8DEE-CA877F0E7B49', 7, 'Hayarkon Street 100', 32.084224, 34.768315, 12.00, 'hayarkon100_url', 'Lock A', 'user_413046ae5f07424db6ba9da0c4340a24', '00:1A:2B:3C:4D:7E', 'user_413046ae5f07424db6ba9da0c4340a24', DATEADD(HOUR, 12, '2023-08-10 14:30:00')),
    (NEWID(), 7, 'Hayarkon Street 100', 32.084224, 34.768315, 12.00, 'hayarkon100_url', 'Lock B', 'locksecret456B', '00:1A:2B:3C:4D:7F', NULL, NULL),
    (NEWID(), 7, 'Hayarkon Street 100', 32.084224, 34.768315, 12.00, 'hayarkon100_url', 'Lock C', 'locksecret789C', '00:1A:2B:3C:4D:8A', 'user123', DATEADD(HOUR, 13, '2023-08-10 14:30:00')),
    ('9C7B4A7E-1E96-4DE6-9645-DC6A549F1B6C', 8, 'Ibn Gabirol Street 72', 32.076618, 34.782895, 6.50, 'ibngabirol72_url', 'Lock A', 'locksecret123A', '00:1A:2B:3C:4D:9E', 'user123', DATEADD(HOUR, 14, '2023-08-10 14:30:00')),
    (NEWID(), 8, 'Ibn Gabirol Street 72', 32.076618, 34.782895, 6.50, 'ibngabirol72_url', 'Lock B', 'user_413046ae5f07424db6ba9da0c4340a24', '00:1A:2B:3C:4D:9F', 'user_413046ae5f07424db6ba9da0c4340a24', DATEADD(HOUR, 15, '2023-08-10 14:30:00')),
    (NEWID(), 8, 'Ibn Gabirol Street 72', 32.076618, 34.782895, 6.50, 'ibngabirol72_url', 'Lock C', 'locksecret789C', '00:1A:2B:3C:4D:0A', NULL, NULL),
    ('A1B2C3D4-E5F6-7A8B-9C0D-E1F2A3B4C5D6', 9, 'King George Street 20', 32.070835, 34.770655, 10.25, 'kinggeorge20_url', 'Lock A', 'locksecret123A', '00:1A:2B:3C:4D:1E', NULL, NULL),
    (NEWID(), 9, 'King George Street 20', 32.070835, 34.770655, 10.25, 'kinggeorge20_url', 'Lock B', 'locksecret456B', '00:1A:2B:3C:4D:1F', 'user123', DATEADD(HOUR, 16, '2023-08-10 14:30:00')),
    (NEWID(), 9, 'King George Street 20', 32.070835, 34.770655, 10.25, 'kinggeorge20_url', 'Lock C', 'user_413046ae5f07424db6ba9da0c4340a24', '00:1A:2B:3C:4D:2A', 'user_413046ae5f07424db6ba9da0c4340a24', DATEADD(HOUR, 17, '2023-08-10 14:30:00')),
    ('B5C6D7E8-F9A0-B1C2-D3E4-F5A6B7C8D9E0', 10, 'Shenkin Street 8', 32.066509, 34.772424, 8.75, 'shenkin8_url', 'Lock A', 'locksecret123A', '00:1A:2B:3C:4D:3E', 'user_413046ae5f07424db6ba9da0c4340a24', DATEADD(HOUR, 18, '2023-08-10 14:30:00')),
    (NEWID(), 10, 'Shenkin Street 8', 32.066509, 34.772424, 8.75, 'shenkin8_url', 'Lock B', 'locksecret456B', '00:1A:2B:3C:4D:3F', NULL, NULL),
    (NEWID(), 10, 'Shenkin Street 8', 32.066509, 34.772424, 8.75, 'shenkin8_url', 'Lock C', 'locksecret789C', '00:1A:2B:3C:4D:4A', 'user123', DATEADD(HOUR, 19, '2023-08-10 14:30:00'));

-- Insert Rentals for all stations
INSERT INTO Rentals
    (
    -- Station Data
    station_id,
    station_name,
    latitude,
    longitude,
    hourly_rate,
    -- Lock Data
    lock_id,
    lock_name,
    -- Rental Data
    user_id,
    start_time,
    end_time,
    duration,
    cost
    )
VALUES
    (1, 'Rothschild Boulevard 1', 32.065708, 34.774066, 11.00, '29E351E1-609F-43B6-96D4-631AF7458F27', 'Lock A', 'user_413046ae5f07424db6ba9da0c4340a24', '2023-08-10 14:30:00', '2023-08-10 15:30:00', '01:00:00', 11.00),
    (2, 'Dizengoff Square 8', 32.075163, 34.772736, 8.50, '99B4BBB2-751F-43DD-AEA9-7F7D10C0C914', 'Lock A', 'user_413046ae5f07424db6ba9da0c4340a24', '2023-08-10 15:30:00', '2023-08-10 16:45:00', '01:15:00', 8.50),
    (3, 'Habima Theater 12', 32.071972, 34.783868, 9.75, '85a412cf-9f85-407a-96c0-55bba6f7d4c2', 'Lock A', 'user_413046ae5f07424db6ba9da0c4340a24', '2023-08-10 16:30:00', '2023-08-10 17:45:00', '01:15:00', 9.75),
    (4, 'Gordon Beach 5', 32.075940, 34.768092, 10.00, '3EDC862E-6A3F-4E0A-A11C-29BF8708A2D2', 'Lock A', 'user_413046ae5f07424db6ba9da0c4340a24', '2023-08-10 17:30:00', '2023-08-10 18:45:00', '01:15:00', 10.00),
    (5, 'Rabin Square 18', 32.080912, 34.781514, 8.25, '417B31CE-6ED7-4C4A-BFB3-4A7464DFA842', 'Lock A', 'user_413046ae5f07424db6ba9da0c4340a24', '2023-08-10 18:30:00', '2023-08-10 19:45:00', '01:15:00', 8.25),
    (6, 'Herzl Street 40', 32.067747, 34.772158, 9.00, '7A3F48E9-CB85-4506-B963-3E93F8F3D12D', 'Lock A', 'user_413046ae5f07424db6ba9da0c4340a24', '2023-08-10 19:30:00', '2023-08-10 20:45:00', '01:15:00', 9.00),
    (7, 'Hayarkon Street 100', 32.084224, 34.768315, 12.00, '8B4D7E6F-9840-4ED4-8DEE-CA877F0E7B49', 'Lock A', 'user_413046ae5f07424db6ba9da0c4340a24', '2023-08-10 20:30:00', '2023-08-10 21:30:00', '01:00:00', 12.00),
    (8, 'Ibn Gabirol Street 72', 32.076618, 34.782895, 6.50, '9C7B4A7E-1E96-4DE6-9645-DC6A549F1B6C', 'Lock A', 'user_413046ae5f07424db6ba9da0c4340a24', '2023-08-10 21:30:00', '2023-08-10 22:45:00', '01:15:00', 6.50),
    (9, 'King George Street 20', 32.070835, 34.770655, 10.25, 'A1B2C3D4-E5F6-7A8B-9C0D-E1F2A3B4C5D6', 'Lock A', 'user_413046ae5f07424db6ba9da0c4340a24', '2023-08-10 22:30:00', '2023-08-10 23:30:00', '01:00:00', 10.25),
    (10, 'Shenkin Street 8', 32.066509, 34.772424, 8.75, 'B5C6D7E8-F9A0-B1C2-D3E4-F5A6B7C8D9E0', 'Lock A', 'user_413046ae5f07424db6ba9da0c4340a24', '2023-08-10 23:00:00', '2023-08-11 00:00:00', '01:00:00', 8.75);