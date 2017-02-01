import processing.video.*;
import processing.serial.*;
import javax.swing.*;
import controlP5.*;
import java.text.DecimalFormat;

Serial serialPort = null;        

Capture camera;                  
ControlP5 views;

ColorTracker tracker;

PID pid;

AutoSetPoint autoSP;

Knob knobKP, knobKI, knobKD;
Textfield maxKP, maxKI, maxKD;
Textlabel txtError, txtOutput;
Textlabel txtConfig;
Chart chartInput, chartOutput;
Toggle btnConfig;
Button btnConnect, btnStart;

Textfield intervalSP;
Toggle addSP, startAutoSP;
Button clearSP;


Line lineSetPoint;
DecimalFormat dec;

void setup() {
  size(1280, 640);
  background(20);
  smooth();

  dec = new DecimalFormat("0.00");

  if (!initCamera()) exit();     // Function contained in Camera.pde
  initViews();                  // Function contained in Views.pde

  try {
    tracker = new ColorTracker(width/2, height*3/5, camera.width, camera.height);
  }
  catch(Exception e) {
    println("Error in ColorTracker: " + e.getMessage());
  }

  pid = new PID();
  autoSP = new AutoSetPoint(pid);

  lineSetPoint = new Line(this, pid);  // Class contained in Views.pde

  // Setup PID
  pid.setInterval(90);
  pid.setLimits(-700, 700);

  chartOutput.setRange(-700, 700);  // Set range according to PID limits

  println("\nSTART BALANCING BALL!\n");
}

void draw() {
  background(20);

  drawRectangles();  // Function contained in Views.pde

  drawCamera();  // Function contained in Camera.pde

  colorTracker();  // Function contained in Camera.pde
  pid.addInput(tracker.getX());  // Add new input the PID controller

  lineSetPoint.drawLine();  // Draws Setpoint line

  // Update Texts
  txtError.setText("Error: " + dec.format(pid.getError()));
  txtOutput.setText("Output: " + dec.format(pid.getOutput()));

  // Update graphics
  chartInput.push("input", pid.getInput());
  chartInput.push("setPoint", pid.getSetPoint());
  chartOutput.push("output", pid.getOutput());
}

// This event function is run when a click event happens
void controlEvent(ControlEvent event) {
  if (event.isAssignableFrom(Textfield.class)) {

    if (event.getController().equals(maxKP))       knobKP.setRange(0, Float.parseFloat(event.getStringValue()));
    else if (event.getController().equals(maxKI))  knobKI.setRange(0, Float.parseFloat(event.getStringValue()));
    else if (event.getController().equals(maxKD))  knobKD.setRange(0, Float.parseFloat(event.getStringValue()));
  } else if (event.isAssignableFrom(Toggle.class)) {

    if (event.getController().equals(btnConfig)) txtConfig.setVisible(true);
    else if (event.getController().equals(startAutoSP)) {
      if (startAutoSP.getState()) {
        autoSP.setInterval(int(intervalSP.getText()));

        autoSP.start();

        addSP.setLock(true);
        clearSP.setLock(true);
        intervalSP.setLock(true);
      } else {
        autoSP.isSuspended(true);

        addSP.setLock(false);
        clearSP.setLock(false);
        intervalSP.setLock(false);
      }
    }
  } else if (event.isAssignableFrom(Button.class)) {

    if (event.getController().equals(btnConnect))   selectSerialPort();
    else if (event.getController().equals(btnStart)) pid.start();
    else if (event.getController().equals(clearSP)){
      autoSP.removeAll();
      startAutoSP.setLock(true);
    }
  } else if (event.isAssignableFrom(Knob.class)) {

    if (event.getController().equals(knobKP))      pid.setKp(knobKP.getValue());
    else if (event.getController().equals(knobKI)) pid.setKi(knobKI.getValue());
    else if (event.getController().equals(knobKD)) pid.setKd(knobKD.getValue());
  }
}

void mouseClicked() {

  if (cameraClicked()) {

    if (btnConfig.getState()) {
      tracker.setTrackingColor(get(mouseX, mouseY));
      btnConfig.setState(false);
      txtConfig.setVisible(false);
      tracker.setEnableAnalyze(true);
    } else {
      pid.setSetPoint(mouseX);
    }

    if (addSP.getState()) {
      autoSP.addSetPoint(mouseX);
      addSP.setState(false);
      
      startAutoSP.setLock(false);
      clearSP.setLock(false);
    }
  }
}

void mouseDragged() {
  if (cameraClicked() && !btnConfig.getState()) {
    pid.setSetPoint(mouseX);
  }
}