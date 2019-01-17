//int call = 0;

class Snake {
  int no;
  ArrayList<Blop> blops = new ArrayList<Blop>();
  int direction = directionLeft;
  int lastMove = directionLeft;
  int startingLengthOffset = 2;
  int framesBetweenMoves;
  int framesCounter;
  int[] colourRGB;
  float colourAlpha;
  Food food;
  boolean dead;
  
  Snake(int[] colour, float alpha, int id) {
    no = id;
    colourRGB = colour;
    colourAlpha = alpha;
    framesBetweenMoves = 30;
    framesCounter = framesBetweenMoves;
    blops.add(new Blop(blops.size(), int(random(startingLengthOffset + 2, uWidth - (startingLengthOffset + 2))), int(random(uHeight)), colourRGB, colourAlpha, no));
    for (int i = 0; i < startingLengthOffset; i++) {
      appendBlop();
      update();
    }
    food = new Food(this);
    dead = false;
  }
  
  void frame() {
    if (!dead) {
      framesCounter++;
      food.show();
      update();
      collision();
      show();
    }
  }
  
  void appendBlop() {
    int lastBlop = findBlop(blops.size() - 1);
    blops.add(new Blop(blops.size(), (blops.get(lastBlop).x / u), (blops.get(lastBlop).y / u), colourRGB, colourAlpha, no));
  }
  
  // used because ArrayList<Blops> isn't necessarily in perfect order...
  int findBlop(int no) {
    int ret = -1;
    for (int i = 0; i < blops.size(); i++) {
      if (blops.get(i).no == no) {
        return i;
      }
    }
    return ret;
  }
  
  void update() {
    if (framesCounter >= framesBetweenMoves) {
      int blopLast = findBlop(blops.size() - 1); // get last blop
      int blopFirst = findBlop(0); // get first blop
      blops.get(blopLast).x = blops.get(blopFirst).x;
      blops.get(blopLast).y = blops.get(blopFirst).y;
      blops.get(blopLast).no = -1;
      
      if ((direction == directionLeft) && (lastMove != directionRight)) {
        blops.get(blopLast).x -= u;
        lastMove = directionLeft;
      } else if ((direction == directionDown) && (lastMove != directionUp)) {
        blops.get(blopLast).y += u;
        lastMove = directionDown;
      } else if ((direction == directionRight) && (lastMove != directionLeft)) {
        blops.get(blopLast).x += u;
        lastMove = directionRight;
      } else if ((direction == directionUp) && (lastMove != directionDown)){
        blops.get(blopLast).y -= u;
        lastMove = directionUp;
      } else {
        // player trying to do a 180
        if (direction == directionLeft) {
          // go right
          blops.get(blopLast).x += u;
          direction = directionRight;
        } else if (direction == directionUp) {
          // go down
          blops.get(blopLast).y += u;
          direction = directionDown;
        } else if (direction == directionRight) {
          // go left
          blops.get(blopLast).x -= u;
          direction = directionLeft;
        } else {
          // go up
          blops.get(blopLast).y -= u;
          direction = directionUp;
        }
      }
      
      for (int i = 0; i < blops.size(); i++) {
        blops.get(i).no += 1;
      }
      
      framesCounter = 0;
      // println("FirstBlopX=", blops.get(0).x, " & FirstBlopY=", blops.get(0).y);
    }
  }
  
  void collision() {
    int firstBlop = findBlop(0);
    
    // border collisions
    if ((blops.get(firstBlop).x < 0) || (blops.get(firstBlop).x > width - u) || (blops.get(firstBlop).y < 0) || (blops.get(firstBlop).y > height - u)) {
      die();
      return;
    }
    
    // head x body collisions
    for (int i = 0; i < blops.size(); i++) {
      int currentBlop = findBlop(i);
      if (currentBlop != firstBlop) {
        if ((blops.get(firstBlop).x == blops.get(currentBlop).x) && (blops.get(firstBlop).y == blops.get(currentBlop).y)) {
          // println("collision with blop ", i);
          die();
          return;
        }
      }
    }
    
    // head x food collisions
    if ((blops.get(firstBlop).x == food.x) && (blops.get(firstBlop).y == food.y)) {
      appendBlop();
      update();
      food = new Food(this);
      food.show();
      speedUp();
    }
  }
  
  void speedUp() {
    if (framesBetweenMoves < 7) {
      framesBetweenMoves = 5;
    } else {
      framesBetweenMoves -= 2;
    }
  }
  
  void die() {
    dead = true;
  }
  
  void show() {
    for (int i = 0; i < blops.size(); i++) {
      blops.get(i).make();
    }
  }
  
  void setDirection(int dir) {
    direction = dir;
  }
  
  
  /*
  usage: supply movement vector(x, y)
  e.g.:
    tileClear(-1,0); checks for leftTile
    tileClear(0,1); checks for downTile
    tileClear(1,0); checks for rightTile
    tileClear(0,-1); checks for upTile
  */
  boolean tileClear(int offX, int offY) {
    boolean clear = true;
    int firstBlop = findBlop(0);
    offX = offX * u;
    offY = offY * u;
    
    // check for borders
    if ((blops.get(firstBlop).x + offX < 0) || (blops.get(firstBlop).x + offX > width - u) || (blops.get(firstBlop).y + offY < 0) || (blops.get(firstBlop).y + offY > height - u)) {
      clear = false;
    }
    
    // check for head x body
    for (int i = 0; i < blops.size(); i++) {
      int currentBlop = findBlop(i);
      if (currentBlop != firstBlop) {
        if ((blops.get(firstBlop).x + offX == blops.get(currentBlop).x) && (blops.get(firstBlop).y + offY == blops.get(currentBlop).y)) {
          clear = false;
        }
      }
    }
    //println("Call: " + call + "; OffX: " + offX + "; OffY: " + offY + " is " + clear);
    //call++;
    return clear;
  }
  
  float floatTileClear(int offX, int offY) {
    float clear = 1.0;
    if (!tileClear(offX, offY)) {
      clear = 0.0;
    }
    return clear;
  }
}
