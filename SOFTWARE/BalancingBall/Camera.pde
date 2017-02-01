boolean initCamera() {

  String[] cameras = Capture.list();

  if (cameras == null || cameras.length == 0) {
    println("\nThere are no cameras available!\n");
    return false;
  } 

  println("Available cameras:");
  printArray(cameras);

  //camera = new Capture(this, 640, 480, "HP Webcam-101");
  camera = new Capture(this, 640, 480, "USB2.0 Camera");
  
  //Start capturing the images from the camera
  camera.start();
  
  return true;
}

void drawCamera() {
  image(camera, width/2, height*3/5, camera.width, camera.height);
}

// This event function is run when a new camera frame is available
void captureEvent(Capture c) {  
 c.read();
}

boolean cameraClicked() {
  return ((mouseX > width - camera.width) && (mouseY > height*3/5)
           && (mouseX < width) && (mouseY < height));
}

void colorTracker() {
  tracker.analyze(camera);
  //fill(tracker.getTrackingColor());
  //stroke(0, 0, 0, 100);
  //strokeWeight(1);
  //ellipse(tracker.getX(), tracker.getY(), 20, 20);
}