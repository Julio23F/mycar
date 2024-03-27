#include <SoftwareSerial.h>

SoftwareSerial mySerial(10, 11); // TX, RX
String rec_data="off";


void setup() {
   pinMode(9, OUTPUT);
  Serial.begin(9600);
  mySerial.begin(9600);  
}

void loop() { 
  if (mySerial.available()) {
    
    rec_data=mySerial.readString();

    //Avance
    if(rec_data=="on"){
      digitalWrite(9, HIGH);
      }
    //Recule mais on peut stopper aussi
    if(rec_data=="off"){
      digitalWrite(9, LOW);
      }

    
    
    Serial.println(rec_data);
    delay(100);
  }
  
}
