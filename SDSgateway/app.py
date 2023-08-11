import asyncio
from flask import Flask, request
from bleak import BleakClient
from bleak.backends.characteristic import BleakGATTCharacteristic

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


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True, ssl_context='adhoc')
