class PID extends Thread implements InterfaceSerial {

  private float kP, kI, kD;
  private float P, I, D;
  private float newInput;
  private float output;
  private float outMin, outMax;
  private float setPoint;
  private float error, lastError;
  private long lastTime, interval;
  private Serial serial;

  // Constructor 1
  public PID() {
    setParameters(0.0, 0.0, 0.0);
    setSetPoint(0.0);
    setLimits(0.0, 100.0);
    setInterval(500);

    addSerial(null);
  }

  // Constructor 2
  public PID(float _kP, float _kI, float _kD) {
    setParameters(_kP, _kI, _kD);
    setSetPoint(0.0);
    setLimits(0.0, 100.0);
    setInterval(500);

    addSerial(null);
  }

  // Constructor 3
  public PID(float _kP, float _kI, float _kD, float _outMin, float _outMax) {
    setParameters(_kP, _kI, _kD);
    setSetPoint(0.0);
    setLimits(_outMin, _outMax);
    setInterval(500);

    addSerial(null);
  }

  // Method override of Thread
  public void run() {

    println("\nSTART PID!");

    while (true) {
      compute();

      sendSerial(getOutput());       

      try {
        sleep(10);
      }
      catch(Exception e) {
        println(e.getMessage());
      }
    }
  }

  public void setParameters(float _kP, float _kI, float _kD) {
    setKp(_kP);
    setKi(_kI);
    setKd(_kD);
  }

  public void setLimits(float _outMin, float _outMax) {
    this.outMin = _outMin;
    this.outMax = _outMax;
  }

  public void setInterval(long timeMillis) {
    this.interval = timeMillis;
  }

  public void addInput(float _newInput) {
    this.newInput = _newInput;
  }

  public float getInput() {
    return this.newInput;
  }

  public float compute() {

    if (millis() - lastTime >= interval) {

      //calculate error
      error = (setPoint - newInput);

      // Implementation of Proportional
      P = kP * error;

      // Implementation of Integral
      I += kI * error * (interval/1000.0f);
      I = constrain(I, outMin, outMax);

      // Implementation of Derivative
      D = kD * (error - lastError) / (interval/1000.0f);

      // Calculate output PID
      output = P + I + D;
      output = constrain(output, outMin, outMax);

      lastError = error;

      lastTime = millis();
    }

    return output;
  }

  public float getOutput() {
    return this.output;
  }

  public void setSetPoint(float _setPoint) {  
    this.setPoint = _setPoint;
  }

  public float getSetPoint() {  
    return this.setPoint;
  }

  public void setKp(float _kP) {  
    this.kP = _kP;
  }

  public float getKp() {  
    return this.kP;
  } 

  public void setKi(float _kI) {  
    this.kI = _kI;
  }

  public float getKi() {  
    return this.kI;
  }

  public void setKd(float _kD) {  
    this.kD = _kD;
  }

  public float getKd() {  
    return this.kD;
  }

  public float getError() {
    return this.error;
  }

  public void addSerial(Serial serial) {
    this.serial = serial;
  }

  public void sendSerial(float value) {
    String valSend = value + "\n";

    try{
      if (serial != null)
        serial.write(valSend);
    }catch(Exception e){
      println("!!! Error sending to serial !!!");
    }
    
  }
}

// *****************************************************************************

class AutoSetPoint extends Thread {

  private ArrayList<Float> setPoints;
  private int interval;
  private PID pid;
  private int count;
  private boolean isSuspended = false;
  private boolean started = false;

  public AutoSetPoint(PID pid) {
    this.pid = pid;
    setPoints = new ArrayList<Float>();
    setInterval(0);
    count = 0;
  } 

  public void run() {
    while (true) {

      try {   

        while (isSuspended)  sleep(100);

        if (setPoints.size() == 0) return;

        if (count >= setPoints.size()) count = 0;

        pid.setSetPoint(setPoints.get(count));

        count++;

        sleep(interval);
      }
      catch(Exception e) {
        println(e.getMessage());
      }
    }
  }

  public void start() {
    if (started == false) {
      if (this.interval != 0 && setPoints.size() > 1) {
        super.start();
        started = true;
      }
    } else {
      isSuspended(false);
    }
  }

  public void isSuspended(boolean value) {
    this.isSuspended = value;

    if (!value) count = 0;
  }

  public void addSetPoint(float setPoint) {
    setPoints.add(setPoint);
  }

  public void setInterval(int interval) {
    this.interval = interval;
  }

  public void removeAll() {
    setPoints.clear();
    count = 0;
  }
}