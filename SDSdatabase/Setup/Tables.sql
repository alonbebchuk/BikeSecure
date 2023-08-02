-- Drop Tables If Exist
DROP TABLE IF EXISTS Rentals;
DROP TABLE IF EXISTS Locks;
DROP TABLE IF EXISTS Stations;
DROP TABLE IF EXISTS Managers;
DROP TABLE IF EXISTS Users;

-- User Table
CREATE TABLE Users (
  user_id UNIQUEIDENTIFIER PRIMARY KEY
);

-- Manager Table
CREATE TABLE Managers (
  manager_id UNIQUEIDENTIFIER PRIMARY KEY
);

-- Station Table
CREATE TABLE Stations (
  station_id INT IDENTITY (1, 1) PRIMARY KEY,
  manager_id UNIQUEIDENTIFIER NOT NULL,
  station_name TEXT,
  hourly_rate DECIMAL(4,2) NOT NULL,
  location_latitude DECIMAL(9,6) NOT NULL,
  location_longitude DECIMAL(9,6) NOT NULL,
  FOREIGN KEY (manager_id) REFERENCES Managers(manager_id)
);

-- Lock Table
CREATE TABLE Locks (
  lock_id INT IDENTITY (1, 1) PRIMARY KEY,
  station_id INT NOT NULL,
  user_id UNIQUEIDENTIFIER,
  FOREIGN KEY (station_id) REFERENCES Stations(station_id),
  FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Rental Table
CREATE TABLE Rentals (
  rental_id INT IDENTITY (1, 1) PRIMARY KEY,
  user_id UNIQUEIDENTIFIER NOT NULL,
  lock_id INT NOT NULL,
  hourly_rate DECIMAL(4,2) NOT NULL,
  rental_start_time DATETIME NOT NULL,
  rental_end_time DATETIME,
  FOREIGN KEY (user_id) REFERENCES Users(user_id),
  FOREIGN KEY (lock_id) REFERENCES Locks(lock_id)
);