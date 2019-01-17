class Food {
  Snake snake;
  int x;
  int y;
  int sizeX = 1 * u;
  int sizeY = 1 * u;
  
  Food(Snake that) {
    snake = that;
    boolean valid = false;
    while (!valid) {
      x = int(random(uWidth)) * u;
      y = int(random(uHeight)) * u;
      
      for (int i = 0; i < snake.blops.size(); i++) {
        if ((x != snake.blops.get(i).x) && (y != snake.blops.get(i).y)) {
          valid = true;
        }
      }
    }
  }
  
  void show() {
    //println("FoodX: ", x, " & FoodY: ", y);
    fill(snake.blops.get(0).inverseRGB[0], snake.blops.get(0).inverseRGB[1], snake.blops.get(0).inverseRGB[2], snake.colourAlpha);
    rect(x, y, sizeX, sizeY);
    fill(snake.colourRGB[0], snake.colourRGB[1], snake.colourRGB[2], snake.colourAlpha);
    text(snake.no, x + (u / 4), y + (u - 1));
  }
}
