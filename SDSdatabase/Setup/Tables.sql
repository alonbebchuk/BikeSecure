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
  station_id INT PRIMARY KEY,
  manager_id UNIQUEIDENTIFIER NOT NULL,
  hourly_rate DECIMAL NOT NULL,
  location_latitude DECIMAL NOT NULL,
  location_longitude DECIMAL NOT NULL,
  FOREIGN KEY (manager_id) REFERENCES Managers(manager_id)
);

-- Lock Table
CREATE TABLE Locks (
  lock_id INT PRIMARY KEY,
  station_id INT NOT NULL,
  lock_key UNIQUEIDENTIFIER NOT NULL,
  user_id UNIQUEIDENTIFIER,
  FOREIGN KEY (station_id) REFERENCES Stations(station_id),
  FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Rental Table
CREATE TABLE Rentals (
  rental_id INT PRIMARY KEY,
  user_id UNIQUEIDENTIFIER NOT NULL,
  lock_id INT NOT NULL,
  hourly_rate DECIMAL NOT NULL,
  rental_start_time DATETIME NOT NULL,
  rental_end_time DATETIME,
  FOREIGN KEY (user_id) REFERENCES Users(user_id),
  FOREIGN KEY (lock_id) REFERENCES Locks(lock_id)
);