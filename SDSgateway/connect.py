import asyncio
import csv
import hmac
import struct
from hashlib import sha512
from operator import itemgetter

from bleak import BleakClient

UART_SERVICE_UUID = "6E400001-B5A3-F393-E0A9-E50E24DCCA9E"
UART_RX_CHAR_UUID = "6E400002-B5A3-F393-E0A9-E50E24DCCA9E"
UART_TX_CHAR_UUID = "6E400003-B5A3-F393-E0A9-E50E24DCCA9E"
UART_CHUNK_SIZE = 20

FILENAME = "locks.csv"

locks = {}


async def send_request(lock, req):
    queue = asyncio.Queue()

    secret, mac = itemgetter('secret', 'mac')(lock)
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
            lock_id = int(row['lock_id'])
            lock_secret = bytes.fromhex(row['lock_secret'][2:])
            lock_mac = row['lock_mac']
            locks[lock_id] = {'secret': lock_secret, 'mac': lock_mac}

    asyncio.run(send_request(locks[lock_id], '1'))

    asyncio.run(send_request(locks[lock_id], '0'))