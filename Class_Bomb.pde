class Bomb {
  // initalize variables for coordinates and timing
  float x, y, d, timer, growRate = 1;
  final float timerLimit = 200, maxD = 100;
  // booleans to indicate when the bomb is exploding
  int colorSwitch = 0;
  boolean exploded = false, gone = false;
  ArrayList others;

  // default constructor for coordinates and size
  Bomb(float initX, float initY, int diameter, float t) {
    x = initX;
    y = initY;
    d = diameter;
    timer = t;
  }

  // function to draw the bomb (in different states)
  void drawBomb() {
    ellipseMode(CENTER);
    if (exploded == false) {
      // main ellipse
      fill(21, 57, 163);
      stroke(0, 0, 0);
      ellipse(x, y, d*1.13, d*1.13);
      // second biggest circle 
      fill(123, 189, 201);
      ellipse(x, y-(0.43*d), d*0.6, d*0.33);
      fill(21, 86, 97);
      // smallest circle on the top
      ellipse(x, y-(0.43*d), d*0.35, d*0.165);
      noFill();
      // bomb wire
      stroke(94, 44, 44);
      strokeWeight(0.04*d);
      arc(x+(d*1.460), y-(d*0.2), (d*2.96), (d*2.4), radians(-168), radians(-152));
      noStroke();
      strokeWeight(1);
      // red top fire fuse
      fill(255, 0, 0);
      ellipse(x+(d*0.2), y-(d*0.833), (d*0.1467), (d*0.1467));
      // orange top fire fuse
      fill(255, 170, 0);
      ellipse(x+(d*0.195), y-(d*0.835), (d*0.122), (d*0.122));
    } else if (exploded == true) {
      fill(252, 252, 53, 80);
      noStroke();
      colorSwitch++;
      if (colorSwitch % 3 == 0)
        fill(255, 5, 5, 80);
      else if (colorSwitch % 4 == 0)
        fill(252, 252, 53, 80);
      ellipse(x, y, d, d);
    }
  }

  // update the bomb (make it explode, or shrink depending on timers)
  void update() {
    timer++;
    if (timer > timerLimit) {
      d += growRate;
      exploded = true;
    }
    if (d > maxD) 
      growRate = -0.9;
    if (d < 0) {
      gone = true;
      d = 0;
    }
  }
}