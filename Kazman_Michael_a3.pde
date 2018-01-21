/* Bomb Squad Prototype
 Author: Michael Kazman
 Date: 02/11/2017
 Course: COMP1501A
 Professor: Robert Collier
 Sources: Based off chain reaction mechanism from David Mould's "Chain Reaction" Program
 */

// object related variables
Agent agent;
Powerup b, s;
int numBombs = 0, maxBombs = 6, bombCounter = 0;
ArrayList<Bomb> bombs = new ArrayList<Bomb>(maxBombs);
int numEnemies = 0, maxEnemies = 12, enemiesKilled;
ArrayList<Enemy> enemies = new ArrayList<Enemy>(maxEnemies);
// health related variables
int lifeTimer = 100, lifeCounter;
boolean lifeReset = false;
// color & challenge related variables
color col, c2col;
int cTimer = 250, c2Counter, c3Counter;
int score = 0, scoreMultiplier = 1, c1;

// -------------------------------- Program Setup & Properties ----------------------------------- \\
void setup() {
  size(600, 640);
  smooth();
}  
// --------------------------------Opening Game Screen -------------------------------------------- \\
float introX = 300, introY = 320, introSpeedX = 3, introSpeedY = 3, introRadius = 90;
boolean play = false, options = false, missionFailed = true, firstPlay = true;
void introScreen() {
  background(0);
  // Enemy Mechanics
  introX += introSpeedX;
  introY += introSpeedY;
  if (introX > width - introRadius || introX < introRadius)
    introSpeedX *= -1;
  if (introY > height - introRadius || introY < introRadius)
    introSpeedY *= -1;
  Enemy introEnemy = new Enemy(introX, introY, color (random(0, 255), random(0, 255), random(0, 255)));
  introEnemy.d = introRadius*2;
  introEnemy.drawEnemy();
  // Title of the game
  textSize(90);
  textAlign(CENTER);
  text("B   MB\nSQUAD", 300, 110);
  Bomb bomb = new Bomb(width*0.4367, height*0.12, 75, 0);
  bomb.drawBomb();
  // Buttons on the intro page
  rectMode(CENTER);
  fill(255, 255, 255);
  stroke(191, 28, 28);
  rect(300, 350, 300, 100, 10);
  rect(300, 475, 500, 100, 10);
  fill(191, 28, 28);
  text("PLAY", 300, 385);
  textSize(65);
  text("INSTRUCTIONS", 300, 500);
  if (mouseX >= 150 && mouseX <= 450 && mouseY >= 300 && mouseY <= 400 && mousePressed) {
    play = true;   
    resetGame();
  } 
  if (mouseX >= 50 && mouseX <= 550 && mouseY >= 425 && mouseY <= 525 && mousePressed)
    options = true;
  if (options) {
    stroke(255, 255, 255);
    rect(width/2, height/1.45, 550, 350, 10);
    fill(0);
    textAlign(CENTER);
    textSize(20);
    text("INSTRUCTIONS:", 300, 290);
    textSize(14);
    text("Welcome to Bomb Squad. You are Agent X, a highly trained \nexplosive-specialist. The CIA has tasked you with a mission to complete \nthe challenges presented at the bottom of the screen. If you successfully \ncomplete a challenge, you will recieve another. Complete all three and\nyour mission is complete. If you fail any objectives, there is no backing out.\nYou must then kill as many 'Crazies' as possible. You must defeat the \nCrazies using the weapons at your disposal. You can only place down a \ncertain number of bombs, and once they fully detonate they will recharge.\nOnce a crazy is eliminated, they create an explosion on their location of death.\nThe arrow keys control movement, the spacebar bomb placement, \nand 'Q' returning to the main menu. You have health, bomb,\nand score counters at the bottom of the screen. Powerups can spawn\nrandomly and can increase bomb capacity or score multipliers. Each\ntype of enemy is unique. That is the only intel we have been provided. \nGood Luck.", 300, 310);
    // draw the exit box
    fill(0);
    rect(555, 290, 30, 30, 10); 
    line(545, 280, 565, 300);
    line(565, 280, 545, 300);
    if (mouseX >= 540 && mouseX <= 570 && mouseY >= 280 && mouseY <= 300 && mousePressed)
      options = false;
  }

  textSize(20);
  if (missionFailed && enemies.size() == 0 && !options && !firstPlay)
    text("MISSION FAILED, BUT GOOD KILLING.", width/2, 570);
  else if (missionFailed && !options && !firstPlay) 
    text("MISSION FAILED, YOU HAVE FAILED YOUR TASK.", width/2, 570);
  else if (!missionFailed && !options || challengeCount == 3 && !options && !firstPlay) 
    text("MISSION SUCCESSFUL, CONGRATULATIONS AGENT X.", width/2, 570);

  if (!firstPlay && !options) {
    fill(255, 255, 255);
    textSize(20);
    text("YOUR SCORE WAS: " + score, width/2, 620);
  }
}
// ---------------------------- Program Draw and Render Function ------------------------------- \\ 
void draw() {
  if (!play) {
    introScreen();
  } else if (play) {
    background(255, 255, 255);
    // --------- draw gridlines & background ---------//
    for (int i = 0; i < width; i+=40) {
      for (int z = 0; z < height; z+=40) {
        stroke(0);
        strokeWeight(1);
        line(i, 0, i, height-40);
        line(0, z, width, z);
      }
    }
    // ----------- draw the characters and bombs ------ //
    // draw all the bombs and update 
    for (int i = bombs.size()-1; i >= 0; i--) { 
      Bomb bomb = bombs.get(i); 
      bomb.drawBomb();
      bomb.update();
      if (bomb.gone) {
        numBombs--;
        bombCounter--;
        bombs.remove(i);
      }
    }
    // draw all the enemies and update
    for (int i = enemies.size()-1; i >= 0; i--) { 
      Enemy enemy = enemies.get(i); 
      enemy.drawEnemy();
      enemy.update();
    }

    // ----- implement the settings and mechanics ------ //
    collisionDetection();
    healthLoss();
    powerUps();
    gameOver();
    // draw the main character
    agent.drawAgent();
    // update the challenges, and draw the HUD
    challengeUpdate();
  }
}
// ---------------------------- Collision Detection Functions ------------------------------- \\
// Function to calculate the distance, used for collision detection
float getDist(float x1, float y1, float x2, float y2) {
  return (float)Math.sqrt(Math.pow(x1-x2, 2) + Math.pow(y1-y2, 2));
}

// Function to determine if collision occurs between bombs and enemies
void collisionDetection() {
  for (int i = bombs.size()-1; i >= 0; i--) { 
    for (int j = enemies.size()-1; j >= 0; j--) {
      // if the bombs and enemies collide
      if (getDist(bombs.get(i).x, bombs.get(i).y, enemies.get(j).x, enemies.get(j).y) <= bombs.get(i).d/2 + enemies.get(j).d/2 && bombs.get(i).exploded) {
        // create a new explosion at that radius, eliminate the enemy, and increment the bombs and enemy values
        bombs.add(new Bomb(enemies.get(j).x, enemies.get(j).y, 30, bombs.get(i).timerLimit));
        numBombs++;
        enemies.remove(j);
        numEnemies--;
        enemiesKilled++;
        score+=scoreMultiplier;
      }
    }
  }
}

void powerUps() {
  if (agent != null) {
    int z = (int)random(0, 1000);
    if (z == 1)
      b = new Powerup(20+(int)random(0, 15)*40, 20+(int)random(0, 15)*40, z);
    if (z == 2)
      s = new Powerup(20+(int)random(0, 15)*40, 20+(int)random(0, 15)*40, z);

    if (b != null) {
      b.drawPowerup();
      if (getDist(agent.x, agent.y, b.x, b.y) < 25) {
        b.bombBoost();
        b = null;
      }
    }

    if (s != null) {
      s.drawPowerup();
      if (getDist(agent.x, agent.y, s.x, s.y) < 25) {
        s.scoreBoost();
        s = null;
      }
    }
  }
}

void healthLoss() {
  lifeCounter++;
  for (int i = enemies.size()-1; i >= 0; i--) {
    if (getDist(agent.x, agent.y, enemies.get(i).x, enemies.get(i).y) < 25)
      if (lifeCounter > lifeTimer && lifeCounter != 0 && agent.lives > 0 || lifeReset) {
        lifeReset = true;
        agent.lives--;
        if (enemies.get(i).col == color(24, 173, 34))
          lifeTimer = 75;
        else
          lifeTimer = 100;
        lifeCounter = 0;
        lifeReset = false;
      }
  }
}

int gameOverTimer = 250, gameOverCounter;
void gameOver() {
  if (enemies.size() == 0 || missionFailed == false || agent.lives == 0)
    gameOverCounter++;

  if (agent.lives == 0 && gameOverCounter > gameOverTimer || enemies.size() == 0 && missionFailed == true && gameOverCounter > gameOverTimer || !missionFailed && gameOverCounter > gameOverTimer)
    play = false;
}
// -------------------------------- Keyboard Controls & Movement ----------------------------------- \\
void keyPressed() {
  switch(keyCode) {

  case UP:
    if (agent.y >= 47.5 && agent.y <= 600)
      agent.y-=40;
    break;

  case DOWN:
    if (agent.y >= 0 && agent.y <= 560)
      agent.y+=40;
    break;

  case LEFT:
    if (agent.x >= 47.5 && agent.x <= 600)
      agent.x-=40;
    break;

  case RIGHT:
    if (agent.x >= 0 && agent.x <= 560)
      agent.x+=40;
    break;

  case 32:
    // Space bar key press
    if (numBombs < maxBombs) {
      // create a bomb and increase the counter
      bombs.add(new Bomb(agent.x, agent.y, 30, 0));
      numBombs++;
      bombCounter++;
    }
    break;

  case 81:
    play = false;
    break;
  }
}
// ------------------------------- Challenge and Goal Functions ----------------------------------- \\
int challengeCount = 0, tempCount;
// Challenge of killing x amount of enemies
boolean challenge1(int killCount) {
  if (killCount <= (maxEnemies - numEnemies)+1) 
    return true;
  else {
    text("Challenge " + (challengeCount+1) + ": Kill at least " + killCount + " enemies.", 135, 620);
    return false;
  }
}

// Challenge of killing enemies of color x
boolean challenge2 (color c) {
  String textColor = "";
  tempCount = 0;
  // count how many enemies of the specific color exist
  for (int i = enemies.size()-1; i >= 0; i--) { 
    if (enemies.get(i).col == c)
      tempCount++;
  }
  // Used to write the color to a string
  if (c == color(252, 252, 53))
    textColor = "yellow";
  else if (c == color(255, 128, 0))
    textColor = "orange"; 
  else if (c == color(24, 173, 34))
    textColor = "green";

  c2Counter++;
  text("Challenge " + (challengeCount+1) + ": Kill all that are colored " + textColor + ".", 160, 620);
  if (c2Counter > cTimer) {
    if (tempCount == 0)
      return true;
  }
  return false;
}

boolean challenge3 () {
  c3Counter++;
  if (c3Counter > cTimer) {
    if (agent.lives == agent.maxLives)
      return true;
    else if (agent.lives < agent.maxLives)
      return false;
  } else 
  text("Challenge " + (challengeCount+1) + ": Do not lose a single life.", 140, 620);
  return false;
}

// method to update all the challenges
void challengeUpdate() {
  textAlign(CENTER, CENTER);
  fill(0, 0, 0);
  rect(300, 621, 600, 40);
  fill(255, 0, 0);
  textSize(14);

  switch(challengeCount) {  

  case 0:
    if (challenge1(c1))
      challengeCount = 1;
    break;

  case 1:
    if (challenge2(c2col))
      challengeCount = 2;
    break;

  case 2:
    if (challenge3())
      challengeCount = 3;
    else if (!challenge3() && c3Counter > cTimer) {
      text("Mission Failed, better luck next time.", 140, 620);
      stroke(255, 0, 0);
      strokeWeight(3);
      line(572, 617, 588, 633);
      line(572, 633, 588, 617);
    }
    break;

  case 3:
    missionFailed = false;
    text("Mission Complete, time to head home.", 140, 620);
    break;
  }

  for (int i = 0; i < challengeCount; i++) {
    strokeWeight(3);
    stroke(0, 255, 0);
    noFill();
    ellipse((width-70)+25*i, height-15, 15, 15);
  }
  for (int i = 0; i < 3; i++) {
    noFill();
    strokeWeight(1);
    stroke(255, 255, 255);
    rect((width-70)+25*i, height - 15, 25, 25);
  }
  textSize(10);
  text("Challenges: ", 558, 605);
  fill(255, 255, 255);
  text("Score:\n" + (score), 355, 620);
  if (maxBombs-bombCounter-enemiesKilled < 0)
    text("Bombs Left:\n" + (0), 415, 620);
  else
    text("Bombs Left:\n" + (maxBombs-bombCounter-enemiesKilled), 415, 620);
  text("Lives Left:\n" + (agent.lives), 475, 620);
}
// ---------------------------------- Replay Function -------------------------------------- \\
void resetGame() {
  // set variables to default state
  numEnemies = 0;
  numBombs = 0;
  score = 0;
  scoreMultiplier = 1;
  enemiesKilled = 0;
  bombCounter = 0;
  challengeCount = 0;
  lifeTimer = 100;
  lifeReset = false;
  c1 = (int)random(4, 8);
  cTimer = 250;
  c2Counter = 0;
  c3Counter = 0;
  missionFailed = true;
  firstPlay = false;
  gameOverTimer = 250;
  gameOverCounter = 0;
  // initialize the main character
  agent = new Agent(20+(int)random(0, 15)*40, 20+(int)random(0, 15)*40);
  // delete all pre-existing explosions in the game
  for (int i = bombs.size()-1; i >= 0; i--)
    bombs.remove(i);
  // intialize the enemies and set their color to one of the three random ones
  enemies = new ArrayList<Enemy>(maxEnemies);
  for (int i = maxEnemies; i >= 0; i--) { 
    int z = (int)random(0, 150);
    if (z < 50)
      col = color (252, 252, 53);
    else  if (z >= 50 && z < 100)
      col = color (255, 128, 0);
    else
      col = color (24, 173, 34);
    enemies.add(new Enemy(20+(int)random(0, 15)*40, 20+(int)random(0, 15)*40, col));
    numEnemies++;
  }

  // determines the challenge color for objective 2
  int c2 = (int) random(1, 4);
  if (c2 == 1)
    c2col = color (252, 252, 53); 
  else if (c2 == 2) 
    c2col = color (255, 128, 0);
  else if (c2 == 3)
    c2col = color (24, 173, 34);
}