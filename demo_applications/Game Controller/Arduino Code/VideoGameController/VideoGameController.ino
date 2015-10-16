#include <CapacitiveSensor.h>

CapacitiveSensor   cs_2_3 = CapacitiveSensor(3, 2);
CapacitiveSensor   cs_4_5 = CapacitiveSensor(5, 4);
CapacitiveSensor   cs_6_7 = CapacitiveSensor(7, 6);
CapacitiveSensor   cs_8_9 = CapacitiveSensor(9, 8);
CapacitiveSensor   cs_10_11 = CapacitiveSensor(11, 10);
CapacitiveSensor   cs_12_13 = CapacitiveSensor(13, 12);

int previousButtonUpState = HIGH;   // for checking the state of a pushButton

void setup()
{
  cs_2_3.set_CS_AutocaL_Millis(0xFFFFFFFF);   // turn off autocalibrate on channel 1 - just as an example
  cs_4_5.set_CS_AutocaL_Millis(0xFFFFFFFF);
  cs_6_7.set_CS_AutocaL_Millis(0xFFFFFFFF);
  cs_8_9.set_CS_AutocaL_Millis(0xFFFFFFFF);   // turn off autocalibrate on channel 1 - just as an example
  cs_10_11.set_CS_AutocaL_Millis(0xFFFFFFFF);
  cs_12_13.set_CS_AutocaL_Millis(0xFFFFFFFF);
  Serial.begin(9600);
}


void loop() {
  // put your main code here, to run repeatedly:
  long start = millis();
  long total1 =  cs_2_3.capacitiveSensor(30);
  long total2 =  cs_4_5.capacitiveSensor(30);
  long total3 =  cs_6_7.capacitiveSensor(30);
  long total4 =  cs_8_9.capacitiveSensor(30);
  long total5 =  cs_10_11.capacitiveSensor(30);
  long total6 =  cs_12_13.capacitiveSensor(30);

Serial.println(total1);

  if ( (millis() % 100) != 0) {
    if (total1 > 5000)
      Serial.println('L');

    if (total2 > 5000)
      Serial.println('U');

    if (total3 > 5000)
      Serial.println('R');

    if (total4 > 5000)
      Serial.println('D');

    if (total5 > 5000)
      Serial.println('A');

    if (total6 > 5000)
      Serial.println('B');
  }
}

