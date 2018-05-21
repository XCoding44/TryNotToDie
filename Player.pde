class Player {
  float _x;
  float _y;
  float sY;
  float g;
  
  int life = 3;
  int anim_tempo = 0;
  int anim_state = 0;
  
  PImage[] skin = new PImage[6];
  PImage heart, skull;
  String name;
  
  boolean fw = true;
  boolean walking = false;
  boolean gm;
  boolean controlled;
  boolean jumping;
  
  Player(String _skin, String _name, boolean control, boolean _gm) {
    _x = width / 2; _y = height * 3 / 4;
    sY = 0;
    jumping = false;
    g = 0.2;
    
    skin[0] = loadImage(_skin + "_idle_r.png");
    skin[1] = loadImage(_skin + "_idle_l.png");
    skin[2] = loadImage(_skin + "_run0_r.png");
    skin[3] = loadImage(_skin + "_run1_r.png");
    skin[4] = loadImage(_skin + "_run0_l.png");
    skin[5] = loadImage(_skin + "_run1_l.png");
    
    for (int s = 0; s < 6; s++) {
      int proportion = int(150 / skin[s].height);
      skin[s].resize(proportion * skin[s].width, 150);
    }
    
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
      _y -= sY;
    
      if (jumping) {
        sY -= g;
      }
    
      if (sY < 0 && jumping) {
        checkCollision();
      }
    }
  }
  
  public void display(int x_control) {    
    if (controlled && !gm && life != 0) {
      if (anim_tempo <= millis()) {
        anim_state = abs(anim_state - 1); /* passage infini de 0 à 1 ou de 1 à 0 */
        anim_tempo = millis() + 200; /* toute les 200 millisecondes une nouvelle anim apparait */
      }
      
      fill(0, 0, 255);
      textSize(20);
      text(name, width / 2, _y - 180);
      
      imageMode(CENTER);
      
      if (fw && walking) {
        image(skin[2 + anim_state], width / 2, _y - 75);
      }
      else if (fw && !walking) {
        image(skin[0], width / 2, _y - 75);
      }
      else if (!fw && walking) {
        image(skin[4 + anim_state], width / 2, _y - 75);
      }
      else if (!fw && !walking) {
        image(skin[1], width / 2, _y - 75);
      }
    }
    else if (!gm && life != 0) {
      fill(255);
      textSize(10);
      text(name, (_x - x_control) + (width / 2), _y - 40);
      
      fill(255);
      rect((_x - x_control) + (width / 2), _y, 40, 40);
    }
    
    if (!gm && controlled && life != 0) {
      imageMode(CENTER);
      if (life == 3) {
        image(heart, width / 2 - 20, _y - 165);
        image(heart, width / 2, _y - 165);
        image(heart, width / 2 + 20, _y - 165);
      }
      else if (life == 2) {
        image(heart, width / 2 - 20, _y - 165);
        image(heart, width / 2, _y - 165);
        image(skull, width / 2 + 20, _y - 165);
      }
      else if (life == 1) {
        image(heart, width / 2 - 20, _y - 165);
        image(skull, width / 2, _y - 165);
        image(skull, width / 2 + 20, _y - 165);
      }
      imageMode(CORNER);
    }
    
    if (life == 0) {
      //image game over in center
    }
  }
  
  public void checkCollision() {
    if (jumping) {
      if (_y > height * 3 / 4)  {
        sY = 0;
        jumping = false;
        _y = height * 3 / 4;
      }
    }
  }
}
