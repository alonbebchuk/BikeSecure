#include <Arduino.h>
#include <SPI.h>
#if SOFTWARE_SERIAL_AVAILABLE
  #include <SoftwareSerial.h>
#endif

#include "Adafruit_BLE.h"
#include "Adafruit_BluefruitLE_SPI.h"


/* Create hardware SPI Bluefruit object */
Adafruit_BluefruitLE_SPI ble(8, 7, 4);

void broadcastState() {
  long stateCode;
  ble.readNVM(0, &stateCode);
  ble.print("AT+BLEUARTTXF="); ble.println(stateCode);
  ble.waitForOK();
}

void lockStation() {
  if (ble.sendCommandCheckOK("AT+HWModeLED=MANUAL,ON")) {
    ble.writeNVM(0, (long)1);
  }
  broadcastState();
}

void unlockStation() {
  if (ble.sendCommandCheckOK("AT+HWModeLED=MANUAL,OFF")) {
    ble.writeNVM(0, (long)0);
  }
  broadcastState();
}

void setup(void)
{
  delay(500);

  Serial.begin(115200);

  ble.begin(false);
  ble.factoryReset();

  while (!ble.isConnected()) {
      delay(500);
  }

  unlockStation();

  Serial.println(F("Started"));
}

void loop(void)
{
  char request;

  ble.println("AT+BLEUARTRX");
  ble.readline();
  ble.waitForOK();

  if (strlen(ble.buffer) == 1) {
    request = ble.buffer[0];
    switch(request) {
      case 'S':
        broadcastState();
        break;
      case 'L':
        lockStation();
        break;
      case 'U':
        unlockStation();
        break;
    }
  }
}