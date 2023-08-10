DROP TABLE IF EXISTS Rentals;
DROP TABLE IF EXISTS Locks;
DROP TABLE IF EXISTS Stations;

-- Station Table
CREATE TABLE Stations
(
  station_id INT IDENTITY (1, 1) PRIMARY KEY,
  station_url NVARCHAR(MAX) NOT NULL,
  station_name NVARCHAR(MAX) NOT NULL,
  location_latitude DECIMAL(9,6) NOT NULL,
  location_longitude DECIMAL(9,6) NOT NULL,
  hourly_rate DECIMAL(4,2) NOT NULL
);

-- Lock Table
CREATE TABLE Locks
(
  lock_id INT IDENTITY (1, 1) PRIMARY KEY,
  station_id INT NOT NULL,
  lock_key NVARCHAR(MAX) NOT NULL,
  lock_mac NVARCHAR(MAX) NOT NULL,
  user_id NVARCHAR(MAX),
  FOREIGN KEY (station_id) REFERENCES Stations(station_id)
);

-- Rental Table
CREATE TABLE Rentals
(
  rental_id INT IDENTITY (1, 1) PRIMARY KEY,
  user_id NVARCHAR(MAX) NOT NULL,
  lock_id INT NOT NULL,
  station_name NVARCHAR(MAX) NOT NULL,
  location_latitude DECIMAL(9,6) NOT NULL,
  location_longitude DECIMAL(9,6) NOT NULL,
  hourly_rate DECIMAL(4,2) NOT NULL,
  rental_start_time DATETIME NOT NULL,
  rental_end_time DATETIME,
  FOREIGN KEY (lock_id) REFERENCES Locks(lock_id)
);