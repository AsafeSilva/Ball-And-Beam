#include <Servo.h>

#define PIN_SERVO 12

#define MIN 544
#define MID 1180
#define MAX 1800

Servo servo;

int pidInput;

void setup() {

  servo.attach(PIN_SERVO);

  Serial.begin(9600);
  while (!Serial);
}


void loop() {
}


String outputPID = "";
void serialEvent(){
    
  char input = (char) Serial.read();

  if(input == '\n'){
    pidInput = outputPID.toInt();

    pidInput = map(pidInput, -700, 700, 700, -700);

    int out = constrain(MID + pidInput, MIN, MAX);

    servo.writeMicroseconds(out);

    outputPID = "";
  }else{
    outputPID += input;
  }

}

// ------- STEP MOTOR AND TIMER ------- //

// #include <TimerOne.h>

// #define PIN_DIR    5
// #define PIN_ENABLE 3
// #define PIN_CLOCK  4

// #define RIGHT LOW
// #define LEFT  HIGH

// // #define DEBUG
// #define LOG Serial.print
// #define LOGn Serial.println

// /*
// MS1   MS2   MS3   Resolution
// LOW   LOW   LOW   Full Step
// HIGH  LOW   LOW   Half Step
// LOW   HIGH  LOW   1/4  Step
// HIGH  HIGH  LOW   1/8  Step
// HIGH  HIGH  HIGH  1/16 Step
// */

// #define stepLimitMax 110
// #define stepLimitMin 5

// #define freqMAX 5000
// #define freqMIN 20000

// int rawPidInput = 0;
// bool direction ;
// int stepCounter = 0;
// bool enabled = false;


// void setup() {

//   pinMode (PIN_DIR, OUTPUT);
//   pinMode (PIN_CLOCK, OUTPUT);
//   pinMode (PIN_ENABLE, OUTPUT); digitalWrite(PIN_ENABLE, HIGH);

//   pinMode(14, OUTPUT);  digitalWrite(14, LOW);
//   pinMode(18, OUTPUT);  digitalWrite(18, HIGH);

//   Timer1.initialize();
//   Timer1.attachInterrupt(clock);

//   Serial.begin(9600);
//   while (!Serial);
// }


// void loop() {

// #ifdef DEBUG
//   LOG("Input: "); LOG(rawPidInput);
//   LOG("\tOutput: "); LOG(map(abs(rawPidInput), 0, 1500, freqMIN, freqMAX));
//   LOG("\tCount: "); LOG(stepCounter);
//   LOG("\tEnable?: "); LOG(enabled ? "YES" : "NOT");
//   LOGn();
// #endif

//   // rawPidInput = map (analogRead(A2), 0, 1023, -1500, 1500);
//   // Timer1.setPeriod( map(abs(rawPidInput), 0, 1500, freqMIN, freqMAX) );

//   direction = rawPidInput < 0 ? RIGHT : LEFT;
//   digitalWrite(PIN_DIR, direction);


//   if ( rawPidInput > -3 && rawPidInput < 3) enabled = false;
//   else                                      enabled = true;

//   if ((stepCounter > stepLimitMax) || (stepCounter < stepLimitMin)) {
    
//     enabled = false;

//     if(stepCounter > stepLimitMax){
//       if(direction == LEFT) enabled = true;
//     }else if(stepCounter < stepLimitMin){
//       if(direction == RIGHT) enabled = true;
//     }

//   }

// }

// void clock() {

//   if(enabled){

//     digitalWrite(PIN_CLOCK, !digitalRead(PIN_CLOCK));

//     if(digitalRead(PIN_CLOCK))
//       stepCounter = direction == RIGHT ? stepCounter+1 : stepCounter-1;
//   }
// }

// String outputPID = "";
// void serialEvent(){
    
//   char input = (char) Serial.read();

//   if(input == '\n'){
//     rawPidInput = outputPID.toInt();

//     Timer1.setPeriod( map(abs(rawPidInput), 0, 1500, freqMIN, freqMAX) );

//     outputPID = "";
//   }else{
//     outputPID += input;
//   }

// }




// ------- STEP MOTOR AND THREAD ------- //

// #include <Thread.h>

// #define PIN_DIR    5
// #define PIN_ENABLE 3
// #define PIN_CLOCK    4

// #define RIGHT LOW
// #define LEFT  HIGH

// #define DEBUG
// #define LOG Serial.print
// #define LOGn Serial.println

// /*
// MS1   MS2   MS3   Resolution
// LOW   LOW   LOW   Full Step
// HIGH  LOW   LOW   Half Step
// LOW   HIGH  LOW   1/4  Step
// HIGH  HIGH  LOW   1/8  Step
// HIGH  HIGH  HIGH  1/16 Step
// */

// #define stepLimitMax 110
// #define stepLimitMin 5

// int rawPidInput = 0;
// bool direction ;
// int stepCounter = 0;
// bool enable;

// Thread threadClock = Thread();


// void setup() {

//   pinMode (PIN_DIR, OUTPUT);
//   pinMode (PIN_CLOCK, OUTPUT);
//   pinMode (PIN_ENABLE, OUTPUT); digitalWrite(PIN_ENABLE, HIGH);

//   pinMode(14, OUTPUT);  digitalWrite(14, LOW);
//   pinMode(18, OUTPUT);  digitalWrite(18, HIGH);

//   threadClock.onRun(clock);

//   Serial.begin(9600);
//   while (!Serial);
// }


// void loop() {

// #ifdef DEBUG
//   LOG("Input: "); LOG(rawPidInput);
//   LOG("\tOutput: "); LOG(map(abs(rawPidInput), 0, 30, 30, 1));
//   LOG("\tCount: "); LOG(stepCounter);
//   LOG("\tEnable?: "); LOG(threadClock.enabled ? "YES" : "NOT");
//   LOGn();
// #endif

//   rawPidInput = map (analogRead(A2), 0, 1023, -30, 30);
//   threadClock.setInterval(map(abs(rawPidInput), 0, 30, 30, 1));

//   direction = rawPidInput > 0 ? RIGHT : LEFT;
//   digitalWrite(PIN_DIR, direction);


//   if ( rawPidInput > -3 && rawPidInput < 3) threadClock.enabled = false;
//   else                                      threadClock.enabled = true;

//   if ((stepCounter > stepLimitMax) || (stepCounter < stepLimitMin)) {
    
//     threadClock.enabled = false;

//     if(stepCounter > stepLimitMax){
//       if(direction == LEFT) threadClock.enabled = true;
//     }else if(stepCounter < stepLimitMin){
//       if(direction == RIGHT) threadClock.enabled = true;
//     }

//   }
  
//   if (threadClock.shouldRun()) threadClock.run();

// }


// void clock() {

//   digitalWrite(PIN_CLOCK, !digitalRead(PIN_CLOCK));

//   if(digitalRead(PIN_CLOCK))
//     stepCounter = direction == RIGHT ? stepCounter+1 : stepCounter-1;
  
// }