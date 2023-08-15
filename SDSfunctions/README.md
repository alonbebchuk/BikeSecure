# # Lock Rental Azure Functions Serverless Server

## Overview

The purpose of this project is to serve as an intermediary between users and the database.
It handles user authentication, request validation, and communication with the database to ensure secure and controlled data access.

## Functionality

### Authentication and Authorization

The **Authentication Function** performs the following tasks:

- Validates user credentials.
- Grants authorized users access to specific functions.
- Ensures that only authenticated users can interact with the system.

### Request Validation

The **Request Validation Function** verifies:

- The correctness of incoming requests.
- The adherence of requests to predefined schemas or formats.
- Protection against potential malicious activities or invalid data.

### Data Access

The **Data Access Functions** are responsible for:

- Fetching specific information from the database based on user requests.
- Inserting new data into the database after performing necessary validations.
- Updating existing data in the database.
- Deleting data from the database, if authorized and valid.
