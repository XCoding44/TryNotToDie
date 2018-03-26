/* GLOBAL */
import processing.net.*;
int STATE = 0; /* 0 = main menu / 1 = host menu / 2 = join menu / 3 = connected to host / 4 = game */
int NUM_PLAYER = 0;
TextField activeTF;
ArrayList<String> NAMES = new ArrayList<String>();
ArrayList<Player> PLAYERS = new ArrayList<Player>();
int back_x = 0;

/* MAIN MENU */
Button[] menuB; /* One for the host menu, the other one for the join menu */

/* RETURN BUTTON */
Button homeReturn;

/* HOST MENU */
Button hostB; /* Only one to launch the game */
ChoiceBox[] hostC; /* One for the number of players, an other for the game mode */
TextField[] hostF; /* One for the ip (display), three other for the labels, one for the list of players */

/* JOIN MENU */
TextField[] joinF; /* One for the ip, the other one for the name, the last one for the waiting screen */
Button joinB; /* Only one to connect to the host */

/* PLAYER */
Player c_player;

/* BACKGROUNDS */
PImage grass;
PImage smile;

/* PROGRAM START */
void setup () {
  size(1200, 600);
  frameRate(60);
  textAlign(CENTER, CENTER);
  rectMode(CENTER);
  
  menuDef();
  
  grass = loadImage("data/grass.png");
  grass.resize(width / 2, height / 2);
  
  smile = loadImage("data/Smile-icon-tmp.png");
  smile.resize(40, 40);
}

void draw() {
  background(0);
  println(STATE);
  
  if (STATE == 0) {
    for(int i = 0; i < menuB.length; i++) {
      menuB[i].display();
      menuB[i].checkState();
    }
  }
  else if (STATE == 1) {
    hostB.display();
    hostB.checkState();
    
    homeReturn.display();
    homeReturn.checkState();
    
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
          tmpMsg = tmpMsg.substring(7);
          
          NAMES.add(tmpMsg);
          hostF[3].setNewString(hostF[3].getCurString() + tmpMsg + "\n");
        }
      }
    }
  }
  else if(STATE == 2) {
    for(int i = 0; i < joinF.length - 1; i++) {
      joinF[i].display();
    }
    
    joinB.display();
    joinB.checkState();
    
    homeReturn.display();
    homeReturn.checkState();
  }
  else if (STATE == 3) {
    joinF[3].display();
    
    c_player = new Player(10, smile, joinF[1].getCurString(), true);
    
    ArrayList<String> msgs = getMsg(true);
    
    if (msgs.size() > 0) {
      
      for(int i = 0; i < msgs.size(); i++) {
        String tmpMsg = msgs.get(i);
        
        if (tmpMsg.equals("launch_game")) {
          STATE = 4;
        }
        else if (tmpMsg.contains("pseudo:")) {
          PLAYERS.add(new Player(10, smile, tmpMsg.substring(7), false));
        }
      }
    }
  }
  else if (STATE == 4) {
    if (back_x == -width / 2) {
      back_x = 0;
    }
    else if (back_x == width / 2) {
      back_x = 0;
    }
    
    if (cl != null) {
      /* Le client envoit sa position au serveur */      
      sendMsg(true, "position:" + c_player._x + ":" + c_player._y + ":" + c_player.name);
      
      ArrayList<String> msgs = getMsg(true);
      
      for(String msg : msgs) {
        if (msg.contains("position:")) {
          String[] splits = msg.split(":");
          
          for (Player p : PLAYERS) {
            if (splits[3].equals(p.name)) {
              p._x = int(splits[1]);
              p._y = int(splits[2]);
            }
          }
        }
      }
    }
    else if (se != null) {
      sendMsg(false, "position:" + c_player._x + ":" + c_player._y + ":" + c_player.name);
      
      ArrayList<String> msgs = getMsg(true);
      
      for(String msg : msgs) {
        if (msg.contains("position:")) {
          sendMsg(false, msg);
          
          String[] splits = msg.split(":");
          
          for (Player p : PLAYERS) {
            if (splits[3].equals(p.name)) {
              p._x = int(splits[1]);
              p._y = int(splits[2]);
            }
          }
        }
      }
    }
    
    image(grass, back_x, height / 2);
    image(grass, width / 2 + back_x, height / 2);
    
    image(grass, back_x - (width / 2), height / 2);
     
    image(grass, back_x + width, height / 2);
    
    c_player.display(0); /* 0 because not used in this method */
    c_player.move();
  }
}

void mousePressed() {
  if (STATE == 2) {
    for (int a = 0;  a < joinF.length - 1; a++) {
      if (joinF[a].checkState() && activeTF == null) {
        activeTF = joinF[a];
      }
    }
  }
}

void keyPressed() {
  if (STATE == 2 && activeTF != null && keyCode != SHIFT && keyCode != CONTROL && keyCode != ALT && keyCode != TAB) {
    if (keyCode != BACKSPACE && keyCode != RETURN && keyCode != ENTER) {
      activeTF.addToString(str(key));
    }
    else if (keyCode == BACKSPACE) {
      activeTF.removeFromString(1);
    }
    else if (keyCode == RETURN || keyCode == ENTER) {
      activeTF.endEdit();
      activeTF = null;
    }
  }
  else if (STATE == 4) {
    if (keyCode == RIGHT) {
      if (c_player.sX != 5)
        c_player.sX = 5;
      
      back_x -= 5;
    }
    else if (keyCode == LEFT) {
      if (c_player.sX != -5)
        c_player.sX = -5;
      
      back_x += 5;
    }
  }
}

void keyReleased() {
  if (keyCode == RIGHT || keyCode == LEFT) {
    c_player.sX = 0;
  }
}
