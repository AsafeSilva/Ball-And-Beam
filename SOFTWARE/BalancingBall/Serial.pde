void selectSerialPort() {

  JFrame frame = new JFrame("SerialPort");
  String portName = (String) JOptionPane.showInputDialog(frame, 
    "Selecione a porta serial que corresponde ao seu Arduino.", 
    "Selecione a porta serial", 
    JOptionPane.QUESTION_MESSAGE, 
    null, 
    Serial.list(), 
    0);

  if (portName == null) return;

  if (serialPort != null) serialPort.stop();

  serialPort = new Serial(this, portName, 9600);
  
  pid.addSerial(serialPort);

  serialPort.bufferUntil('\n');
}

interface InterfaceSerial {
  public void sendSerial(float value);
}