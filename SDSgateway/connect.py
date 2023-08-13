import asyncio
import hmac
from hashlib import sha512

from bleak import BleakClient
from bleak.backends.characteristic import BleakGATTCharacteristic

UART_SERVICE_UUID = "6E400001-B5A3-F393-E0A9-E50E24DCCA9E"
UART_RX_CHAR_UUID = "6E400002-B5A3-F393-E0A9-E50E24DCCA9E"
UART_TX_CHAR_UUID = "6E400003-B5A3-F393-E0A9-E50E24DCCA9E"




loop = asyncio.get_event_loop()
loop.run_until_complete(connect_send_verify_message())
