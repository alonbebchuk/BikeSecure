DECLARE @userId UNIQUEIDENTIFIER;
SET @userId = '11111111-1111-1111-1111-111111111111';

-- Test 1
DECLARE @test1 VARCHAR(7);
SET @test1 = 'Failure';
-- Arrange
DECLARE @lockId1 INT;
SET @lockId1 = 2;
DECLARE @expectedLockKey1 UNIQUEIDENTIFIER;
SELECT @expectedLockKey1 = lock_key FROM Locks WHERE lock_id = @lockId1;
-- Act
DECLARE @acquiredLockKey1 UNIQUEIDENTIFIER;
EXEC @acquiredLockKey1 = AcquireLockKey @user_id = @userId, @lock_id = @lockId1;
-- Assert
IF @acquiredLockKey1 = @expectedLockKey1
    SET @test1 = 'Success';

-- Test 2
DECLARE @test2 VARCHAR(7);
SET @test2 = 'Failure';
-- Arrange
DECLARE @lockId2 INT;
SET @lockId2 = 1;
-- Act
DECLARE @acquiredLockKey2 UNIQUEIDENTIFIER;
EXEC @acquiredLockKey2 = AcquireLockKey @user_id = @userId, @lock_id = @lockId2;
-- Assert
IF @acquiredLockKey2 IS NULL
    SET @test2 = 'Success';

-- Test Results
SELECT @test1 AS acquireLockKey_whenOwner_returnsLockKey, @acquiredLockKey1 AS acquired_lock_key_1, @test2 AS acquireLockKey_whenNotOwner_returnsNull, @acquiredLockKey2 AS acquired_lock_key_2;