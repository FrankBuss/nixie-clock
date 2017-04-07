#include "SPI.h"

// pin numbers
const int csPin = 8;

const float samplerate = 200.0f;

// format: off1Time, onTime, off2Time, for 10 PWM outputs
uint32_t pwmValues[30];

// 256 values fading table
uint16_t fadingLookupTable[256];

void initFadingTable()
{
  // formula from https://www.mikrocontroller.net/articles/LED-Fading
  // a = number of steps (4, 8, 16 ...)
  // b = PWM resolution (256, 1024 ...)
  float a = 256.0f;
  float b = 8192.0f;
  float log2 = log(2);
  for (int x = 0; x < 256; x++) {
    float y;
    if (x == 0) {
      y = 0.0f;
    } else {
      y = pow(2, log(b - 1) / log2 * (float(x) + 1) / a);
    }
    fadingLookupTable[x] = y;
  }
}

void sendWord(uint32_t w)
{
  SPI.transfer((w >> 24) & 0xff);
  SPI.transfer((w >> 16) & 0xff);
  SPI.transfer((w >> 8) & 0xff);
  SPI.transfer(w & 0xff);
}

void sendPwm()
{
  digitalWrite(csPin, LOW);
  for (int i = 0; i < 30; i++) {
    sendWord(pwmValues[29 - i]);
  }
  digitalWrite(csPin, HIGH);
}

void setup()
{
  initFadingTable();
  for (int i = 0; i < 30; i++) pwmValues[i] = 0;
  
  // init pins
  pinMode(9, OUTPUT);
  pinMode(csPin, OUTPUT);
  digitalWrite(csPin, HIGH);

  // init SPI
  SPI.beginTransaction(SPISettings(1000000, MSBFIRST, SPI_MODE0));
  SPI.begin();  // additional begin is required, otherwise the second call to SPI.transfer hangs

  // initialize timer1
  noInterrupts(); // disable all interrupts
  TCCR1A = 0;
  TCCR1B = 0;
  TCNT1 = 0;
  OCR1A = 15625.0f / samplerate; // compare match register for IRQ with selected samplerate
  TCCR1B |= (1 << WGM12); // CTC mode
  TCCR1B |= (1 << CS10) | (1 << CS12); // prescaler 1024
  TIMSK1 |= (1 << OCIE1A); // enable timer compare interrupt
  interrupts(); // enable all interrupts
}

uint32_t b = 0;
uint32_t b2 = 0;

int state = 0;

// timer 1 interrupt
ISR(TIMER1_COMPA_vect)
{
  uint16_t v = 0;
  uint16_t v2 = 0;
  switch (state) {
    // first digit fast on
    case 0:
      v = fadingLookupTable[b];
      b += 2;
      if (b == 256) {
        b = 0;
        state = 1;
      }
      pwmValues[1] = v;
      pwmValues[2] = 8192 - v;
      break;

    // pause
    case 1:
      b++;
      if (b == 300) {
        b = 0;
        b2 = 0;
        state = 2;
      }
      break;

    // second digit fast on, and first digit slow off
    case 2:
      v = fadingLookupTable[b];
      v2 = fadingLookupTable[255 - b2];
      b += 2;
      b2++;
      if (b > 255) {
        b = 255;
      }
      if (b2 == 256) {
        b = 0;
        state = 3;
      }
      pwmValues[1] = v2;
      pwmValues[2] = 8192 - v2;
      pwmValues[4] = v;
      pwmValues[5] = 8192 - v;
      break;

    // pause
    case 3:
      b++;
      if (b == 300) {
        b = 0;
        b2 = 0;
        state = 4;
      }
      break;

    // first digit fast on, and second digit slow off
    case 4:
      v2 = fadingLookupTable[b];
      v = fadingLookupTable[255 - b2];
      b += 2;
      b2++;
      if (b > 255) {
        b = 255;
      }
      if (b2 == 256) {
        b = 0;
        state = 1;
      }
      pwmValues[1] = v2;
      pwmValues[2] = 8192 - v2;
      pwmValues[4] = v;
      pwmValues[5] = 8192 - v;
      break;

  }
  sendPwm();
}

// just blink the Arduino LED with 1 Hz to see if it is still alive. The rest is done in the interrupt
void loop()
{
  digitalWrite(9, HIGH);
  delay(500);
  digitalWrite(9, LOW);
  delay(500);
}

