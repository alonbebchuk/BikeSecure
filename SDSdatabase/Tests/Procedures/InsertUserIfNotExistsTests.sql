-- Test 1
DECLARE @test1 VARCHAR(7);
SET @test1 = 'Failure';
-- Arrange
DECLARE @userId1 UNIQUEIDENTIFIER;
SET @userId1 = '33333333-3333-3333-3333-333333333333';
-- Act
EXEC InsertUserIfNotExists @user_id = @userId1;
-- Assert
DECLARE @userAdded1 INT;
SELECT @userAdded1 = 1 FROM Users WHERE user_id = @userId1;
IF @userAdded1 = 1
	SET @test1 = 'Success';
-- Cleanup
DELETE FROM Users WHERE user_id = @userId1;

-- Test 2
DECLARE @test2 VARCHAR(7);
SET @test2 = 'Failure';
-- Arrange
DECLARE @userId2 UNIQUEIDENTIFIER;
SET @userId2 = '11111111-1111-1111-1111-111111111111';
-- Act and Assert
BEGIN TRY
	EXEC InsertUserIfNotExists @user_id = @userId2;
	SET @test2 = 'Success';
END TRY
BEGIN CATCH END CATCH;

SELECT @test1 AS insertUserIfNotExists_whenUserNotExists_insertsUser, @test2 AS insertUserIfNotExists_whenUserExists_doesNothing;