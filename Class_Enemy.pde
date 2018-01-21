class Enemy {
  // initalize variables for coordinates, color, direction, and timing
  float x, y, speed = 40, d;
  color col;
  int direction, timerCounter, timer = int(random(30, 90)), colorSwitch;
  boolean reset = false, move = true, exploded = false;

  // default constructor for the coordinates, color, and movement direction
  Enemy(float initX, float initY, color c) {
    x = initX;
    y = initY;
    col = c;
    d = 40;
    direction = (int)random(1, 4);
    if (col == color(252, 252, 53))
      speed*=2;
  }

  // function to draw the enemy
  void drawEnemy() {
    if (!exploded) {
      ellipseMode(CENTER);
      stroke(0);
      strokeWeight(1);
      // main ellipse
      fill(col);
      ellipse(x, y, d, d);
      // left eye
      line(x-(d*0.3), y-(d*0.25), x-(d*0.1), y);
      line(x-(d*0.3), y, x-(d*0.1), y-(d*0.25));
      // right eye
      line(x+(d*0.1), y-(d*0.25), x+(d*0.3), y);
      line(x+(d*0.1), y, x+(d*0.3), y-(d*0.25));
      // tongue
      fill(255, 0, 0);
      stroke(0);
      arc(x+(d*0.15), y+(d*0.275), d*0.25, d*0.25, radians(-410), radians(-165));
      noStroke();
      ellipse(x+(d*0.15), y+(d*0.26), d*0.22, d*0.07);
      ellipse(x+(d*0.195), y+(d*0.229), d*0.1, d*0.07);
      stroke(0);
      line(x+(d*0.125), y+(d*0.225), x+(d*0.15), y+(d*0.3));
      // mouth
      noFill();
      arc(x, y+(d*0.05), d*0.625, d*0.375, radians(-340), radians(-200));
    } else {
      noStroke();
      colorSwitch++;
      if (colorSwitch % 3 == 0)
        fill(255, 5, 5, 80);
      else if (colorSwitch % 2 == 0)
        fill(252, 252, 53, 80);
      ellipse(x, y, d, d);
    }
  }

  // update the enemy
  void update() {
    randomMovement();
  }

  // function to increment a counter, move the enemy randomly, then reset the counter
  void randomMovement() {
    timerCounter++;

    if (direction == 1 && move && y < 640) {
      y-=speed;
      move = false;
    } else if (direction == 2 && move && x > -40) {
      x+=speed;
      move = false;
    } else if (direction == 3 && move && y > -40) {
      y+=speed;
      move = false;
    } else if (direction == 4 && move && x < 640) {
      x-=speed;
      move = false;
    }

    if (y >= 600)
      y = 20;
    else if (x >= 600)
      x = 20;
    else if (y <= 0)
      y = 580;
    else if (x <= 0)
      x = 580;

    if (timerCounter > timer && timerCounter != 0 || reset) {
      direction = int(random(1, 4));
      reset = true;
      timer = int(random(30, 90));
      timerCounter = 0;
      move = true;
      reset = false;
    }
  }
}