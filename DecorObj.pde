class DecorObj {
  int x, y;
  int sX, sY;
  
  String name;
  
  PImage img;
  PImage trap_img;
  boolean trapObj;
  boolean opened = false;
  
  DecorObj(int new_x, String imgName, boolean trap) {
    trapObj = trap;
    x = new_x;
    int proportion = 0;
    
    name = imgName;
    
    if (trap) {
      y = int(height * 3 / 4);
      trap_img = loadImage(imgName + "_trap.png");
      proportion = (height/2) / trap_img.height;
      trap_img.resize(trap_img.width * proportion, height/2);
    }
    else if (imgName == "Clouds") {
      y = height / 2;
    }
    else {
      y = int(random(height / 80, height / 20) * 10) + int(height / 2);
    }
    
    img = loadImage(imgName + ".png");
    
    if (imgName == "arbre") {
      proportion = (height / 3) / img.height;
      img.resize(img.width * proportion, height / 3);
    }
    else if (imgName == "Clouds") {
      img.resize(width * 2, height * 2);
    }
    else {
      proportion = (height / 6) / img.height;
      img.resize(img.width * proportion, height / 6);
    }
    
    sX = img.width;
    sY = img.height;
  }
  
  void display() {    
    imageMode(CENTER);
    
    if (!opened) {
      image(img, x - c_player._x, y);
    }
    else {
      image(trap_img, x - c_player._x, y);
    }
  }
}