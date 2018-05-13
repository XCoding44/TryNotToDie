class Player {
  float _x;
  float _y;
  float sY;
  float g;
  
  int life = 3;
  
  PImage skin;
  PImage heart, skull;
  String name;
  
  boolean gm;
  boolean controlled;
  boolean jumping;
  
  Player(float _g, PImage _skin, String _name, boolean control, boolean _gm) {
    _x = width / 2; _y = height * 3 / 4;
    sY = 0;
    jumping = false;
    g = _g;
    skin = _skin;
    name = _name;
    controlled = control;
    gm = _gm;
    
    /* Define skull and heart */
    heart = loadImage("Heart_icon.png");
    heart.resize(16,16);
    skull = loadImage("skull_icon.png");
    skull.resize(16,16);
  }
  
  public void move() {
    if (!gm) {
      _y += sY;
    
      if (jumping) {
        sY += g;
      }
    
      if (sY > 0 && jumping) {
        checkCollision();
      }
    }
  }
  
  public void display(int x_control) {
    if (controlled && !gm) {
      fill(0, 0, 255);
      textSize(20);
      text(name, width / 2, _y - 40);
    
      fill(255);
      rect(width / 2, _y, 40, 40);
    }
    else if (!gm) {
      fill(255);
      textSize(10);
      text(name, (_x - x_control) + (width / 2), _y - 40);
      
      fill(255);
      rect((_x - x_control) + (width / 2), _y, 40, 40);
    }
    
    if (!gm && controlled) {
      imageMode(CENTER);
      if (life == 3) {
        image(heart, width / 2 - 20, _y - 60);
        image(heart, width / 2, _y - 60);
        image(heart, width / 2 + 20, _y - 60);
      }
      else if (life == 2) {
        image(heart, width / 2 - 20, _y - 60);
        image(heart, width / 2, _y - 60);
        image(skull, width / 2 + 20, _y - 60);
      }
      else if (life == 1) {
        image(heart, width / 2 - 20, _y - 60);
        image(skull, width / 2, _y - 60);
        image(skull, width / 2 + 20, _y - 60);
      }
      imageMode(CORNER);
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
