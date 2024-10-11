int pacX = 400;
int pacY = 100;
int pacSize = 40;
int pacSpeed = 3;
boolean movingRight = true;
float mouthAngle = PI / 4;
float mouthSpeed = PI / 11.0000005;

int score = 0;
int highScore = 0;
boolean gameOver = false;
boolean paused = false;

int pelletSize = 10;
int pelletSpacing = 40;
int numPellets = 20;
int[] pelletX = new int[numPellets];
boolean[] pelletEaten = new boolean[numPellets];

int ghostX;
int ghostY = 100;
int ghostSize = 40;
int ghostSpeed = 4;
boolean ghostMovingRight = true;
boolean ghostHarmless = false;
int ghostHarmlessCounter = 0;

int fruitX;
int fruitY = 100;
int fruitSize = 20;
boolean fruitEaten = false;

int difficultyIncreaseCounter = 0;

public void settings() {
    size(800, 200);
    for (int i = 0; i < numPellets; i++) {
        pelletX[i] = i * pelletSpacing + 20;
        pelletEaten[i] = false;
    }
    ghostX = (int) random(width);
    fruitX = (int) random(width);
}

public void draw() {
    if (!paused) {
        if (!gameOver) {
            background(0);
            drawTrack();
            drawPellets();
            drawFruit();
            drawPacMan();
            drawGhost();
            movePacMan();
            moveGhost();
            checkCollisions();
            displayScore();
            increaseDifficulty();
        } else {
            displayGameOver();
        }
    } else {
        displayPaused();
    }
}

public void drawTrack() {
    stroke(0, 0, 255);
    strokeWeight(10);
    line(0, pacY + pacSize + 5, width, pacY + pacSize + 5);
    line(0, pacY - pacSize - 5, width, pacY - pacSize - 5);
    noStroke();
}

public void drawPellets() {
    fill(255, 255, 255);
    for (int i = 0; i < numPellets; i++) {
        if (!pelletEaten[i]) {
            ellipse(pelletX[i], pacY, pelletSize, pelletSize);
        }
    }
}

public void drawFruit() {
    if (!fruitEaten) {
        fill(255, 0, 0);
        ellipse(fruitX, fruitY, fruitSize, fruitSize);
    }
}

public void drawPacMan() {
    fill(255, 255, 0);
    if (movingRight) {
        arc(pacX, pacY, pacSize, pacSize, mouthAngle, TWO_PI - mouthAngle, PIE);
    } else {
        arc(pacX, pacY, pacSize, pacSize, PI + mouthAngle, PI + TWO_PI - mouthAngle, PIE);
    }
}

public void drawGhost() {
    if (ghostHarmless) {
        fill(255);
    } else {
        fill(255, 0, 0);
    }
    rect(ghostX - ghostSize / 2, ghostY - ghostSize / 2, ghostSize, ghostSize);
}

public void movePacMan() {
    if (movingRight) {
        pacX += pacSpeed;
        if (pacX >= width - pacSize / 2) {
            pacX = -pacSize / 2;
        }
    } else {
        pacX -= pacSpeed;
        if (pacX <= -pacSize / 2) {
            pacX = width - pacSize / 2;
        }
    }
    mouthAngle += mouthSpeed;
    if (mouthAngle >= PI / 4 || mouthAngle <= 0) {
        mouthSpeed *= -1;
    }
}

public void moveGhost() {
    if (ghostMovingRight) {
        ghostX += ghostSpeed;
        if (ghostX >= width - ghostSize / 2) {
            ghostMovingRight = false;
        }
    } else {
        ghostX -= ghostSpeed;
        if (ghostX <= ghostSize / 2) {
            ghostMovingRight = true;
        }
    }

    if (frameCount % 120 == 0) {
        ghostMovingRight = !ghostMovingRight;
    }

    if (ghostHarmless) {
        ghostHarmlessCounter++;
        if (ghostHarmlessCounter > 300) {
            ghostHarmless = false;
            ghostHarmlessCounter = 0;
            fruitEaten = false;
            fruitX = (int) random(width);
        }
    }
}

public void checkCollisions() {
    boolean allPelletsEaten = true;
    for (int i = 0; i < numPellets; i++) {
        if (!pelletEaten[i] && dist(pacX, pacY, pelletX[i], pacY) < (pacSize + pelletSize) / 2) {
            pelletEaten[i] = true;
            score++;
        }
        if (!pelletEaten[i]) {
            allPelletsEaten = false;
        }
    }

    if (allPelletsEaten) {
        for (int i = 0; i < numPellets; i++) {
            pelletEaten[i] = false;
        }
    }

    if (!fruitEaten && dist(pacX, pacY, fruitX, fruitY) < (pacSize + fruitSize) / 2) {
        fruitEaten = true;
        ghostHarmless = true;
        ghostHarmlessCounter = 0;
    }

    if (dist(pacX, pacY, ghostX, ghostY) < (pacSize + ghostSize) / 2) {
        if (!ghostHarmless) {
            gameOver = true;
            if (score > highScore) {
                highScore = score; 
            }
        }
    }
}

public void increaseDifficulty() {
    difficultyIncreaseCounter++;
    if (difficultyIncreaseCounter % 600 == 0) { 
        pacSpeed++;
        ghostSpeed++;
    }
}

public void displayScore() {
    fill(255);
    textSize(16);
    textAlign(LEFT, TOP);
    text("Score: " + score, 5, 15);
    text("High Score: " + highScore, 5, 30);
}

public void displayGameOver() {
    textSize(28);
    textAlign(CENTER);
    text("Game Over! Press 'R' to restart", width / 2, height / 5);
}

public void displayPaused() {
    textSize(28);
    textAlign(CENTER);
    text("Paused! Press 'P' to resume", width / 2, height / 5);
}

public void keyPressed() {
    if (key == ' ') {
        movingRight = !movingRight;
    }
    if (key == 'R' || key == 'r') {
        restartGame(); // Restart the game
    }
    if (key == 'P' || key == 'p') {
        paused = !paused; // Pause or resume the game
    }
}

public void restartGame() {
    score = 0;
    gameOver = false;

    pacX = 400;
    movingRight = true;

    ghostX = (int) random(width);
    ghostHarmless = false;
    ghostHarmlessCounter = 0;

    for (int i = 0; i < numPellets; i++) {
        pelletEaten[i] = false;
    }

    fruitEaten = false;
    fruitX = (int) random(width);
}
