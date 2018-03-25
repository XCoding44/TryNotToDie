class Player {
  float _x;
  float _y;
  float sX;
  float sY;
  boolean jumping;
  float g;
  
  Player(float _g) {
    _x = width / 2; _y = height * 3 / 4;
    sX = 0; sY = 0;
    jumping = false;
    g = _g;
  }
  
  public void move() {
    _x += sX;
    _y += sY;
    
    if (jumping) {
      sY += g;
    }
    
    if (sY > 0 && jumping) {
      checkCollision();
    }
  }
  
  public void display() {
    fill(255);
    rect(width / 2, _y, 40, 40);
  }
  
  public void checkCollision() {
    if (jumping) {
      if (_y + 10 > height / 2)  {
        sY = 0;
        sX = 0;
        jumping = false;
      }
    }
  }
}
