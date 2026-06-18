#include <WiFi.h>
#include <HTTPClient.h>
#include <OneWire.h>
#include <DallasTemperature.h>
#include <ESP32Servo.h>

// Στοιχεία WiFi & Firebase
const char* ssid = "Wokwi-GUEST";
const char* password = "";
const String databaseURL = "https://aquarium-web-default-rtdb.firebaseio.com/";

OneWire oneWire(4); 
DallasTemperature sensors(&oneWire);
Servo feederServo;

void setup() {
  Serial.begin(115200);
  sensors.begin();
  feederServo.attach(18);
  feederServo.write(0);

  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) { delay(500); Serial.print("."); }
  Serial.println("\nConnected to WiFi");
}

void loop() {
  // 1. Διάβασμα Θερμοκρασίας (Πρώτα από όλα)
  sensors.requestTemperatures();
  float temp = sensors.getTempCByIndex(0);
  
  if (temp != DEVICE_DISCONNECTED_C) {
    HTTPClient http;
    http.setTimeout(1000); // Μικρό timeout για να μην κολλάει
    http.begin(databaseURL + "status.json");
    String jsonData = "{\"temperature\":" + String(temp) + "}";
    int httpResponseCode = http.PATCH(jsonData);
    Serial.print("Temp Sent! Code: "); Serial.println(httpResponseCode);
    http.end();
  }

  // 2. Γρήγορος έλεγχος για Τάισμα
  HTTPClient httpGet;
  httpGet.setTimeout(1000); 
  httpGet.begin(databaseURL + "controls/feed_now.json");
  int httpCode = httpGet.GET();
  
  if (httpCode > 0) {
    String payload = httpGet.getString();
    if (payload == "true") {
      Serial.println("!!! FEEDING NOW !!!");
      feederServo.write(90); 
      delay(1500); 
      feederServo.write(0);
      
      // Άμεσο reset στη βάση
      HTTPClient httpReset;
      httpReset.begin(databaseURL + "controls.json");
      httpReset.PATCH("{\"feed_now\":false}");
      httpReset.end();
    }
  }
  httpGet.end();

  // Μείωσε το delay στο τέλος για πιο γρήγορη απόκριση
  delay(2000); 
}