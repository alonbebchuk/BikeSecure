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

const uint8_t secretKey[] = {0x01, 0x23, 0x45, 0x67, 0x89, 0xAB, 0xCD, 0xEF};
uint32_t challenge = 0;

bool connected = false;

void setup() {
  Serial.begin(115200);
  delay(1000);

  ble.begin();
  ble.factoryReset();
  ble.echo(false);

  while (!ble.isConnected()) {
    delay(500);
  }

  ble.sendCommandCheckOK("AT+HWModeLED=MANUAL,OFF");
  ble.setMode(BLUEFRUIT_MODE_DATA);

  Serial.println("Started");

  randomSeed(analogRead(A0));
  challenge = random(min(RANDOM_MAX, UINT32_MAX));
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
}

void loop() {
  while (ble.available())
  {
    ble.readline();
    Serial.println(ble.buffer);

    if (strcmp(ble.buffer, "Lock") == 0 && ble.sendCommandCheckOK("AT+HWModeLED=MANUAL,ON")) {
      ble.print("Success");
    } else if (strcmp(ble.buffer, "Unlock") == 0 && ble.sendCommandCheckOK("AT+HWModeLED=MANUAL,OFF")) {
      ble.print("Success");
    } else {
      ble.print("Failure");
    }
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
