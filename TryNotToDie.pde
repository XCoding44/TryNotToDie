/* GLOBAL */
import processing.net.*;
int STATE = 0; /* 0 = main menu / 1 = host menu / 2 = join menu / 3 = connected to host / 4 = game */
int NUM_PLAYER = 0;
ArrayList<String> NAMES = new ArrayList<String>();

/* MAIN MENU */
Button[] menuB;

/* HOST MENU */
Button hostB;
ChoiceBox[] hostC;
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
    
    for(int i = 0; i < hostF.length; i++) {
      hostF[i].display();
    }
    
    for(int i = 0; i < hostC.length; i++) {
      hostC[i].display();
      hostC[i].checkState();
    }
    
    ArrayList<String> msgs = getMsg(false);
    
    if (msgs.size() > 0) {
      
      for(int i = 0; i < msgs.size(); i++) {
        String tmpMsg = msgs.get(i);
        
        if (tmpMsg.contains("pseudo:") && NUM_PLAYER < int(hostC[0].getChoiceAsStr())) {
          NUM_PLAYER++;
          println(tmpMsg);
          tmpMsg = tmpMsg.substring(7);
          
          NAMES.add(tmpMsg);
          hostF[3].setNewString(hostF[3].getCurString() + tmpMsg + "\n");
        }
      }
    }
  }
}