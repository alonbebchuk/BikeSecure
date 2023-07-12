#include<ESP8266WiFi.h>

// WiFi Definitions
const char* ssid = "lock_ssid";
const char* password = "lock_password";
const char* status = "";

const int ledPin = 0;
WiFiServer server(80);

void setup() {
   Serial.begin(115200);
   pinMode(ledPin, LOW);

   WiFi.mode(WIFI_AP);
   WiFi.softAP(ssid, password, 1, 0); // change to 1 in order for wi-fi to be hidden
  
   server.begin();
}

void loop() {
  // Check of client has connected
  WiFiClient client = server.available();
  if(!client) {
    return;
  }

  // Read the request line
  String request = client.readStringUntil('\r');
  Serial.println(request);
  client.flush();
  
  // Handle request
  String message = handleRequest(request);
  client.flush();
   
  // JSON response
  String s = "HTTP/1.1 200 OK\r\n";
  s += "Content-Type: application/json\r\n\r\n";
  s += "{\"data\":{\"message\":";
  s += message;
  s += "\"}}\r\n";
  s += "\n";

  // Send the response to the client
  client.print(s);
  delay(1);
  Serial.println("Client disconnected");

  // The client will actually be disconnected when the function returns and the client object is destroyed
}

String handleRequest(String request) {
  if(request.indexOf("/lock") != -1 && status != "locked") {
     pinMode(ledPin, HIGH);
     status = "locked";
  } else if (request.indexOf("/unlock") != -1 && status != "unlocked") {
     pinMode(ledPin, LOW);
     status = "unlocked";
  } else {
     return "invalid request";
  }

  return status;
}