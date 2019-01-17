DNA dna;
int u = 8; // unit of the game (u^2 = 1 rectangle in grid) ; must be linear with height() and width()
int uHeight;
int uWidth;
int directionLeft = 1;
int directionUp = 2;
int directionRight = 3;
int directionDown = 4;

void setup() {
  frameRate(60);
  noStroke();
  rectMode(CORNER);
  size(128, 128); // 16x16
  uHeight = (height / u);
  uWidth = (width / u);
  dna = new DNA(500);
}

void draw() {
  background(255);
  dna.frame();
  
  if (dna.generation > 0) {
    fill(0,0,0,100.0);
    String s1 = "Generation: " + dna.generation;
    String s2 = "BestScore: " + dna.bestFitness;
    text(s1, 10, 5);
    text(s2, 10, 15);
  }
}

void keyPressed(){
  if (key == 'e') { // little safety measure here. in case something goes awry and they just go in circles, just kill them all off
    dna.massExtinction();
  }
}
