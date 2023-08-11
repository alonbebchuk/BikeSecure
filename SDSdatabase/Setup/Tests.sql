-- GetLock
SELECT * FROM GetLock('user_413046ae5f07424db6ba9da0c4340a24', '29E351E1-609F-43B6-96D4-631AF7458F27'); -- Lock Status 1, Rothschild Boulevard 1, Lock A
SELECT * FROM GetLock('user_413046ae5f07424db6ba9da0c4340a24', '99B4BBB2-751F-43DD-AEA9-7F7D10C0C914'); -- Lock Status -1, Allenby Street 23, Lock A
SELECT * FROM GetLock('user_413046ae5f07424db6ba9da0c4340a24', '85a412cf-9f85-407a-96c0-55bba6f7d4c2'); -- Lock Status 0, Dizengoff Street 56, Lock A

-- GetCurrentRentals
SELECT * FROM GetCurrentRentals('user_413046ae5f07424db6ba9da0c4340a24'); -- 10 rentals, 1 per station

-- GetPastRentals
SELECT * FROM GetPastRentals('user_413046ae5f07424db6ba9da0c4340a24'); -- 10 rentals, 1 per station

-- GetStations
SELECT * FROM GetStations('user_413046ae5f07424db6ba9da0c4340a24'); -- 10 stations, 3 locks, 1 free lock, 1 owned lock

-- StartRental
DECLARE @res INT;
DECLARE @url NVARCHAR(MAX);
DECLARE @secret BINARY(512);
DECLARE @mac NVARCHAR(MAX);

EXEC @res = EndRental 'user_413046ae5f07424db6ba9da0c4340a24', '99B4BBB2-751F-43DD-AEA9-7F7D10C0C914', @url OUTPUT, @secret OUTPUT, @mac OUTPUT;
SELECT @res, @url, @secret, @mac; -- Lock Status -1: 0, NULL, NULL, NULL
EXEC @res = StartRental 'user_413046ae5f07424db6ba9da0c4340a24', '99B4BBB2-751F-43DD-AEA9-7F7D10C0C914', @url OUTPUT, @secret OUTPUT, @mac OUTPUT;
SELECT @res, @url, @secret, @mac; -- Lock Status -1: 0, NULL, NULL, NULL

EXEC @res = EndRental 'user_413046ae5f07424db6ba9da0c4340a24', '85a412cf-9f85-407a-96c0-55bba6f7d4c2', @url OUTPUT, @secret OUTPUT, @mac OUTPUT;
SELECT @res, @url, @secret, @mac; -- Lock Status 0: 0, NULL, NULL, NULL
EXEC @res = StartRental 'user_413046ae5f07424db6ba9da0c4340a24', '85a412cf-9f85-407a-96c0-55bba6f7d4c2', @url OUTPUT, @secret OUTPUT, @mac OUTPUT;
SELECT @res, @url, @secret, @mac; -- Lock Status 0: 1, url, secret, mac

EXEC @res = StartRental 'user_413046ae5f07424db6ba9da0c4340a24', '85a412cf-9f85-407a-96c0-55bba6f7d4c2', @url OUTPUT, @secret OUTPUT, @mac OUTPUT;
SELECT @res, @url, @secret, @mac; -- Lock Status 1: 0, NULL, NULL, NULL
EXEC @res = EndRental 'user_413046ae5f07424db6ba9da0c4340a24', '85a412cf-9f85-407a-96c0-55bba6f7d4c2', @url OUTPUT, @secret OUTPUT, @mac OUTPUT;
SELECT @res, @url, @secret, @mac; -- Lock Status 1: 1, url, secret, mac