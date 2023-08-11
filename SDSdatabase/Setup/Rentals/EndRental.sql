DROP PROCEDURE IF EXISTS EndRental;
GO
CREATE OR ALTER PROCEDURE EndRental
    @user_id NVARCHAR(MAX),
    @lock_id UNIQUEIDENTIFIER,
    -- Station Secret Data
    @url NVARCHAR(MAX) OUTPUT,
    -- Lock Secret Data
    @secret NVARCHAR(MAX) OUTPUT,
    @mac NVARCHAR(MAX) OUTPUT
AS
BEGIN
    DECLARE @lockStatus INT;
    SELECT @lockStatus = [dbo].[GetLockStatus](@user_id, @lock_id);

    IF @lockStatus = 1
    BEGIN
        DECLARE @now DATETIME;
        SET @now = GETDATE();

        INSERT INTO Rentals
            (
            -- Station Data
            station_id,
            station_name,
            latitude,
            longitude,
            hourly_rate,
            -- Lock Data
            lock_id,
            lock_name,
            -- Rental Data
            user_id,
            start_time,
            end_time,
            duration,
            cost
            )
        SELECT
            -- Station Data
            station_id,
            station_name,
            latitude,
            longitude,
            hourly_rate,
            -- Lock Data
            id,
            name,
            -- Rental Data
            user_id,
            start_time,
            @now,
            @now - start_time,
            DATEDIFF(HOUR, start_time, @now) * hourly_rate
        FROM
            Locks
        WHERE
            id = @lock_id;

        SELECT
            -- Station Secret Data
            @url = url,
            -- Lock Secret Data
            @secret = secret,
            @mac = mac
        FROM
            Locks
        WHERE
            id = @lock_id;

        UPDATE Locks
            SET
                -- Rental Data
                user_id = NULL,
                start_time = NULL
            WHERE
                id = @lock_id;

        RETURN 1;
    END;

    RETURN 0;
END;
GO