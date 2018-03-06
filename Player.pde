class Player {
  float _x;
  float _y;
  float sX;
  float sY;
  
  Player() {
    _x = 10; _y = height - 20;
    sX = 0.5; sY = -12;
  }
  
  public void move(float g) {
    _x += sX;
    _y += sY;
    sY += g;
    
    if (sY > 0) {
      checkCollision();
    }
  }
  
  public void display() {
    fill(255);
    rect(_x, _y, 20, 20);
  }
  
  public void checkCollision() {
    println(_y + " / " + sY);
    
    if (_y + 10 > height)  {
      sY = 0;
      sX = 0;
    }
    
    if (_x > width) {
      sX = 0;
    }
  }
}