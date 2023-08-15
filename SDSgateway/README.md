# BLE Lock Station Rental System

This program implements a BLE (Bluetooth Low Energy) lock station rental system using Python.
It integrates with a Flask web server to receive rental requests, verify the requests' authenticity, communicate with BLE-enabled locks, and perform actions such as locking and unlocking.
The program relies on the Bleak library for BLE communication.

## Features

- **Authentication**: Validates rental requests using HMAC-based message integrity and anti-replay mechanisms.
- **Communication**: Utilizes BLE communication to send and receive data between the server and BLE-enabled locks.
- **Lock Control**: Performs locking and unlocking actions on the BLE-enabled locks.
- **CSV Database**: Reads lock information from a CSV database file.

## Dependencies

- Python 3.x
- Bleak: BLE communication library
- Flask: Web server library
- pandas: Data manipulation library
- hmac, socket, struct, datetime: Python standard libraries

## Setup

1. Install the required dependencies using pip: `pip install bleak flask pandas`.
2. Create a CSV file named `locks.csv` with columns 'lock_id', 'lock_mac', and 'lock_secret' containing the lock information.
3. Replace the `URL` variable with your server's URL.
4. Run the program: `python app.py`.

## Usage

1. The Flask web server is set up to listen for incoming requests.
2. Upon receiving a request, the program validates the request's integrity, authenticity, and timing.
3. If the request is valid, the program communicates with the designated BLE lock:
   - Receives a challenge.
   - Sends a proof to be verified by the lock.
   - Sends the desired request.
   - Receives a response from the lock.
4. The program then responds to the incoming request based on the response received from the lock.

## Notes

- Ensure that your BLE locks are properly configured and reachable.
- Make sure the CSV file `locks.csv` contains accurate lock information.
- This program uses HMAC for message integrity and security.
- The Flask server runs on `localhost` at port 5000 with debug mode enabled.
- The Flask server is then published via an endpoint created by running `ngrok http https://localhost:5000`.

## Security Considerations

- Protect the CSV file containing lock secrets. Do not expose it publicly.
- Use HTTPS and proper server security measures to protect communication and data.
