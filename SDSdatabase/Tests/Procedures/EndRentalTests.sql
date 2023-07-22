BEGIN
    DECLARE @userId UNIQUEIDENTIFIER;
    SET @userId = '11111111-1111-1111-1111-111111111111';

    -- Test 1
    DECLARE @test1 VARCHAR(7);
    SET @test1 = 'Failure';
    -- Arrange
    DECLARE @rentalId1 INT;
    SET @rentalId1 = 1;
    -- Act
    DECLARE @result1 INT;
    EXEC @result1 = EndRental @user_id = @userId, @rental_id = @rentalId1;
    -- Assert
    DECLARE @lockId1 INT;
    SELECT @lockId1 = lock_id FROM Rentals WHERE rental_id = 1;
    DECLARE @lockOwnershipReleased1 BIT;
    SELECT @lockOwnershipReleased1 = 1 FROM Locks WHERE lock_id = @lockId1 AND user_id IS NULL;
    DECLARE @endTimeSet1 BIT;
    SELECT @endTimeSet1 = 1 FROM Rentals WHERE rental_id = @rentalId1 AND rental_end_time IS NOT NULL;
    IF @result1 = 1 AND @lockOwnershipReleased1 = 1 AND @endTimeSet1 = 1
        SET @test1 = 'Success';
    -- Cleanup
    UPDATE Locks SET user_id = @userId WHERE lock_id = @lockId1;
    UPDATE Rentals SET rental_end_time = NULL WHERE rental_id = @rentalId1;
    
    -- Test 2
    DECLARE @test2 VARCHAR(7);
    SET @test2 = 'Failure';
    -- Arrange
    DECLARE @rentalId2 INT;
    SET @rentalId2 = 2;
    -- Act
    DECLARE @result2 BIT;
    EXEC @result2 = EndRental @user_id = @userId, @rental_id = @rentalId2;
    -- Assert
    IF @result2 = 0
        SET @test2 = 'Success';

    -- Test 3
    DECLARE @test3 VARCHAR(7);
    SET @test3 = 'Failure';
    -- Arrange
    DECLARE @rentalId3 INT;
    SET @rentalId3 = 3;
    -- Act
    DECLARE @result3 BIT;
    EXEC @result3 = EndRental @user_id = @userId, @rental_id = @rentalId3;
    -- Assert
    IF @result3 = 0
        SET @test3 = 'Success';

    SELECT @test1 AS endRental_whenOwner_rentalIsEnded, @result1 AS result1, @lockOwnershipReleased1 AS lock_ownership_released_1, @endTimeSet1 AS end_time_set_1, @test2 AS endRental_whenOwnerButRentalAlreadyEnded_rentalIsNotEnded, @test3 AS endRental_whenNotOwner_rentalIsNotEnded;
END