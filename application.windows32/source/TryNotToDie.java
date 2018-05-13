import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.net.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class TryNotToDie extends PApplet {

/* GLOBAL */

int STATE = 0; /* 0 = main menu / 1 = host menu / 2 = join menu / 3 = connected to host / 4 = game */
int NUM_PLAYER = 0;
TextField activeTF;
ArrayList<String> NAMES = new ArrayList<String>();
ArrayList<Player> PLAYERS = new ArrayList<Player>();
int back_x = 0;
int LAST_SENT = 0;

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
Player c_player = null;

/* BACKGROUNDS */
PImage grass, sand, clouds;

/* PROGRAM START */
public void setup () {
  
  frameRate(60);
  textAlign(CENTER, CENTER);
  rectMode(CENTER);
  
  menuDef();
  
  grass = loadImage("grass.png");
  grass.resize(width / 2, height / 2);
  
  sand = loadImage("Sand.jpg");
  sand.resize(width / 2, height / 2);
  
  clouds = loadImage("Clouds.png");
  clouds.resize(width, height / 2);
}

public void draw() {
  background(0);
  imageMode(CORNER);
  
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
        
        if (tmpMsg.contains("pseudo:") && NUM_PLAYER < PApplet.parseInt(hostC[0].getChoiceAsStr())) {
          NUM_PLAYER++;
          
          tmpMsg = tmpMsg.substring(7);
          
          NAMES.add(tmpMsg);          
          PLAYERS.add(new Player(10, "JPC", tmpMsg, false, false));
          
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
    
    c_player = new Player(10, "JPC", joinF[1].getCurString(), true, false);
    
    ArrayList<String> msgs = getMsg(true);
    
    if (msgs.size() > 0) {
      
      for(int i = 0; i < msgs.size(); i++) {
        String tmpMsg = msgs.get(i);
        
        String[] splits = tmpMsg.split(":");
        
        if (tmpMsg.contains("launch_game")) {
          STATE = 4;
        }
        
        if (tmpMsg.contains("pseudo:") && !splits[1].equals(c_player.name)) {
          if (!splits[1].equals("gm")) {
            PLAYERS.add(new Player(10, "JPC", splits[1], false, false));
          }
          else {
            PLAYERS.add(new Player(10, "JPC", splits[1], false, true));
          }
        }
      }
    }
  }
  else if (STATE == 4) {
    if (c_player == null)
      c_player = new Player(10, "JPC", "gm", true, true);
    
    if (back_x == -width / 2) {
      back_x = 0;
    }
    else if (back_x == width / 2) {
      back_x = 0;
    }
    
    if (cl != null && c_player != null) {
      /* Le client envoit sa position au serveur */
      if (LAST_SENT + 50 <= millis()) {
        LAST_SENT = millis();
        sendMsg(true, "position:" + c_player._x + ":" + c_player._y + ":" + c_player.name + "-");
      }
      
      ArrayList<String> msgs = getMsg(true);
      
      for(String msg : msgs) {
        if (msg.contains("position:")) {
          
          String[] splits = msg.split(":");
          
          for (Player p : PLAYERS) {
            if (splits[3].equals(p.name) && PApplet.parseInt(splits[1]) != p._x) {
              p._x = PApplet.parseInt(splits[1]);
              p._y = PApplet.parseInt(splits[2]);
            }
          }
        }
        else if (msg.contains("trap:")) {
          String[] splits = msg.split(":");
          
          Objects.add(new DecorObj(PApplet.parseInt(splits[1]), splits[2], true));
        }
        else if (msg.contains("trap_open:")) {
          String[] splits = msg.split(":");
          
          Objects.get(PApplet.parseInt(splits[1])).opened = true;
        }
      }
    }
    else if (se != null && c_player != null) {
      if (LAST_SENT + 50 <= millis()) {
        LAST_SENT = millis();
        sendMsg(false, "position:" + c_player._x + ":" + c_player._y + ":" + c_player.name + "-");
      }
      
      ArrayList<String> msgs = getMsg(false);
      
      for(String msg : msgs) {
        if (msg.contains("position:")) {
          
          sendMsg(false, msg+"-");
          
          String[] splits = msg.split(":");
          
          for (Player p : PLAYERS) {
            if (splits[3].equals(p.name) && PApplet.parseInt(splits[1]) != p._x) {
              p._x = PApplet.parseInt(splits[1]);
              p._y = PApplet.parseInt(splits[2]);
            }
          }
        }
        else if (msg.contains("gagne")) {
          STATE = 5;
        }
      }
    }
    
    image(grass, back_x, height / 2);
    image(grass, width / 2 + back_x, height / 2);
    
    image(grass, back_x - (width / 2), height / 2);
     
    image(grass, back_x + width, height / 2);
    
    BackObjDisp(true);
    
    for(Player tmpP : PLAYERS) {
      if (!tmpP.name.equals("gm")) {
        tmpP.display(PApplet.parseInt(c_player._x));
      }
    }
    
    if (c_player != null) {
      c_player.display(0); /* 0 because not used in this method */
      c_player.move();
    }
    
    BackObjDisp(false);
    
    if (c_player._x >= 4600 && !c_player.gm) {
      STATE = 5;
      
      sendMsg(true, "gagne-");
    }
  }
  else if (STATE == 5) {
    String[] names = new String[5];
    
    if (!c_player.gm) {
      names[0] = c_player.name;
    }
    
    for (int i = 1; i < PLAYERS.size() + 1 ; i++) {
      if (!PLAYERS.get(i - 1).gm) {
        names[i] = PLAYERS.get(i - 1).name;
      }
    }
    
    menu(NUM_PLAYER, names);
  }
}

public void mousePressed() {
  if (STATE == 2) {
    for (int a = 0;  a < joinF.length - 1; a++) {
      if (joinF[a].checkState() && activeTF == null) {
        activeTF = joinF[a];
      }
    }
  }
}

public void keyPressed() {
  if (STATE == 2 && activeTF != null && keyCode != SHIFT && keyCode != CONTROL && keyCode != ALT && keyCode != TAB) {
    if (keyCode != BACKSPACE && keyCode != RETURN && keyCode != ENTER) {
      activeTF.addToString(str(key));
    }
    else if (keyCode == BACKSPACE && !activeTF.getCurString().equals("")) {
      activeTF.removeFromString(1);
    }
    else if (keyCode == RETURN || keyCode == ENTER) {
      activeTF.endEdit();
      activeTF = null;
    }
  }
  else if (STATE == 4) {
    boolean verification = verifyDist(PApplet.parseInt(PLAYERS.get(PLAYERS.size() - 1)._x));
    
    if (keyCode == RIGHT && verification) {
      c_player.walking = true;
      c_player.fw = true;
      c_player._x += 10;
      
      back_x -= 10;
    }
    else if (keyCode == LEFT) {
      c_player.walking = true;
      c_player.fw = false;
      c_player._x -= 10;
      
      back_x += 10;
    }
  }
}

public void keyReleased() {
  if (keyCode == RIGHT || keyCode == LEFT) {
    c_player._x += 0;
    c_player.walking = false;
  }
}

public boolean verifyDist(int player_x) {
  if (PApplet.parseBoolean(hostC[1].getChoiceAsInt()) && abs(player_x - c_player._x) >= width * 9 / 20) {
    return false;
  }
  else if (!PApplet.parseBoolean(hostC[1].getChoiceAsInt())) {
    return true;
  }
  else {
    return true;
  }
}
ArrayList<DecorObj> Objects = new ArrayList<DecorObj>();
int nextObjs = 1000;
int nextTrap = 0;

boolean ended = false;

public void BackObjDisp(boolean dispAtBack) { /* dispAtBack is to choose if the objects drawn by this function are at the background or not */
  DecorObj tmp = null;
  int xMin, xMax, yMin, yMax;
  
  for (int i = 0; i < Objects.size(); i++) {
    tmp = Objects.get(i);
    
    if (tmp.x <= PApplet.parseInt(c_player._x) - width * 3/2) {
      Objects.remove(i);
    }
    else if ((tmp.y < (height * 3 / 4) - 50 && dispAtBack) || (dispAtBack && tmp.trapObj) || (tmp.y >= (height * 3 / 4) - 50 && !dispAtBack && !tmp.trapObj) || (tmp.name == "Clouds" && !dispAtBack)) {
      tmp.display();
    }
    
    xMin = PApplet.parseInt(tmp.x - c_player._x - tmp.sX/2);
    xMax = PApplet.parseInt(tmp.x - c_player._x + tmp.sX/2);
    yMin = PApplet.parseInt(tmp.y - tmp.sY/2);
    yMax = PApplet.parseInt(tmp.y + tmp.sY/2);
    
    if (tmp.trapObj && mouseX >= xMin && mouseX <= xMax && mouseY >= yMin && mouseY <= yMax && mousePressed && c_player.gm) {
      tmp.opened = true;
      
      if (se != null) {
        sendMsg(false, "trap_open:" + i + "-");
      }
    }
  }
  
  if (c_player._x >= 3000 && !ended) {
    ended = true;
    Objects.add(new DecorObj(PApplet.parseInt(c_player._x) + width * 3 / 2, "Clouds", false)); /* Afficher les nuages de fin */
  }
  
  if (c_player._x >= nextObjs && !ended) {
    nextObjs = PApplet.parseInt(c_player._x + random(500, 1500));
    BackObjAdd();
  }
  
  if (c_player._x >= nextTrap && c_player.gm && !ended) {
    nextTrap = PApplet.parseInt(c_player._x + random(1000, 2000));
    TrapAdd();
  }
}

public void BackObjAdd() {
  int type = PApplet.parseInt(random(3));
  String name = "";
  
  switch(type) {
    case 0:
      name = "arbre";
    break;
    
    case 1:
      name = "buisson1";
    break;
    
    case 2:
      name = "buisson2";
    break;
    
    default:
      name = "buisson2";
    break;
  }
  
  Objects.add(new DecorObj(PApplet.parseInt(c_player._x) + width * 3 / 2, name, false));
}

public void TrapAdd() {
  int type = PApplet.parseInt(random(4));
  String name = "";
  
  switch(type) {
    case 0:
      name = "up_spikes";
    break;
    
    case 1:
      name = "down_spikes";
    break;
    
    case 2:
      name = "up_spikes";
    break;
    
    case 3:
      name = "down_spikes";
    break;
    
    default:
      name = "";
      break;
  }
  
  Objects.add(new DecorObj(PApplet.parseInt(c_player._x) + width * 3 / 2, name, true));
  
  if (se != null) {
    sendMsg(false, "trap:" + PApplet.parseInt(c_player._x + width * 3 / 2) + ":" + name + "-");
    println("sending...");
  }
}
class Button {
  int[] x;
  int[] y;
  String bTxt;
  int[] bColor;
  int action;
  int state = 0; /* 0 = released & !hovered / 1 = hovered / 2 = pressed */
  
  /*=== CONSTRUCTEURS ===*/
  Button(int[] _x, int[] _y, String _bTxt, int _action, int[] _bColor) {
    x = _x;
    y = _y;
    bTxt = _bTxt;
    action = _action;
    bColor = _bColor;
  }
  /*=== FIN CONSTRUCTEURS ===*/
  
  public void display() {
    int subColor = 0;
    
    if (state == 0) {
      subColor = 50;
    }
    
    strokeWeight(4);
    fill(bColor[0] - subColor, bColor[1] - subColor, bColor[2] - subColor);
    
    if (bTxt.equals("<<")) {
      noStroke();
    }
    else {
      stroke(bColor[3] - subColor, bColor[4] - subColor, bColor[5] - subColor);
    }
    
    quad(x[0], y[0], x[1], y[1], x[2], y[2], x[3], y[3]);
    
    int xTmp = 0; int yTmp = 0;
    
    if (x[2] - x[0] <= x[1] - x[3]) {
      xTmp = PApplet.parseInt((x[2] - x[0]) / 2 + x[0]);
      yTmp = PApplet.parseInt((y[2] - y[0]) / 2 + y[0]);
    }
    else {
      xTmp = PApplet.parseInt((x[1] - x[3]) / 2 + x[3]);
      yTmp = PApplet.parseInt((y[2] - y[0]) / 2 + y[0]);
    }
    
    if (bTxt == "<<") {
      textSize((y[2] - y[0]) / 1.5f);
    }
    else {
      textSize((y[2] - y[0]) / 3);
    }
    fill(bColor[3] - subColor, bColor[4] - subColor, bColor[5] - subColor);
    text(bTxt, xTmp, yTmp);
  }
  
  public void checkState() {
    int xMin, xMax, yMin, yMax = 0;
    
    if (x[2] - x[0] <= x[1] - x[3]) {
      xMin = x[0]; xMax = x[2];
    }
    else {
      xMin = x[3]; xMax = x[1];
    }
    
    if (y[2] - y[0] <= y[3] - y[1]) {
      yMin = y[0]; yMax = y[2];
    }
    else {
      yMin = y[1]; yMax = y[3];
    }
    
    if (mouseX > xMin && mouseX < xMax && mouseY > yMin && mouseY < yMax) {
      if (mousePressed) {
        state = 2;
        
        switch(action) {
          case 1:
            netSetup(false, ""); /* second argument "" not useful (but required) in this case because setup of Server */            
            STATE = action;
          break;
          
          case 2:
            STATE = action;
          break;
          
          case 3:
            String[] m1 = match(joinF[0].getCurString(), "^[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}$");
            String[] m2 = match(joinF[1].getCurString(), "^[a-zA-Z0-9]{1,20}$");
          
            if (m1 != null && m2 != null) {
              STATE = action;
              netSetup(true, joinF[0].getCurString());
              cl.write("pseudo:"+joinF[1].getCurString()+"-");
            }
            else if (m1 == null) {
              joinF[2].fTxt = "Please enter a valid IP";
            }
            else if (m2 == null) {
              joinF[2].fTxt = "Please enter a valid name (letters and numbers only)";
            }
          break;
          
          case 4:
            if (NUM_PLAYER == PApplet.parseInt(hostC[0].getChoiceAsStr()) || key == 'p') {
              for (String tmpStr : NAMES) {
                se.write("pseudo:" + tmpStr+"-");
                delay(200);
              }
              
              se.write("pseudo:gm-"); /* Here we send the game master pseudo so that the client creates the gm to do some actions after */
              delay(1000);
              
              STATE = action;
              se.write("launch_game-");
              LAST_SENT = millis();
            }
          break;
          
          default:
            STATE = action;
          break;
        }
      }
      else {
        state = 1;
      }
    }
    else {
      state = 0;
    }
  }
}
class ChoiceBox {
  
  int[] x;
  int[] y;
  String[] choices;
  PImage[] Ichoices;
  int[] cColor;
  int state = 1;
  boolean str_choices;
  
  ChoiceBox(int[] _x, int[] _y, String[] _choices, int[] _cColor) {
    x = _x;
    y = _y;
    choices = _choices;
    cColor = _cColor;
    str_choices = true;
  }
  
  ChoiceBox(int[] _x, int[] _y, PImage[] _choices, int[] _cColor) {
    x = _x;
    y = _y;
    Ichoices = _choices;
    cColor = _cColor;
    str_choices = false;
  }
  
  public void display() {
    if (str_choices) {
      int subColor;
      
      strokeWeight(4);
    
      for (int i = 1; i <= (x.length - 2)/2; i++) {
        if (i == state) {
          subColor = 0;
        }
        else {
          subColor = 50;
        }
      
        fill(cColor[0] - subColor, cColor[1] - subColor, cColor[2] - subColor);
        stroke(cColor[3] - subColor, cColor[4] - subColor, cColor[5] - subColor);
      
        quad(x[2*i-2], y[2*i-2], x[2*i], y[2*i], x[2*i+1], y[2*i+1], x[2*i-1], y[2*i-1]);
      
        int xTmp = 0; int yTmp = 0;
    
        if (x[2*i+1] - x[2*i-2] <= x[2*i] - x[2*i-1]) {
          xTmp = PApplet.parseInt((x[2*i+1] - x[2*i-2]) / 2 + x[2*i-2]);
          yTmp = PApplet.parseInt((y[2*i+1] - y[2*i-2]) / 2 + y[2*i-2]);
        }
        else {
          xTmp = PApplet.parseInt((x[2*i] - x[2*i-1]) / 2 + x[2*i-1]);
          yTmp = PApplet.parseInt((y[2*i+1] - y[2*i-2]) / 2 + y[2*i-2]);
        }
      
        textSize((y[2*i+1] - y[2*i-2]) / 3);
        fill(cColor[3] - subColor, cColor[4] - subColor, cColor[5] - subColor);
        text(choices[i-1], xTmp, yTmp);
      }
    }
    else {
      /* Show the imgs... */
    }
  }
  
  public void checkState() {
    for (int i = 1; i <= (x.length - 2)/2; i++) {
      int xMin, xMax, yMin, yMax = 0;
    
      if (x[2*i+1] - x[2*i-2] <= x[2*i] - x[2*i-1]) {
        xMin = x[2*i-2]; xMax = x[2*i+1];
      }
      else {
        xMin = x[2*i-1]; xMax = x[2*i];
      }
    
      if (y[2*i+1] - y[2*i-2] <= y[2*i-1] - y[2*i]) {
        yMin = y[2*i-2]; yMax = y[2*i+1];
      }
      else {
        yMin = y[2*i]; yMax = y[2*i-1];
      }
      
      if (mouseX > xMin && mouseX < xMax && mouseY > yMin && mouseY < yMax)
        if (mousePressed)
          state = i;
    }
  }
  
  public String getChoiceAsStr() {
    return choices[state - 1];
  }
  
  public int getChoiceAsInt() {
    return state-1;
  }

}
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
      y = PApplet.parseInt(height * 3 / 4);
      trap_img = loadImage(imgName + "_trap.png");
      proportion = (height/2) / trap_img.height;
      trap_img.resize(trap_img.width * proportion, height/2);
    }
    else if (imgName == "Clouds") {
      y = height / 2;
    }
    else {
      y = PApplet.parseInt(random(height / 80, height / 20) * 10) + PApplet.parseInt(height / 2);
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
  
  public void display() {    
    imageMode(CENTER);
    
    if (!opened) {
      image(img, x - c_player._x, y);
    }
    else {
      image(trap_img, x - c_player._x, y);
    }
  }
}
public void menu(int nbrP, String[] y) { /*variable classement joueur */

  strokeWeight(5);
  fill(89, 138, 229);
  stroke(51, 206, 255);
  quad(width * 1/20, height * 3/14 , width * 19/20, height * 3/14, width * 19/20, height * 11/35, width * 1/20, height * 11/35); /* rectangle 1er joueur */
  fill(0, 0, 0);
  textSize(16);
  text("1er joueur", width * 2/10, height * 19/70);
  text(y[0], width * 4/10, height * 19/70); /* le pseudo du 1er joueur */
  
  if (nbrP == 2) {
  strokeWeight(5);
  fill(89, 138, 229);
  stroke(51, 206, 255);
  quad(width * 1/20, height * 13/35, width * 19/20, height * 13/35, width * 19/20, height * 33/70, width * 1/20, height * 33/70); /* rectangle 2e joueur */
  fill(0, 0, 0);
  text("2e joueur", width * 2/10, height * 30/70);
  text(y[1], width * 4/10, height * 30/70);
  }
  else if (nbrP == 3) {
  strokeWeight(5);
  fill(89, 138, 229);
  stroke(51, 206, 255);
  quad(width * 1/20, height * 37/70, width * 19/20, height * 37/70, width * 19/20, height * 22/35, width * 1/20, height * 22/35); /* rectangle 3e joueur */
  fill(0, 0, 0);
  text("3e joueur", width * 2/10, height * 41/70);
  text(y[2], width * 4/10, height * 41/70);
  }
  else if (nbrP == 4) { /* si le nbr de joueur = 4 */
    strokeWeight(5);
    fill(89, 138, 229);
    stroke(51, 206, 255);
    quad(width * 1/20, height * 24/35, width * 19/20, height * 24/35, width * 19/20, height * 11/14, width * 1/20, height * 11/14); /* rectangle 4e joueur */
    fill(0, 0, 0);
    text("4e joueur", width * 2/10, height * 52/70);
    text(y[3], height * 4/10, height * 52/70);
  } 
  else if (nbrP == 5) { /* si le nbr de joueur = 5 */
    strokeWeight(5);
    fill(89, 138, 229);
    stroke(51, 206, 255);
    quad(width * 1/20, height * 24/35, width * 19/20, height * 24/35, width * 19/20, height * 11/14, width * 1/20, height * 11/14); /* rectangle 4e joueur */
    fill(0, 0, 0);
    text("4e joueur", width * 2/10, height * 52/70);
    text(y[3], height * 4/10, height * 52/70);

    strokeWeight(5);
    fill(89, 138, 229);
    stroke(51, 206, 255);
    quad(width * 1/20, height * 59/70, width * 19/20, height * 59/70, width * 19/20, height * 33/35, width * 1/20, height * 33/35); /* rectangle 5e joueur */
    fill(0, 0, 0);
    text("5e joueur", width * 2/10, height * 63/70);
    text(y[4], width * 4/10, height * 63/70);
  }
}
public void menuDef() {
  /* MAIN MENU */  
  int[] x_host = {PApplet.parseInt(width / 10), PApplet.parseInt(width * 9 / 20), PApplet.parseInt(width * 11 / 20), PApplet.parseInt(width / 10)};
  int[] y_host = {PApplet.parseInt(height * 4 / 10), PApplet.parseInt(height * 4 / 10), PApplet.parseInt(height * 6 / 10), PApplet.parseInt(height * 6 / 10)};
  int[] x_join = {PApplet.parseInt(width * 9 / 20), PApplet.parseInt(width * 9 / 10), PApplet.parseInt(width * 9 / 10), PApplet.parseInt(width * 11 / 20)};
  int[] c_menu = {255, 255, 255, 0, 100, 200};

  menuB = new Button[2];
  menuB[0] = new Button(x_host, y_host, "Host a game", 1, c_menu);
  menuB[1] = new Button(x_join, y_host, "Join a game", 2, c_menu);
  
  /* RETURN BUTTON */
  int[] x_return = {0, PApplet.parseInt(width / 20), PApplet.parseInt(width / 20), 0};
  int[] y_return = {0, 0, PApplet.parseInt(height / 20), PApplet.parseInt(height / 20)};
  int[] c_return = {255, 0, 0, 255, 255, 255};
  
  homeReturn = new Button(x_return, y_return, "<<", 0, c_return);
  
  /* HOST MENU */
  int[] x_launch = {PApplet.parseInt(width * 7 / 20), PApplet.parseInt(width * 14 / 20), PApplet.parseInt(width * 13 / 20), PApplet.parseInt(width * 6 / 20)};
  int[] y_launch = {PApplet.parseInt(height * 9 / 10), PApplet.parseInt(height * 9 / 10), height, height};
  int[] c_host = {255, 255, 255, 0, 200, 0};
  
  hostB = new Button(x_launch, y_launch, "Launch the Game !", 4, c_host);
  
  int[] x_player = {PApplet.parseInt(width * 3 / 10), PApplet.parseInt(width * 3 / 10), PApplet.parseInt(width * 21 / 40), PApplet.parseInt(width * 19 / 40), PApplet.parseInt(width * 29 / 40), PApplet.parseInt(width * 27 / 40), PApplet.parseInt(width * 9 / 10), PApplet.parseInt(width * 9 / 10)};
  int[] y_player = {PApplet.parseInt(height * 3 / 20), PApplet.parseInt(height * 5 / 20), PApplet.parseInt(height * 3 / 20), PApplet.parseInt(height * 5 / 20), PApplet.parseInt(height * 3 / 20), PApplet.parseInt(height * 5 / 20), PApplet.parseInt(height * 3 / 20), PApplet.parseInt(height * 5 / 20)};
  String[] ch_player = {"3", "4", "5"};
  
  int[] x_mode = {PApplet.parseInt(width * 3 / 10), PApplet.parseInt(width * 3 / 10), PApplet.parseInt(width * 25 / 40), PApplet.parseInt(width * 23 / 40), PApplet.parseInt(width * 9 / 10), PApplet.parseInt(width * 9 / 10)};
  int[] y_mode = {PApplet.parseInt(height * 6 / 20), PApplet.parseInt(height * 8 / 20), PApplet.parseInt(height * 6 / 20), PApplet.parseInt(height * 8 / 20), PApplet.parseInt(height * 6 / 20), PApplet.parseInt(height * 8 / 20)};
  String[] ch_mode = {"Free-for-all", "Cooperation"};
  
  hostC = new ChoiceBox[2];
  hostC[0] = new ChoiceBox(x_player, y_player, ch_player, c_host);
  hostC[1] = new ChoiceBox(x_mode, y_mode, ch_mode, c_host);
  
  int[] x_ip = {PApplet.parseInt(width / 2 - 10), PApplet.parseInt(width / 2 + 10), PApplet.parseInt(width / 2 + 10), PApplet.parseInt(width / 2 - 10)};
  int[] y_ip = {0, 0, PApplet.parseInt(height / 10), PApplet.parseInt(height / 10)};
  
  int[] x_lbl_play = {PApplet.parseInt(width / 5 - 10), PApplet.parseInt(width / 5 + 10), PApplet.parseInt(width / 5 + 10), PApplet.parseInt(width / 5 - 10)};
  int[] y_lbl_play = {PApplet.parseInt(height * 3 / 20), PApplet.parseInt(height * 3 / 20), PApplet.parseInt(height * 5 / 20), PApplet.parseInt(height * 5 / 20)};
  
  int[] x_lbl_mode = {PApplet.parseInt(width / 5 - 10), PApplet.parseInt(width / 5 + 10), PApplet.parseInt(width / 5 + 10), PApplet.parseInt(width / 5 - 10)};
  int[] y_lbl_mode = {PApplet.parseInt(height * 6 / 20), PApplet.parseInt(height * 6 / 20), PApplet.parseInt(height * 8 / 20), PApplet.parseInt(height * 8 / 20)};
  
  int[] x_play_list = {PApplet.parseInt(width * 3 / 5 - 10), PApplet.parseInt(width * 3 / 5 + 10), PApplet.parseInt(width * 3 / 5 + 10), PApplet.parseInt(width * 3 / 5 - 10)};
  int[] y_play_list = {PApplet.parseInt(height * 23 / 40), PApplet.parseInt(height * 23 / 40), PApplet.parseInt(height * 29 / 40), PApplet.parseInt(height * 29 / 40)};
  
  int[] x_lbl_list = {PApplet.parseInt(width / 5 - 10), PApplet.parseInt(width / 5 + 10), PApplet.parseInt(width / 5 + 10), PApplet.parseInt(width / 5 - 10)};
  int[] y_lbl_list = {PApplet.parseInt(height * 12 / 20), PApplet.parseInt(height * 12 / 20), PApplet.parseInt(height * 14 / 20), PApplet.parseInt(height * 14 / 20)};
  
  hostF = new TextField[5];
  hostF[0] = new TextField(false, x_ip, y_ip, "NONE", c_host);
  hostF[1] = new TextField(false, x_lbl_play, y_lbl_play, "Number of players", c_host);
  hostF[2] = new TextField(false, x_lbl_mode, y_lbl_mode, "Type of battle", c_host);
  hostF[3] = new TextField(false, x_play_list, y_play_list, "", c_host);
  hostF[4] = new TextField(false, x_lbl_list, y_lbl_list, "Connected players", c_host);
  
  /* JOIN MENU */
  int[] x_join_ip = {PApplet.parseInt(width * 5 / 20), PApplet.parseInt(width * 16 / 20), PApplet.parseInt(width * 15 / 20), PApplet.parseInt(width * 4 / 20)};
  int[] y_join_ip = {0, 0, PApplet.parseInt(height / 10), PApplet.parseInt(height / 10)};
  int[] c_join = {255, 255, 255, 200, 0, 0};
  
  int[] x_name = {PApplet.parseInt(width * 5 / 20), PApplet.parseInt(width * 16 / 20), PApplet.parseInt(width * 15 / 20), PApplet.parseInt(width * 4 / 20)};
  int[] y_name = {PApplet.parseInt(height * 3 / 20), PApplet.parseInt(height * 3 / 20), PApplet.parseInt(height * 5 / 20), PApplet.parseInt(height * 5 / 20)};
  
  int[] x_error = {PApplet.parseInt(width / 2 - 10), PApplet.parseInt(width / 2 + 10), PApplet.parseInt(width / 2 + 10), PApplet.parseInt(width / 2 - 10)};
  int[] y_error = {PApplet.parseInt(height * 8 / 10), PApplet.parseInt(height * 8 / 10), PApplet.parseInt(height * 9 / 10), PApplet.parseInt(height * 9 / 10)};
  
  int[] x_waiting = {PApplet.parseInt(width / 2 - 10), PApplet.parseInt(width / 2 + 10), PApplet.parseInt(width / 2 + 10), PApplet.parseInt(width / 2 - 10)};
  int[] y_waiting = {PApplet.parseInt(height * 4 / 10), PApplet.parseInt(height * 4 / 10), PApplet.parseInt(height * 6 / 10), PApplet.parseInt(height * 6 / 10)};
  
  joinF = new TextField[4];
  joinF[0] = new TextField(true, x_join_ip, y_join_ip, "> Host IP <", c_join);
  joinF[1] = new TextField(true, x_name, y_name, "> Your name <", c_join);
  joinF[2] = new TextField(false, x_error, y_error, "", c_join);
  joinF[3] = new TextField(false, x_waiting, y_waiting, "Waiting for host...", c_join);
  
  int[] x_connect = {PApplet.parseInt(width * 7 / 20), PApplet.parseInt(width * 14 / 20), PApplet.parseInt(width * 13 / 20), PApplet.parseInt(width * 6 / 20)};
  int[] y_connect = {PApplet.parseInt(height * 9 / 10), PApplet.parseInt(height * 9 / 10), height, height};
  
  joinB = new Button(x_connect, y_connect, "Connect to the host !", 3, c_join);
}
Client cl = null;
Server se = null;

public void netSetup(boolean _cl, String ip) {
  if (_cl) {
    println("Client created ");
    cl = new Client(this, ip, 19132);
  }
  else {
    println("Server created ");
    se = new Server(this, 19132);
    hostF[0].fTxt = se.ip();
  }
}

public void sendMsg(boolean _cl, String message) {
  if (_cl) {
    cl.write(message);
  }
  else {
    se.write(message);
  }
}
  
public ArrayList<String> getMsg(boolean _cl) {
  ArrayList<String> msgs = new ArrayList<String>();
  
  if (_cl) {
    while(cl.available() > 0) {
      String tmpStr = cl.readStringUntil('-');
      
      if (tmpStr != null && !tmpStr.equals("")) {
        tmpStr = tmpStr.substring(0, tmpStr.length() - 1); 
        msgs.add(tmpStr);
      }
    }
  }
  else {
    Client tmp = se.available();
    
    while(tmp != null) {
      String tmpStr = tmp.readStringUntil('-');
      
      if (tmpStr != null && !tmpStr.equals("")) {
        tmpStr = tmpStr.substring(0, tmpStr.length() - 1);
        msgs.add(tmpStr);
      }
      
      tmp = se.available();
    }
  }
  
  return msgs;
}
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
  
  Player(float _g, String _skin, String _name, boolean control, boolean _gm) {
    _x = width / 2; _y = height * 3 / 4;
    sY = 0;
    jumping = false;
    g = _g;
    
    skin[0] = loadImage(_skin + "_idle_r.png");
    skin[1] = loadImage(_skin + "_idle_l.png");
    skin[2] = loadImage(_skin + "_run0_r.png");
    skin[3] = loadImage(_skin + "_run1_r.png");
    skin[4] = loadImage(_skin + "_run0_l.png");
    skin[5] = loadImage(_skin + "_run1_l.png");
    
    for (int s = 0; s < 6; s++) {
      int proportion = PApplet.parseInt(150 / skin[s].height);
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
      if (anim_tempo <= millis()) {
        anim_state = abs(anim_state - 1); /* passage infini de 0 à 1 ou de 1 à 0 */
        anim_tempo = millis() + 200; /* toute les 200 millisecondes une nouvelle anim apparait */
      }
      
      fill(0, 0, 255);
      textSize(20);
      text(name, width / 2, _y - 180);
      
      imageMode(CENTER);
      
      if (fw && walking) {
        image(skin[2 + anim_state], width / 2, height * 3 / 4 - 75);
      }
      else if (fw && !walking) {
        image(skin[0], width / 2, height * 3 / 4 - 75);
      }
      else if (!fw && walking) {
        image(skin[4 + anim_state], width / 2, height * 3 / 4 - 75);
      }
      else if (!fw && !walking) {
        image(skin[1], width / 2, height * 3 / 4 - 75);
      }
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
class TextField {
  
  boolean write;
  int[] x;
  int[] y;
  String fTxt;
  String placeHolder;
  int[] fColor; /* 0 = fill / 1 = stroke */
  int state = 0; /* 0 = released / 1 = pressed */
  
  TextField(boolean _write, int[] _x, int[] _y, String _fTxt, int[] _fColor) {
    write = _write;
    x = _x; y = _y;
    
    if (_write) {
      fTxt = "";
      placeHolder = _fTxt;
    }
    else {
      fTxt = _fTxt;
    }
    
    fColor = _fColor;
  }
  
  public void display() {
    int xTmp, yTmp = 0;
    
    if (write) {
      /*=== Part for writing TextField ===*/
      int subColor = 0;
    
      if (state == 0)
        subColor = 50;
          
      strokeWeight(4);
      fill(fColor[0] - subColor, fColor[1] - subColor, fColor[2] - subColor);
      stroke(fColor[3] - subColor, fColor[4] - subColor, fColor[5] - subColor);
      quad(x[0], y[0], x[1], y[1], x[2], y[2], x[3], y[3]);
      
      if (x[2] - x[0] <= x[1] - x[3]) {
        xTmp = PApplet.parseInt((x[2] - x[0]) / 2 + x[0]);
      }
      else {
        xTmp = PApplet.parseInt((x[1] - x[3]) / 2 + x[3]);
      }
      
      yTmp = PApplet.parseInt((y[2] - y[0]) / 2 + y[0]);
      
      textSize((y[2] - y[0]) / 3);
      strokeWeight(4);
      fill(fColor[3], fColor[4], fColor[5]);
      
      if (fTxt.equals("") && state == 0) {
        text(placeHolder, xTmp, yTmp);
      }
      else {
        text(fTxt, xTmp, yTmp);
      }
    }
    else {
      /*=== Part for display TextField ===*/
      if (x[2] - x[0] <= x[1] - x[3]) {
        xTmp = PApplet.parseInt((x[2] - x[0]) / 2 + x[0]);
      }
      else {
        xTmp = PApplet.parseInt((x[1] - x[3]) / 2 + x[3]);
      }
      
      yTmp = PApplet.parseInt((y[2] - y[0]) / 2 + y[0]);
      
      textSize((y[2] - y[0]) / 3);
      strokeWeight(4);
      fill(fColor[3], fColor[4], fColor[5]);
      text(fTxt, xTmp, yTmp);
    }
  }
  
  public boolean checkState() {
    int xMin, xMax = 0;
    
    if (x[2] - x[0] <= x[1] - x[3]) {
      xMin = x[0]; xMax = x[2];
    }
    else {
      xMin = x[3]; xMax = x[1];
    }
    
    if (mouseX > xMin && mouseX < xMax && mouseY > y[0] && mouseY < y[3]) {
      state = 1;
    }
    else {
      state = 0;
    }
    
    return PApplet.parseBoolean(state);
  }
  
  public void setNewString(String newOne) {
    fTxt = newOne;
  }
  
  public void addToString(String add) {
    fTxt += add;
  }
  
  public void removeFromString(int number) {
    if (number > 0)
      fTxt = fTxt.substring(0, fTxt.length()-number);
  }
  
  public String getCurString() {
    return fTxt;
  }
  
  public void endEdit() {
    state = 0;
  }
  
}
  public void settings() {  size(1200, 600); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "TryNotToDie" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
