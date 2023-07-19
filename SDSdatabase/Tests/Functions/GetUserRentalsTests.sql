DECLARE @userId UNIQUEIDENTIFIER;
SET @userId = '11111111-1111-1111-1111-111111111111';

-- Test 1
DECLARE @test1 VARCHAR(7);
SET @test1 = 'Failure';
-- Arrange
DECLARE @expectedRentalId1 INT;
SET @expectedRentalId1 = 2;
-- Act
DECLARE @rentalId1 INT;
SELECT @rentalId1 = rental_id FROM GetUserRentals(@userId, 0);
-- Assert
IF @rentalId1 = @expectedRentalId1
    SET @test1 = 'Success';

-- Test 2
DECLARE @test2 VARCHAR(7);
SET @test2 = 'Failure';
-- Arrange
DECLARE @expectedRentalId2 INT;
SET @expectedRentalId2 = 1;
-- Act
DECLARE @rentalId2 INT;
SELECT @rentalId2 = rental_id FROM GetUserRentals(@userId, 1);
-- Assert
IF @rentalId2 = @expectedRentalId2
    SET @test2 = 'Success';

SELECT @test1 AS getUserRentals_whenNotIsCurrent_returnsPastRentals, @rentalId1 AS rental_id_1, @test1 AS getUserRentals_whenIsCurrent_returnsCurrentRentals, @rentalId2 AS rental_id_2;