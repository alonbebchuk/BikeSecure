BEGIN
    DECLARE @userId UNIQUEIDENTIFIER;
    SET @userId = '11111111-1111-1111-1111-111111111111';

    -- Test 1
    DECLARE @test1 VARCHAR(7);
    SET @test1 = 'Failure';
    -- Arrange
    DECLARE @lockId1 INT;
    SET @lockId1 = 1;
    DECLARE @expectedRentalCount1 INT;
    SET @expectedRentalCount1 = 4;
    DECLARE @expectedHourlyRate1 DECIMAL(4,2);
    SET @expectedHourlyRate1 = 10.50;
    -- Act
    DECLARE @result1 INT;
    EXEC @result1 = StartRental @user_id = @userId, @lock_id = @lockId1;
    -- Assert
    DECLARE @lockOwnershipAcquired1 BIT;
    SELECT @lockOwnershipAcquired1 = 1 FROM Locks WHERE lock_id = @lockId1 AND user_id = @userId;
    DECLARE @rentalCount1 INT;
    SELECT @rentalCount1 = COUNT(*) FROM Rentals;
    IF @result1 = 1 AND @lockOwnershipAcquired1 = 1 AND @rentalCount1 = @expectedRentalCount1
        BEGIN
            DECLARE @rentalDetailsAreCorrect1 BIT;
            SELECT @rentalDetailsAreCorrect1 = 1
            FROM Rentals
            WHERE rental_id = (SELECT MAX(rental_id) FROM Rentals)
                AND user_id = @userId
                AND lock_id = @lockId1
                AND hourly_rate = @expectedHourlyRate1
                AND rental_start_time IS NOT NULL
                AND rental_end_time IS NULL;
            IF @rentalDetailsAreCorrect1 = 1
                SET @test1 = 'Success';
        END
    -- Cleanup
    UPDATE Locks SET user_id = NULL WHERE lock_id = @lockId1;
    IF @rentalCount1 = @expectedRentalCount1
        DELETE FROM Rentals WHERE rental_id = (SELECT MAX(rental_id) FROM Rentals);

    -- Test 2
    DECLARE @test2 VARCHAR(7);
    SET @test2 = 'Failure';
    -- Arrange
    DECLARE @lockId2 INT;
    SET @lockId2 = 2;
    -- Act
    DECLARE @result2 BIT;
    EXEC @result2 = StartRental @user_id = @userId, @lock_id = @lockId2;
    -- Assert
    IF @result2 = 0
        SET @test2 = 'Success';

    SELECT @test1 AS startRental_whenLockFree_rentalIsStarted, @result1 AS result1, @lockOwnershipAcquired1 AS lock_ownership_acquired_1, @rentalCount1 AS rental_count_1, @rentalDetailsAreCorrect1 AS rental_details_are_correct_1, @test2 AS startRental_whenLockNotFree_rentalIsNotStarted;
END