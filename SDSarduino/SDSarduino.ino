#include <Adafruit_BLE.h>
#include <Adafruit_BluefruitLE_SPI.h>
#include <SPI.h>
#include <Crypto.h>
#include <SHA512.h>
#include <string.h>

# define BLUEFRUIT_SPI_CS 8
# define BLUEFRUIT_SPI_IRQ 7
# define BLUEFRUIT_SPI_RST -1
#define HASH_SIZE 64

Adafruit_BluefruitLE_SPI ble(BLUEFRUIT_SPI_CS, BLUEFRUIT_SPI_IRQ, BLUEFRUIT_SPI_RST);
SHA512 hash;

const uint8_t secretKey[] = {0x73 ,0x31 ,0xa4 ,0xf8 ,0x81 ,0x1c ,0x9c ,0xc0 ,0x44 ,0xa1 ,0x15 ,0x6e ,0xbd ,0x9c ,0x3e ,0xb3 ,0x31 ,0x23 ,0x5a ,0xe2 ,0xe1 ,0x35 ,0xab ,0x80 ,0x7c ,0x84 ,0x8f ,0xfe ,0x74 ,0x74 ,0x69 ,0x0 ,0x31 ,0x7e ,0x65 ,0x4 ,0x81 ,0x9a ,0x9d ,0xa ,0x15 ,0xb3 ,0x6 ,0x9d ,0x9e ,0xdd ,0x88 ,0x6b ,0x63 ,0x4d ,0x9a ,0xfd ,0xcd ,0x3d ,0x40 ,0x80 ,0xd6 ,0x92 ,0x46 ,0xd9 ,0xd4 ,0x84 ,0x6a ,0xc3 ,0x43 ,0xe2 ,0xeb ,0xb9 ,0xea ,0x2b ,0xaa ,0xa ,0x7b ,0x1f ,0x1b ,0x2b ,0x89 ,0x20 ,0x42 ,0x4a ,0xb4 ,0x17 ,0xec ,0x8e ,0x58 ,0x6e ,0x38 ,0x96 ,0x2e ,0xf0 ,0xc3 ,0x4c ,0x52 ,0x63 ,0xfc ,0x87 ,0x95 ,0x85 ,0x16 ,0x28 ,0x9b ,0x78 ,0xf6 ,0xc ,0x9d ,0x6c ,0x75 ,0x8c ,0x85 ,0x54 ,0xb5 ,0x42 ,0xc8 ,0xdd ,0x22 ,0x1e ,0x7b ,0x6a ,0xec ,0x5b ,0x22 ,0x32 ,0x6 ,0xaf ,0x36 ,0xb6 ,0xf3 ,0xc1};

void setup() {
  Serial.begin(115200);
  delay(1000);

  ble.begin();
  ble.factoryReset();
  ble.echo(false);

  ble.sendCommandCheckOK("AT+HWModeLED=MANUAL,OFF");
  ble.setMode(BLUEFRUIT_MODE_DATA);

  Serial.println("Started");
}

void loop() {
  while (!ble.isConnected()) {
    delay(500);
  }

  randomSeed(millis());
  uint32_t challenge = random(min(RANDOM_MAX, UINT32_MAX));
  Serial.println(challenge);

  while(!ble.available()) {
    ble.print(challenge);
    delay(1000);
  }

  delay(1000);

  uint8_t response[HASH_SIZE];
  ble.readBLEUart(response, HASH_SIZE);
  if (!verifyHMAC(challenge, response)) {
    Serial.println("Verification Failed");
    while(1);
  } else {
    Serial.println("Verification Succeeded");
  }

  delay(1000);

  char req = ble.read();
  if (req == '0' && ble.sendCommandCheckOK("AT+HWModeLED=MANUAL,OFF")) {
    ble.print(0);
  } else if (req == '1' && ble.sendCommandCheckOK("AT+HWModeLED=MANUAL,ON")) {
    ble.print(0);
  } else {
    ble.print(-1);
  }
}

bool verifyHMAC(uint32_t challenge, const uint8_t* response) {
  uint8_t expectedResponse[HASH_SIZE];

  hash.resetHMAC(secretKey, sizeof(secretKey));
  hash.update((const uint8_t*)&challenge, sizeof(challenge));
  hash.finalizeHMAC(secretKey, sizeof(secretKey), expectedResponse, HASH_SIZE);
  
  for (int i = 0; i < HASH_SIZE; i++) {
    if (response[i] != expectedResponse[i]) {
      return false;
    }
  }

  return true;
}
