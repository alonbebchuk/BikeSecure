-- GetLock
SELECT * FROM GetLock('29E351E1-609F-43B6-96D4-631AF7458F27'); -- Rothschild Boulevard 1, Lock A

-- GetLockStatus
SELECT [dbo].[GetLockStatus]('user_413046ae5f07424db6ba9da0c4340a24', '29E351E1-609F-43B6-96D4-631AF7458F27'); -- 1
SELECT [dbo].[GetLockStatus]('user_413046ae5f07424db6ba9da0c4340a24', '99B4BBB2-751F-43DD-AEA9-7F7D10C0C914'); -- -1
SELECT [dbo].[GetLockStatus]('user_413046ae5f07424db6ba9da0c4340a24', '85a412cf-9f85-407a-96c0-55bba6f7d4c2'); -- 0

-- GetCurrentRentals
SELECT * FROM GetCurrentRentals('user_413046ae5f07424db6ba9da0c4340a24'); -- 10 rentals, 1 per station

-- GetPastRentals
SELECT * FROM GetPastRentals('user_413046ae5f07424db6ba9da0c4340a24'); -- 10 rentals, 1 per station

-- GetStations
SELECT * FROM GetStations('user_413046ae5f07424db6ba9da0c4340a24'); -- 10 stations, 3 total, 1 available, 1 owned