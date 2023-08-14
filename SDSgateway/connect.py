import asyncio
import csv
import hmac
import socket
import struct
import sys
import time
from datetime import datetime, timezone
from hashlib import sha512

import pandas as pd

socket.setdefaulttimeout(10)

from bleak import BleakClient
from flask import Flask, request

UART_SERVICE_UUID = "6E400001-B5A3-F393-E0A9-E50E24DCCA9E"
UART_RX_CHAR_UUID = "6E400002-B5A3-F393-E0A9-E50E24DCCA9E"
UART_TX_CHAR_UUID = "6E400003-B5A3-F393-E0A9-E50E24DCCA9E"
UART_CHUNK_SIZE = 20

FILENAME = "locks.csv"
URL = "https://57f1-2a10-8012-f-2fc6-748c-c7f9-e7b2-f853.ngrok-free.app"

app = Flask(__name__)
locks = {}


async def rental_action(req):
    lock = locks['29e351e1-609f-43b6-96d4-631af7458f27']
    await send_request(req, lock['mac'], lock['secret'])


async def send_request(req, mac, secret):
    queue = asyncio.Queue()
    async with BleakClient(mac) as client:
        uart_serv = client.services.get_service(UART_SERVICE_UUID)
        tx_char = uart_serv.get_characteristic(UART_TX_CHAR_UUID)
        rx_char = uart_serv.get_characteristic(UART_RX_CHAR_UUID)

        # subscribe to notifications
        await client.start_notify(tx_char, lambda _, data: queue.put_nowait(int(data)))

        # receive challenge
        challenge = await queue.get()

        # send proof
        proof = hmac.new(secret, struct.pack('<I', challenge), sha512).digest()
        for i in range(0, len(proof), UART_CHUNK_SIZE):
            await client.write_gatt_char(rx_char, proof[i:i + UART_CHUNK_SIZE])

        # send request
        await client.write_gatt_char(rx_char, req.encode())

        # receive response
        response = await queue.get()

        # disconnect
        await client.stop_notify(tx_char)
        await client.disconnect()

    return response


if __name__ == '__main__':
    with open(FILENAME, 'r') as f:
        reader = csv.DictReader(f)
        for row in reader:
            lock_id, lock_mac, lock_secret = row['lock_id'], row['lock_mac'], row['lock_secret']
            lock_secret = bytes.fromhex(lock_secret[2:])
            locks[lock_id] = {'mac': lock_mac, 'secret': lock_secret}

    asyncio.run(rental_action('O'))

    time.sleep(10000)

    asyncio.run(rental_action('1'))
    # app.run(host='127.0.0.1', port=5000, debug=True, ssl_context='adhoc')
