class Player {
  float _x;
  float _y;
  float sY;
  boolean jumping;
  float g;
  PImage skin;
  String name;
  
  boolean controlled;
  
  Player(float _g, PImage _skin, String _name, boolean control) {
    _x = width / 2; _y = height * 3 / 4;
    sY = 0;
    jumping = false;
    g = _g;
    skin = _skin;
    name = _name;
    controlled = control;
  }
  
  public void move() {
    _y += sY;
    
    if (jumping) {
      sY += g;
    }
    
    if (sY > 0 && jumping) {
      checkCollision();
    }
  }
  
  public void display(int x_control) {
    if (controlled) {
      fill(0, 127, 255);
      textSize(20);
      text(name, width / 2, _y - 40);
    
      fill(255);
      rect(width / 2, _y, 40, 40);
    }
    else {
      fill(255);
      textSize(10);
      text(name, (_x - x_control) + (width / 2), _y - 40);
      
      fill(255);
      rect((_x - x_control) + (width / 2), _y, 40, 40);
    }
  }
  
  public void checkCollision() {
    if (jumping) {
      if (_y + 10 > height / 2)  {
        sY = 0;
        jumping = false;
      }
    }
  }
}
