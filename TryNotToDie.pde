/* GLOBAL */
import processing.net.*;
int STATE = 0; /* 0 = main menu / 1 = host menu / 2 = join menu / 3 = connected to host / 4 = game */

/* MAIN MENU */
Button[] menuB;

/* HOST MENU */
Button hostB;
ChoiceBox test;
TextField[] hostF;

/* JOIN MENU */
Button[] joinB;

/* PROGRAM START */
void setup () {
  size(1200, 600);
  frameRate(20);
  textAlign(CENTER, CENTER);
  
  menuDef();
}

void draw() {
  background(0);
  
  if (STATE == 0) {
    for(int i = 0; i < menuB.length; i++) {
      menuB[i].display();
      menuB[i].checkState();
    }
  }
  else if (STATE == 1) {
    hostB.display();
    hostB.checkState();
    
    test.display();
    test.checkState();
    
    println("TEST : " + test.getChoiceAsStr() + " / " + test.getChoiceAsInt());
    
    for(int i = 0; i < menuB.length; i++) {
      hostF[i].display();
    }
  }
}