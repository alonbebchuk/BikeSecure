DROP PROCEDURE IF EXISTS EndRental;
GO
CREATE OR ALTER PROCEDURE EndRental(@user_id NVARCHAR(MAX), @lock_id INT)
    AS
    BEGIN
        DECLARE @lockStatus INT;
        SELECT @lockStatus = CASE
            WHEN user_id IS NULL THEN 0     -- Available
            WHEN user_id = @user_id THEN 1  -- Owned
            ELSE NULL                       -- Unavailable
        END
        FROM Locks WHERE lock_id = @lock_id;
        IF @lockStatus = 1 -- Owned
            BEGIN
                UPDATE Locks
                SET user_id = NULL
                WHERE lock_id = @lock_id;

                UPDATE Rentals
                SET rental_end_time = GETDATE()
                WHERE user_id = @user_id
                    AND lock_id = @lock_id
                    AND rental_end_time IS NULL;

                RETURN 1;
            END;
        RETURN 0;
    END;
GO