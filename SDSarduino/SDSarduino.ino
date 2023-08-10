#include <Arduino.h>
#include <SPI.h>
#include <SoftwareSerial.h>
#include "Adafruit_BLE.h"
#include "Adafruit_BluefruitLE_SPI.h"
#include "Adafruit_BluefruitLE_UART.h"

#define BLUEFRUIT_SPI_CS            8
#define BLUEFRUIT_SPI_IRQ           7
#define BLUEFRUIT_SPI_RST          -1

Adafruit_BluefruitLE_SPI ble(BLUEFRUIT_SPI_CS, BLUEFRUIT_SPI_IRQ, BLUEFRUIT_SPI_RST);

#define BUFSIZE                     512
#define VERBOSE_MODE                false

void setup(void)
{
  while (!Serial);
  delay(500);

  Serial.begin(115200);

  ble.begin(VERBOSE_MODE);
  ble.factoryReset();
  ble.echo(false);

  while (!ble.isConnected()) {
      delay(500);
  }

  ble.sendCommandCheckOK("AT+HWModeLED=MANUAL,OFF");
  ble.setMode(BLUEFRUIT_MODE_DATA);

  Serial.println("Started");
}

void loop(void)
{
  while (ble.available())
  {
    ble.readline();
    ble.waitForOK();
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
