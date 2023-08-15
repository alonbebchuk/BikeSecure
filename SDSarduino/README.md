# BLE Authentication and Control System

This code implements a Bluetooth Low Energy (BLE) authentication and control system using an Adafruit Bluefruit LE SPI module.
The system verifies a HMAC-based challenge-response authentication and provides remote control of an LED through BLE communication.
The LED symbolizes an automatic lock where 'ON' symbolizes 'LOCKED' state and 'OFF' symbolizes 'UNLOCKED' state.

## Dependencies

This code relies on several libraries that need to be installed before compiling and running the program:

- **Adafruit_BLE**: Provides BLE communication functionality.
- **Adafruit_BluefruitLE_SPI**: Enables SPI communication with the Bluefruit LE module.
- **SPI**: Required for SPI communication.
- **Crypto**: Library for cryptographic functions.
- **SHA512**: SHA-512 hash algorithm implementation.
  
## Hardware Setup

- Connect the Adafruit Bluefruit LE SPI module to the Arduino using the defined SPI pins (`BLUEFRUIT_SPI_CS`, `BLUEFRUIT_SPI_IRQ`, `BLUEFRUIT_SPI_RST`).
- Connect an LED (with suitable resistor) to the desired digital pin for control (e.g., pin 13).

## Functionality

1. The system starts by initializing the BLE module and setting up the SPI communication.
2. It generates a random challenge and waits for a BLE connection.
3. Once connected, it sends the challenge to the connected device.
4. The connected device calculates a HMAC-based response using the shared secret key and sends it back to the Arduino.
5. The Arduino verifies the response against the expected response generated from the challenge and the secret key.
6. If the response is verified, the system enters a state where it can handle control requests.
7. The system can receive control requests to turn an LED on ('1') or off ('0'), respectively.
8. Responses are sent back to the connected device indicating success or failure.

## Authentication Mechanism

The authentication mechanism relies on a shared secret key.
The challenge-response process ensures that the device attempting to communicate with the Arduino possesses the correct secret key.

## Control Logic

The code includes logic to handle control requests via BLE communication.
Requests are made using the characters '0' (turn LED off) and '1' (turn LED on).
The Arduino responds with "Ok" for successful operations and "BadRequest" for invalid requests.

## Usage

1. Replace `SECRET_KEY` with the actual shared secret key.
1. Upload the code to the Arduino board.
2. Connect to the Arduino using a BLE-compatible device.
3. Once connected, the device can send authentication responses and control requests.
4. Follow the defined protocol for control requests ('0' to turn off - unlock, '1' to turn on - lock).
