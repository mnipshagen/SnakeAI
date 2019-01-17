class Human {
  int id;
  int no;
  
  Snake snake;
  int[] colour = new int[3];
  float colourAlpha = 70.0;
  
  Brain brain;
  float[] sensations = new float[6];
  float[] percepts = new float[4];
  int framesBetweenSenses;
  int framesCount;
  
  float fitness;
  
  Human(int _id) {
    humanCounter++;
    no = humanCounter;
    framesBetweenSenses = 2;
    framesCount = framesBetweenSenses;
    id = _id;
    colour[0] = int(random(0, 255));
    colour[1] = int(random(0, 255));
    colour[2] = int(random(0, 255));
    snake = new Snake(colour, colourAlpha, no);
    brain = new Brain(sensations.length, percepts.length);
    fitness = 0;
  }
  
  void frame() {
    if (!snake.dead) {
      if (framesCount >= framesBetweenSenses) {
        sense();
        framesCount = 0;
      }
      framesCount++;
      snake.frame();
    }
  }
  
  void sense() {
    /*
    -------
    if we wanted to do this "perfectly" (i.e. generalised AI),
    we would have to use backpropagation and the full map as
    graphical input (condensed into colour codes).
    obviously we aren't going to do that. that's way too much
    work for way too little pay off.
    instead, we're going to use NEAT and give it a few well-
    defined parameters:
    -------
    
    sensations.struct{
      (((0 -> dist from food.x<-normalisedBy(uWidth))))
      (((1 -> dist from food.y<-normalisedBy(uHeight))))
      0 -> food x-wise (0 = no, -1 left, 1 right)
      1 -> food y-wise (0 = no, 1 down, -1 up)
      2 -> snake.tileClearLeft (bool)
      3 -> snake.tileClearDown (bool)
      4 -> snake.tileClearRight (bool)
      5 -> snake.tileClearUp (bool)
    }
    */
    
    int firstBlop = snake.findBlop(0);
    if (snake.blops.get(firstBlop).x > snake.food.x) {
      sensations[0] = (float) -1;
    } else if (snake.blops.get(firstBlop).x < snake.food.x) {
      sensations[0] = (float) 1;
    } else {
      sensations[0] = (float) 0;
    }
    if (snake.blops.get(firstBlop).y > snake.food.y) {
      sensations[1] = (float) -1;
    } else if (snake.blops.get(firstBlop).y < snake.food.y) {
      sensations[1] = (float) 1;
    } else {
      sensations[1] = (float) 0;
    }
    //sensations[0] = (float) (snake.food.x - snake.blops.get(firstBlop).x) / (float) u / (float) uWidth;
    //sensations[1] = (float) (snake.food.y - snake.blops.get(firstBlop).y) / (float) u / (float) uHeight;
    sensations[2] = snake.floatTileClear(-1, 0);
    sensations[3] = snake.floatTileClear(0, 1);
    sensations[4] = snake.floatTileClear(1, 0);
    sensations[5] = snake.floatTileClear(0, -1);
    
    think();
  }
  
  void think() {
    /*
    percepts.struct{
      0 -> p moveLeft()
      1 -> p moveUp()
      2 -> p moveRight()
      3 -> p moveDown()
    }
    */
    percepts = brain.perceive(sensations);
    
    // evaluate
    float maxP = -2;
    int maxI = -1;
    
    for (int i = 0; i < percepts.length; i++) {
      if (percepts[i] > maxP) {
        maxP = percepts[i];
        maxI = i + 1;
      }
    }
    
    snake.setDirection(maxI);
  }
  
  void calculateFitness() {
    fitness = pow(snake.blops.size(), 2);
  }
  
  Human clone() {
    Human clone = new Human(no);
    clone.colour = colour;
    clone.brain = brain.clone();
    clone.fitness = fitness;
    return clone;
  }
  
  Human crossbreed(Human P2) {
    Human offspring = new Human(dna.humans.size());
    offspring.brain = brain.crossbreed(P2.brain);
    return offspring;
  }
}
