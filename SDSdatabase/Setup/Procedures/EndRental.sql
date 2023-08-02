DROP PROCEDURE IF EXISTS EndRental;
GO
CREATE OR ALTER PROCEDURE EndRental(@user_id UNIQUEIDENTIFIER, @rental_id INT)
    AS
    BEGIN
        DECLARE @ruser_id UNIQUEIDENTIFIER, @lock_id INT, @rentalEndTime DATETIME;
        SELECT @ruser_id = user_id, @lock_id = lock_id, @rentalEndTime = rental_end_time FROM Rentals WHERE rental_id = @rental_id;
        IF @ruser_id = @user_id AND @rentalEndTime IS NULL
            BEGIN
                UPDATE Locks SET user_id = NULL WHERE lock_id = @lock_id;
                UPDATE Rentals SET rental_end_time = GETDATE() WHERE rental_id = @rental_id;
                RETURN 1;
            END;
        RETURN 0;
    END;
GO