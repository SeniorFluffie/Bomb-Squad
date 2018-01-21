class Agent {
  // initalize variables for coordinates and live count
  float x, y;
  final int maxLives = 5;
  int lives; 

  // default constructor to intialize coordinates and lives
  Agent(float initX, float initY) {
    x = initX;
    y = initY;
    lives = maxLives;
  }

  // function to draw the agent
  void drawAgent() {
    rectMode(CENTER);
    stroke(0);
    strokeWeight(1);
    fill(255, 0, 0);
    rect(x, y, 25, 25);
    fill(0, 0, 0);
    noStroke();
    arc(x-6, y-2, 10, 10, radians(-180), radians(0));
    arc(x+6, y-2, 10, 10, radians(-180), radians(0));
    arc(x, y+2, 16, 16, radians(-360), radians(-180));
  }
}