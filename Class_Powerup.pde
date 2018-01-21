class Powerup {
  // initalize variables for coordinates and powerup indicator
  float x, y;
  int powerup;

  // default constructor to initialize coordinates and indicator value
  Powerup(float initX, float initY, int p) {
    x = initX;
    y = initY;
    powerup = p;
  }

  // draw the powerups depending on their powerup value
  void drawPowerup() {
    if (powerup == 1) {
      rectMode(CENTER);
      fill(0, 255, 0);
      rect(x, y, 40, 40);
      Bomb p = new Bomb(x-7, y+3, 20, 0);
      p.drawBomb();
      fill(255, 0, 0);
      rect(x+12, y, 10, 2);
      rect(x+12, y, 2, 10);
    } else if (powerup == 2) {
      rectMode(CENTER);
      fill(0, 255, 0);
      rect(x, y, 40, 40);
      textSize(32);
      fill(0);
      text("2", x-10, y-4);
      strokeWeight(3);
      stroke(0);
      line(x, y-10, x+14, y + 10);
      line(x, y+10, x+14, y - 10);
    }
  }

  // increment bomb count
  void bombBoost() {
    maxBombs++;
  }

  // double score multiplier
  void scoreBoost() {
    scoreMultiplier*=2;
  }
}