# Lock Rental Database Schema

This SQL script creates a relational database schema for managing a lock rental system.
The schema includes tables for Stations, Locks, and Rentals, with appropriate relationships and attributes to store station and lock data, as well as rental information.

## Tables

### Stations

- `id`: Unique identifier for the station.
- `name`: Name of the station.
- `hourly_rate`: Hourly rental rate for the station.
- `latitude`: Latitude coordinates of the station.
- `longitude`: Longitude coordinates of the station.
- `url`: Secret URL for the station.
- `deleted`: Soft delete flag (0 for active, 1 for deleted).

### Locks

- `id`: Unique identifier for the lock.
- `station_id`: Foreign key referencing the station to which the lock belongs.
- `station_name`: Name of the station associated with the lock.
- `station_hourly_rate`: Hourly rental rate of the station associated with the lock.
- `latitude`: Latitude coordinates of the lock.
- `longitude`: Longitude coordinates of the lock.
- `url`: Secret URL for the station  to which the lock belongs.
- `name`: Name of the lock.
- `mac`: MAC address of the lock.
- `secret`: Binary data representing the secret key for the lock.
- `user_id`: User ID associated with the lock rental.
- `hourly_rate`: Hourly rate for the lock rental.
- `start_time`: Start time of the lock rental.
- `deleted`: Soft delete flag (0 for active, 1 for deleted).

### Rentals

- `id`: Unique identifier for the rental.
- `station_id`: Foreign key referencing the station from which the rental was made.
- `station_name`: Name of the station associated with the rental.
- `latitude`: Latitude coordinates of the station associated with the rental.
- `longitude`: Longitude coordinates of the station associated with the rental.
- `lock_id`: Foreign key referencing the lock used in the rental.
- `lock_name`: Name of the lock associated with the rental.
- `user_id`: User ID associated with the rental.
- `hourly_rate`: Hourly rental rate for the rental.
- `start_time`: Start time of the rental.
- `end_time`: End time of the rental.
- `duration_days`: Duration of the rental in days.
- `duration_hours`: Duration of the rental in hours.
- `cost`: Calculated cost of the rental.

# StartRental Stored Procedure

This SQL script defines a stored procedure named `StartRental`.
The procedure is designed to initiate a lock rental by updating the rental information for a specified lock and providing necessary secret data to server for carrying out the request.

## Procedure Parameters

- `@user_id`: NVARCHAR(MAX) - User ID associated with the rental.
- `@lock_id`: UNIQUEIDENTIFIER - Unique identifier of the lock to be rented.
- `@url`: NVARCHAR(MAX) OUTPUT - Secret URL associated with the station.
- `@mac`: NVARCHAR(MAX) OUTPUT - MAC address of the lock.
- `@secret`: BINARY(128) OUTPUT - Binary secret key for the lock.

## Procedure Logic

1. The procedure takes the user ID and lock ID as input parameters.
2. It sets the current datetime to `@now`.
3. The `Locks` table is updated with the following data:
   - `user_id` is set to the input `@user_id`.
   - `hourly_rate` is set to the corresponding `station_hourly_rate`.
   - `start_time` is set to `@now`.
4. The procedure then selects secret data from the `Locks` table based on the provided `@lock_id`:
   - `url` is selected as `@url`.
   - `mac` is selected as `@mac`.
   - `secret` is selected as `@secret`.

# EndRental Stored Procedure

This SQL script defines a stored procedure named `EndRental`.
The procedure is designed to conclude a lock rental, calculate the rental cost and duration, and provide necessary secret data to server for carrying out the request.

## Procedure Parameters

- `@user_id`: NVARCHAR(MAX) - User ID associated with the rental.
- `@lock_id`: UNIQUEIDENTIFIER - Unique identifier of the lock being rented.
- `@url`: NVARCHAR(MAX) OUTPUT - Secret URL associated with the station.
- `@mac`: NVARCHAR(MAX) OUTPUT - MAC address of the lock.
- `@secret`: BINARY(128) OUTPUT - Binary secret key for the lock.

## Procedure Logic

1. The procedure takes the user ID and lock ID as input parameters.
2. It sets the current datetime to `@now`.
3. A Common Table Expression (CTE) named `RentalHourDifference` calculates the difference in hours between the start time and the current time for the specified lock.
4. An `INSERT INTO` statement populates the `Rentals` table with the following data:
   - Station data including `station_id`, `station_name`, `latitude`, and `longitude`.
   - Lock data including `lock_id` and `lock_name`.
   - Rental data including `user_id`, `hourly_rate`, `start_time`, `end_time`, `duration_days`, and `duration_hours`.
5. The `Locks` table is then updated to reset the rental data for the specified lock.
6. If the lock has been marked as deleted, it is removed from the `Locks` table.
7. If a station has no locks associated with it, it is removed from the `Stations` table.
8. The procedure then selects secret data from the `Locks` table based on the provided `@lock_id`:
   - `url` is selected as `@url`.
   - `mac` is selected as `@mac`.
   - `secret` is selected as `@secret`.

### AddStationManager Stored Procedure

This SQL script defines a stored procedure named `AddStationManager`.
The procedure is designed to add a new station to the database, including its data and secret information.

**Procedure Parameters**

- `@name`: NVARCHAR(MAX) - Name of the station.
- `@hourly_rate`: DECIMAL(4,2) - Hourly rental rate for the station.
- `@latitude`: DECIMAL(9,6) - Latitude coordinates of the station.
- `@longitude`: DECIMAL(9,6) - Longitude coordinates of the station.
- `@url`: NVARCHAR(MAX) - Secret URL associated with the station.

**Procedure Logic**

1. The procedure takes station data as input parameters.
2. An `INSERT INTO` statement is used to add a new record to the `Stations` table with the provided data.

### DeleteStationManager Stored Procedure

This SQL script defines a stored procedure named `DeleteStationManager`.
The procedure is designed to delete a station from the database, along with its associated locks.
Stations and locks associated with active rentals are soft deleted.

**Procedure Parameters**

- `@station_id`: INT - Unique identifier of the station to be deleted.

**Procedure Logic**

1. The procedure takes the station ID as an input parameter.
2. It first deletes locks associated with the specified station where no active rentals are associated (`user_id` is NULL).
3. Locks with active rentals have their `deleted` flag set to 1.
4. If no locks are associated with active rentals, the station itself is deleted from the `Stations` table.
5. Otherwise, the station's `deleted` flag is set to 1.

### UpdateStationManager Stored Procedure

This SQL script defines a stored procedure named `UpdateStationManager`.
The procedure is designed to update the hourly rental rate of a station and its associated locks.

**Procedure Parameters**

- `@station_id`: INT - Unique identifier of the station to be updated.
- `@hourly_rate`: DECIMAL(4,2) - New hourly rental rate for the station.

**Procedure Logic**

1. The procedure takes the station ID and new hourly rate as input parameters.
2. It updates the `hourly_rate` field of the `Stations` table for the specified station.
3. The `station_hourly_rate` field of associated locks is also updated to the new hourly rate.
4. The new hourly rate takes effect for future rentals only (active rentals' hourly rate remains the same).

### AddLockManager Stored Procedure

This SQL script defines a stored procedure named `AddLockManager`.
The procedure is designed to add a new lock to the database, associated with a specific station.

**Procedure Parameters**

- `@station_id`: INT - Unique identifier of the station to which the lock will be associated.
- `@name`: NVARCHAR(MAX) - Name of the lock.
- `@mac`: NVARCHAR(MAX) - MAC address of the lock.

**Procedure Logic**

1. The procedure takes the station ID, lock name, and MAC address as input parameters.
2. An `INSERT INTO` statement is used to add a new lock record to the `Locks` table.

### DeleteLockManager Stored Procedure

This SQL script defines a stored procedure named `DeleteLockManager`.
The procedure is designed to delete a lock from the database, provided that the lock is not currently in use.

**Procedure Parameters**

- `@lock_id`: UNIQUEIDENTIFIER - Unique identifier of the lock to be deleted.

**Procedure Logic**

1. The procedure takes the lock ID as an input parameter.
2. It checks whether the lock is free (not currently associated with a user) using a `SELECT` statement.
3. If the lock is free, it is deleted from the `Locks` table.
4. If the lock is in use, its `deleted` flag is set to 1, indicating that it should be treated as deleted from now on.

### GetLockStatus Function

This SQL script defines a function named `GetLockStatus`.
The function is designed to retrieve the status of a lock based on its current usage and user association.

**Function Parameters**

- `@user_id`: NVARCHAR(MAX) - User identifier.
- `@lock_id`: UNIQUEIDENTIFIER - Unique identifier of the lock to check.

**Function Logic**

1. The function takes the user ID and lock ID as input parameters.
2. A `SELECT` statement is used to query the `Locks` table and determine the lock's status based on the provided user ID.
3. The function returns an integer value indicating the lock status:
    - `0`: The lock is available and not deleted.
    - `1`: The lock is associated with the provided user.
    - `-1`: The lock is either deleted or not available to the provided user.

## Additional SQL Functions (SELECT Queries)

In addition to the stored procedures and functions mentioned earlier, this SQL project also includes a set of SELECT queries designed to fetch data from the database.
These SELECT queries provide a way to retrieve specific information stored within the database tables.
These SELECT queries are used to gather various types of information, such as rental details, station information, lock statuses, and more.
The purpose of these queries is to enable data retrieval and reporting based on specific criteria and destination.
