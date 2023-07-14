CREATE OR ALTER FUNCTION EndRental( @uid UNIQUEIDENTIFIER, @rid INT )
    RETURNS BIT
    AS
    BEGIN
        -- Check User Owns Rental and Rental Not Ended
        DECLARE @RentalUID UNIQUEIDENTIFIER, @RentalLID INT, @RentalEndTime DATETIME;
        SELECT @RentalUID = user_id, @RentalLID = lock_id, @RentalEndTime = rental_end_time FROM Rentals WHERE rental_id = rid;
        IF @RentalUID = @uid AND ISNULL(@RentalEndTime) = 1
            -- Free Lock
            UPDATE Locks SET user_id = NULL WHERE lock_id = @RentalLID;
            -- End Rental
            UPDATE Rentals SET rental_end_time = GETDATE() WHERE rental_id = @rid;
            -- Success
            RETURN 1;
        RETURN 0;
    END
GO