DROP TABLE IF EXISTS Rentals;
DROP TABLE IF EXISTS Locks;
DROP TABLE IF EXISTS Stations;

-- Station Table
CREATE TABLE Stations
(
    id INT IDENTITY (1, 1) PRIMARY KEY,
    -- Station Data
    name NVARCHAR(MAX) NOT NULL,
    hourly_rate DECIMAL(4,2) NOT NULL,
    latitude DECIMAL(9,6) NOT NULL,
    longitude DECIMAL(9,6) NOT NULL,
    -- Station Secret Data
    url NVARCHAR(MAX) NOT NULL,
    -- Soft Delete Flag
    deleted BIT NOT NULL DEFAULT 0
);

-- Lock Table
CREATE TABLE Locks
(
    id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    -- Station Data
    station_id INT FOREIGN KEY REFERENCES Stations(id) NOT NULL,
    station_name NVARCHAR(MAX) NOT NULL,
    station_hourly_rate DECIMAL(4,2) NOT NULL,
    latitude DECIMAL(9,6) NOT NULL,
    longitude DECIMAL(9,6) NOT NULL,
    -- Station Secret Data
    url NVARCHAR(MAX) NOT NULL,
    -- Lock Data
    name NVARCHAR(MAX) NOT NULL,
    -- Lock Secret Data
    secret BINARY(512) NOT NULL DEFAULT CRYPT_GEN_RANDOM(512),
    mac NVARCHAR(MAX) NOT NULL,
    -- Rental Data
    user_id NVARCHAR(MAX),
    hourly_rate DECIMAL(4,2),
    start_time DATETIME,
    -- Soft Delete Flag
    deleted BIT NOT NULL DEFAULT 0
);

-- Rental Table
CREATE TABLE Rentals
(
    id INT IDENTITY (1, 1) PRIMARY KEY, -- NOT USED
    -- Station Data
    station_id INT FOREIGN KEY REFERENCES Stations(id) NOT NULL,
    station_name NVARCHAR(MAX) NOT NULL,
    latitude DECIMAL(9,6) NOT NULL,
    longitude DECIMAL(9,6) NOT NULL,
    -- Lock Data
    lock_id UNIQUEIDENTIFIER FOREIGN KEY REFERENCES Locks(id) NOT NULL, -- NOT USED
    lock_name NVARCHAR(MAX) NOT NULL,
    -- Rental Data
    user_id NVARCHAR(MAX) NOT NULL,
    hourly_rate DECIMAL(4,2),
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    duration TIME NOT NULL,
    cost DECIMAL(9,2) NOT NULL
);