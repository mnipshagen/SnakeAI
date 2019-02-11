DNA dna;
int u = 8; // unit of the game (u^2 = 1 rectangle in grid) ; must be linear with height() and width()
int uHeight;
int uWidth;
int directionLeft = 1;
int directionUp = 2;
int directionRight = 3;
int directionDown = 4;
boolean sketchBrain = false;

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
    drawBrain();
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
  } else if (key == 'b') { // toggle sketch brain
    if (dna.generation > 0) {
      sketchBrain = !sketchBrain;
      println("toggled sketchBrain=",sketchBrain);
    }
  }
}

int[] dbFindNeuron(ArrayList<ArrayList<Integer>> neurons, int neuron) {
  int[] out = new int[2];
  for (int i = 0; i < neurons.size(); i++) {
    for (int n = 0; n < neurons.get(i).size(); n++) {
      if (neurons.get(i).get(n) == neuron) {
        out[0] = i;
        out[1] = n;
        return out;
      }
    }
  }
  return out;
}

void drawBrain(){
  if (!sketchBrain) {
    return;
  }
  
  // clear
  fill(255);
  rect(0, 0, width, height);
  
  Brain brain = dna.species.get(0).specimen.get(0).brain;
  
  // setup
  int x = 35;
  int y = 25;
  int offsetX = 30;
  int offsetY = 15;
  int size = 10;
  
  // organise brain
  ArrayList<ArrayList<Integer>> neurons = new ArrayList<ArrayList<Integer>>();
  for (int i = 0; i < brain.layers; i++) {
    neurons.add(new ArrayList<Integer>());
  }
  for (int i = 0; i < brain.neurons.size(); i++) {
    neurons.get(brain.neurons.get(i).type).add(brain.neurons.get(i).no);
  }
  
  // draw axons
  for (int i = 0; i < brain.phenotypeAxons.size(); i++) {
    int[] from = dbFindNeuron(neurons, brain.phenotypeAxons.get(i).presynapticNeuron.no);
    int[] to = dbFindNeuron(neurons, brain.phenotypeAxons.get(i).postsynapticNeuron.no);
    float exc = brain.phenotypeAxons.get(i).excitability;
    boolean exp = brain.phenotypeAxons.get(i).expressed;
    
    if (!exp) {
      stroke(0, 0, 0);
    } else if (exc < 0) {
      stroke(0, 0, 255);
    } else {
      stroke(255, 0, 0);
    }
    
    strokeWeight(int(abs(exc) * 3));
    
    line(x + offsetX * from[0], y + offsetY * from[1], x + offsetX * to[0], y + offsetY * to[1]);
  }
  
  stroke(0, 0,0);
  strokeWeight(1);
  
  // draw neurons
  for (int i = 0; i < brain.layers; i++) {
    for (int n = 0; n < neurons.get(i).size(); n++) {
      fill(255);
      ellipse(x + offsetX * i, y + offsetY * n, size, size);
    }
  }
  
  // label inputs
  for (int i = 0; i < dna.humans.get(0).labels.length; i++) {
    fill(1);
    text(dna.humans.get(0).labels[i], x - offsetX, y + offsetY * i + 3);
  }
  
  noStroke();
}
