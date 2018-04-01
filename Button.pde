class Button {
  int[] x;
  int[] y;
  String bTxt;
  int[] bColor; /* 0 = fill / 1 = stroke */
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
  
  void display() {
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
      xTmp = int((x[2] - x[0]) / 2 + x[0]);
      yTmp = int((y[2] - y[0]) / 2 + y[0]);
    }
    else {
      xTmp = int((x[1] - x[3]) / 2 + x[3]);
      yTmp = int((y[2] - y[0]) / 2 + y[0]);
    }
    
    if (bTxt == "<<") {
      textSize((y[2] - y[0]) / 1.5);
    }
    else {
      textSize((y[2] - y[0]) / 3);
    }
    fill(bColor[3] - subColor, bColor[4] - subColor, bColor[5] - subColor);
    text(bTxt, xTmp, yTmp);
  }
  
  void checkState() {
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
            netSetup(false, ""); /* "String ip" not useful in this case because setup of Server */            
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
              cl.write("pseudo:"+joinF[1].getCurString());
            }
            else if (m1 == null) {
              joinF[2].fTxt = "Please enter a valid IP";
            }
            else if (m2 == null) {
              joinF[2].fTxt = "Please enter a valid name (letters and numbers only)";
            }
          break;
          
          case 4:
            if (NUM_PLAYER == int(hostC[0].getChoiceAsStr()) || key == 'p') {
              for (String tmpStr : NAMES) {
                se.write("pseudo:" + tmpStr);
              }
              
              STATE = action;
              se.write(":launch_game");
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
