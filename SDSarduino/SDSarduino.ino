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

const uint8_t secretKey[] = {0x30 ,0x78 ,0x33 ,0x30 ,0x37 ,0x38 ,0x33 ,0x37 ,0x33 ,0x33 ,0x33 ,0x33 ,0x33 ,0x31 ,0x34 ,0x31 ,0x33 ,0x34 ,0x34 ,0x36 ,0x33 ,0x38 ,0x33 ,0x38 ,0x33 ,0x31 ,0x33 ,0x31 ,0x34 ,0x33 ,0x33 ,0x39 ,0x34 ,0x33 ,0x34 ,0x33 ,0x33 ,0x30 ,0x33 ,0x34 ,0x33 ,0x34 ,0x34 ,0x31 ,0x33 ,0x31 ,0x33 ,0x31 ,0x33 ,0x35 ,0x33 ,0x36 ,0x34 ,0x35 ,0x34 ,0x32 ,0x34 ,0x34 ,0x33 ,0x39 ,0x34 ,0x33 ,0x33 ,0x33 ,0x34 ,0x35 ,0x34 ,0x32 ,0x33 ,0x33 ,0x33 ,0x33 ,0x33 ,0x31 ,0x33 ,0x32 ,0x33 ,0x33 ,0x33 ,0x35 ,0x34 ,0x31 ,0x34 ,0x35 ,0x33 ,0x32 ,0x34 ,0x35 ,0x33 ,0x31 ,0x33 ,0x33 ,0x33 ,0x35 ,0x34 ,0x31 ,0x34 ,0x32 ,0x33 ,0x38 ,0x33 ,0x30 ,0x33 ,0x37 ,0x34 ,0x33 ,0x33 ,0x38 ,0x33 ,0x34 ,0x33 ,0x38 ,0x34 ,0x36 ,0x34 ,0x36 ,0x34 ,0x35 ,0x33 ,0x37 ,0x33 ,0x34 ,0x33 ,0x37 ,0x33 ,0x34 ,0x33 ,0x36 ,0x41};

uint32_t challenge;
uint8_t proof[HASH_SIZE];
uint8_t expectedProof[HASH_SIZE];
char req;

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
  challenge = random(min(RANDOM_MAX, UINT32_MAX));
  Serial.println(challenge);

  while(!ble.available()) {
    ble.print(challenge);
    delay(1000);
  }

  delay(1000);

  ble.readBLEUart(proof, HASH_SIZE);
  if (verifyHMAC(challenge, proof)) {
    Serial.println("Verified");

    delay(1000);

    handleRequest();
  }

  delay(1000);

  ble.disconnect();
}

bool verifyHMAC(uint32_t challenge, const uint8_t* proof) {
  hash.resetHMAC(secretKey, sizeof(secretKey));
  hash.update((const uint8_t*)&challenge, sizeof(challenge));
  hash.finalizeHMAC(secretKey, sizeof(secretKey), expectedProof, HASH_SIZE);
  
  for (int i = 0; i < HASH_SIZE; i++) {
    if (proof[i] != expectedProof[i]) {
      return false;
    }
  }

  return true;
}

void handleRequest() {
  req = ble.read();

  if (req == '0' && ble.sendCommandCheckOK("AT+HWModeLED=MANUAL,OFF")) {
    Serial.println("Ok");
    ble.print(0);
  } else if (req == '1' && ble.sendCommandCheckOK("AT+HWModeLED=MANUAL,ON")) {
    Serial.println("Ok");
    ble.print(0);
  } else {
    Serial.println("BadRequest");
    ble.print(-1);
  }
}
