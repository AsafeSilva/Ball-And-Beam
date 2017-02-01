void initViews() {
  views = new ControlP5(this);

  initCharts();

  // =======================================   
  knobKP = views.addKnob("KP")
    .setFont(createFont("arial", 12))
    .setPosition((width/4 - 50) - 150, height*3/5 + 50)
    .setRadius(50);

  knobKP.getCaptionLabel().align(ControlP5.CENTER, ControlP5.TOP_OUTSIDE); 

  maxKP = views.addTextfield("MAX - kP")
    .setFont(createFont("arial", 10))
    .setPosition((width/4 - 15) - 150, height*3/5 + 160)
    .setSize(30, 20)
    .setAutoClear(false);  

  maxKP.getCaptionLabel().align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE).setPaddingX(3);              
  // ***************************************

  // =======================================      
  knobKI = views.addKnob("KI")
    .setFont(createFont("arial", 12))
    .setPosition(width/4 - 50, height*3/5 + 50)
    .setRadius(50);

  knobKI.getCaptionLabel().align(ControlP5.CENTER, ControlP5.TOP_OUTSIDE); 

  maxKI = views.addTextfield("MAX - KI")
    .setFont(createFont("arial", 10))
    .setPosition(width/4 - 15, height*3/5 + 160)
    .setSize(30, 20)
    .setAutoClear(false);  

  maxKI.getCaptionLabel().align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE).setPaddingX(3);
  // ***************************************


  // =======================================     
  knobKD = views.addKnob("KD")
    .setFont(createFont("arial", 12))
    .setPosition((width/4 - 50) + 150, height*3/5 + 50)
    .setRadius(50);

  knobKD.getCaptionLabel().align(ControlP5.CENTER, ControlP5.TOP_OUTSIDE); 

  maxKD = views.addTextfield("MAX - KD")
    .setFont(createFont("arial", 10))
    .setPosition((width/4 - 15) + 150, height*3/5 + 160)
    .setSize(30, 20)
    .setAutoClear(false);  

  maxKD.getCaptionLabel().align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE).setPaddingX(3);
  // ***************************************

  // ======================================= 
  txtError = views.addTextlabel("error")
    .setText("Error: 10")
    .setPosition(30, height - 45)
    .setFont(createFont("arial", 30));
  // ***************************************

  // ======================================= 
  txtOutput = views.addTextlabel("output")
    .setText("Output: 200")
    .setPosition(400, height - 45)
    .setFont(createFont("arial", 30));
  // ***************************************

  // ======================================= 
  btnConfig = views.addToggle("config")
    .setFont(createFont("arial", 12))
    .setLabel("Setup Ball")
    .setPosition(width/4 - 280, height/2)
    .setSize(150, 30);
  btnConfig.getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
  // ***************************************

  // ======================================= 
  btnConnect = views.addButton("connect")
    .setFont(createFont("arial", 12))
    .setLabel("Connect to Arduino")
    .setPosition(width/4 - 150/2, height/2)
    .setSize(150, 30);
  // ***************************************

  // ======================================= 
  btnStart = views.addButton("start")
    .setFont(createFont("arial", 12))
    .setLabel("Start PID")
    .setPosition(width/4 + 130, height/2)
    .setSize(150, 30);
  // ***************************************

  // ======================================= 
  txtConfig = views.addTextlabel("instruction")
    .setText("Click on the ball")
    .setPosition(width/2, height*3/5)
    .setColor(color(255, 0, 0))
    .setFont(createFont("arial", 20))
    .setVisible(false);
  // ***************************************

  // ======================================= 
  views.addSlider("Hue")
    .setLabel("H")
    .setSize(100, 20)
    .setPosition(width - 120, height/2 - 30);

  views.addSlider("Saturation")
    .setLabel("s")
    .setSize(100, 20)
    .setPosition(width - 120, height/2);

  views.addSlider("Brightness")
    .setLabel("B")
    .setSize(100, 20)
    .setPosition(width - 120, height/2 + 30); 
  // ***************************************

  // ======================================= 
  intervalSP = views.addTextfield("interval")
    .setFont(createFont("arial", 10))
    .setLabel("Interval (ms)")
    .setText("2000")
    .setPosition(width/2 + 200, height/2 - 30)
    .setSize(50, 20)
    .setAutoClear(false);
  intervalSP.getCaptionLabel().align(ControlP5.RIGHT_OUTSIDE, ControlP5.CENTER).setPaddingX(5);
  // ***************************************
  
  // ======================================= 
  addSP = views.addToggle("add SP")
    .setFont(createFont("arial", 10))
    .setPosition(width/2 + 199, height/2)
    .setSize(60, 20);
  addSP.getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
  
  clearSP = views.addButton("clear")
    .setFont(createFont("arial", 10))
    .setPosition(width/2 + 268, height/2)
    .setSize(60, 20)
    .setLock(true);
  clearSP.getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);  
  // ***************************************  
  
  // ======================================= 
  startAutoSP = views.addToggle("START AUTO SETPOINT")
    .setFont(createFont("arial", 10))
    .setPosition(width/2 + 199, height/2 + 30)
    .setSize(130, 20)
    .setLock(true);
  startAutoSP.getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
  // ***************************************    
}


public void Hue(int value) {
  tracker.setThresholdH(value);
}

public void Saturation(int value) {
  tracker.setThresholdS(value);
}

public void Brightness(int value) {
  tracker.setThresholdB(value);
}

void initCharts() {
  chartInput = views.addChart("Input / SetPoint")
    .setFont(createFont("arial", 15))
    .setPosition(10, 10)
    .setSize(width/2 - 15, height*2/5)
    .setRange(width - camera.width, width)
    .setView(Chart.LINE);

  chartInput.addDataSet("input");
  chartInput.setData("input", new float[200]);

  chartInput.addDataSet("setPoint");
  chartInput.setData("setPoint", new float[200]);
  chartInput.getDataSet("setPoint").setColors(255);


  chartOutput = views.addChart("Output")
    .setFont(createFont("arial", 15))
    .setPosition(width/2 +  5, 10)
    .setSize(width/2 - 15, height*2/5)
    .setRange(0, width*height)
    .setView(Chart.LINE);

  chartOutput.addDataSet("output");
  chartOutput.setData("output", new float[100]);
}


void drawRectangles() {
  pushMatrix();
  noStroke();
  fill(100, 60);
  rect(10, height*3/5, width/2 - 20, height*2/5);
  fill(130, 60);
  rect(10, height - 50, width/2 - 20, height*2/5);
  popMatrix();
}

class Line {

  PApplet app;
  PID pid;

  public Line(PApplet app, PID pid) {
    this.pid = pid;
    this.app = app;
  }

  public void drawLine() {
      colorMode(RGB);
      fill(48, 255, 3);
      stroke(48, 255, 3);
      strokeWeight(3);
      line(pid.getSetPoint(), app.height*3/5, pid.getSetPoint(), app.height);
  }
}