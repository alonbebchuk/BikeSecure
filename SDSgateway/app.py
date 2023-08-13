import asyncio
import hmac
from hashlib import sha512

from bleak import BleakClient
from bleak.backends.characteristic import BleakGATTCharacteristic
from flask import Flask, request

UART_SERVICE_UUID = "6E400001-B5A3-F393-E0A9-E50E24DCCA9E"
UART_RX_CHAR_UUID = "6E400002-B5A3-F393-E0A9-E50E24DCCA9E"
UART_TX_CHAR_UUID = "6E400003-B5A3-F393-E0A9-E50E24DCCA9E"

ADDRESS = "EA:75:4A:ED:BC:4F"
ACTIONS = ['start', 'end']

app = Flask(__name__)


@app.route('/')
async def rental_action():
    queue = asyncio.Queue()

    def handle_rx(_: BleakGATTCharacteristic, data: bytearray):
        queue.put_nowait(data.decode())

    async with BleakClient(ADDRESS) as client:
        await client.start_notify(UART_TX_CHAR_UUID, handle_rx)
        nus = client.services.get_service(UART_SERVICE_UUID)
        rx_char = nus.get_characteristic(UART_RX_CHAR_UUID)
        await client.write_gatt_char(rx_char, request.json['message'].encode())
        return await queue.get()


async def connect_send_verify_message(lock_secret, lock_mac):
    queue = asyncio.Queue()

    def handle_tx(_: BleakGATTCharacteristic, data: bytearray):
        queue.put_nowait(int(data))

    async with BleakClient(lock_mac) as client:
        nus = client.services.get_service(UART_SERVICE_UUID)
        tx_char = nus.get_characteristic(UART_TX_CHAR_UUID)
        rx_char = nus.get_characteristic(UART_RX_CHAR_UUID)
        await client.start_notify(tx_char, handle_tx)
        challenge = await queue.get()
        await client.stop_notify(tx_char)
        hmac_result = hmac.new(lock_secret, challenge.to_bytes(4, 'little'), sha512).digest()
        for i in range(0, len(hmac_result), 20):
            await client.write_gatt_char(rx_char, hmac_result[i:i + 20])
        return client


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True, ssl_context='adhoc')
