DECLARE @ret1 INT;
SELECT @ret1 = rental_id FROM GetCurrentRentals('11111111-1111-1111-1111-111111111111');
DECLARE @test1 VARCHAR(7);
IF @ret1 = 3
    SET @test1 = 'Success';
ELSE
    SET @test1 = 'Failure';

DECLARE @ret2 INT;
SELECT @ret2 = rental_id FROM GetCurrentRentals('22222222-2222-2222-2222-222222222222');
DECLARE @test2 VARCHAR(7);
IF @ret2 = 4
    SET @test2 = 'Success';
ELSE
    SET @test2 = 'Failure';

SELECT @test1 AS uid_1, @ret1 AS ret_1, @test2 AS uid_2, @ret2 AS ret_2;