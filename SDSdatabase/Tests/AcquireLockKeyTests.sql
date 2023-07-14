DECLARE @ret1 UNIQUEIDENTIFIER;
EXEC @ret1 = AcquireLockKey @uid = '11111111-1111-1111-1111-111111111111', @lid = 1;
DECLARE @test1 VARCHAR(7);
IF @ret1 IS NULL
    SET @test1 = 'Success';
ELSE
    SET @test1 = 'Failure';

DECLARE @ret2 UNIQUEIDENTIFIER;
EXEC @ret2 = AcquireLockKey @uid = '11111111-1111-1111-1111-111111111111', @lid = 2;
DECLARE @test2 VARCHAR(7);
IF @ret2 IS NULL
    SET @test2 = 'Success';
ELSE
    SET @test2 = 'Failure';

DECLARE @ret3 UNIQUEIDENTIFIER;
EXEC @ret3 = AcquireLockKey @uid = '11111111-1111-1111-1111-111111111111', @lid = 3;
DECLARE @test3 VARCHAR(7);
IF @ret3 = 'cccccccc-cccc-cccc-cccc-cccccccccccc'
    SET @test3 = 'Success';
ELSE
    SET @test3 = 'Failure';

SELECT @test1 AS uid_1_lid_1, @ret1 AS ret_1, @test2 AS uid_1_lid_2, @ret2 AS ret_2, @test3 AS uid_1_lid_3, @ret3 AS ret_3;