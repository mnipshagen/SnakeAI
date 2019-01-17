class Blop {
  int snakeNo;
  int no;
  int x;
  int y;
  int sizeX = 1 * u;
  int sizeY = 1 * u;
  int[] colourRGB = new int[3];
  int[] inverseRGB = new int[3];
  float colourAlpha;
  
  Blop(int id, int _x, int _y, int[] rgb, float alpha, int snakeId) {
    snakeNo = snakeId;
    no = id;
    x = _x * u;
    y = _y * u;
    colourRGB = rgb;
    inverseRGB[0] = inverse(colourRGB[0]);
    inverseRGB[1] = inverse(colourRGB[1]);
    inverseRGB[2] = inverse(colourRGB[2]);
    colourAlpha = alpha;
  }
  
  void make() {
    fill(colourRGB[0], colourRGB[1], colourRGB[2], colourAlpha);
    rect(x, y, sizeX, sizeY);
    
    if (no == 0) { // marker on first element
      fill(255, 255, 255, colourAlpha);
      rect(x + (u / 4), y + (u / 4), (u / 2), (u / 2));
      fill(inverseRGB[0], inverseRGB[1], inverseRGB[2], 100.0);
      textSize(u);
      text(snakeNo, x + (u / 4), y + (u - 1));
    }
  }
  
  int inverse(int colour) {
    int out = 255 - colour;
    return out;
  }
}
