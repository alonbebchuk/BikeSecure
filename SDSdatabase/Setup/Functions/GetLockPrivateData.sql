DROP FUNCTION IF EXISTS GetLockPrivateData;
GO
CREATE OR ALTER FUNCTION GetLockPrivateData(@user_id NVARCHAR(MAX), @lock_id INT, @action BIT)
RETURNS @LockPrivateData Table(
    user_id NVARCHAR(MAX) NOT NULL,
    lock_id INT NOT NULL,
    action bit NOT NULL,
    station_url NVARCHAR(MAX) NOT NULL,
    lock_mac NVARCHAR(MAX) NOT NULL,
    lock_key NVARCHAR(MAX) NOT NULL
)
BEGIN
    DECLARE @lockStatus INT;
    SELECT @lockStatus = GetLockStatus(@user_id, @lock_id);

    -- (action = 1(Lock) AND @lockStatus = 0(Unlocked)) OR (action = 0(Unock) AND @lockStatus = 0(Owned - Locked by @user_id))
    IF (action = 1 AND @lockStatus = 0) OR (action = 0 AND @lockStatus = 1)
    BEGIN
        INSERT INTO @LockPrivateData
            (user_id, lock_id, action, station_url, lock_mac, lock_key)
        SELECT
            @user_id, lock_id, @action, station_url, lock_mac, lock_key
        FROM Locks INNER JOIN Stations
            ON Locks.station_id = Stations.station_id
        WHERE lock_id = @lock_id
            AND action = @lockStatus;
    END;

    RETURN;
END;
GO
