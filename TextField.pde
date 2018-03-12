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
  
  void display() {
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
        xTmp = int((x[2] - x[0]) / 2 + x[0]);
      }
      else {
        xTmp = int((x[1] - x[3]) / 2 + x[3]);
      }
      
      yTmp = int((y[2] - y[0]) / 2 + y[0]);
      
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
        xTmp = int((x[2] - x[0]) / 2 + x[0]);
      }
      else {
        xTmp = int((x[1] - x[3]) / 2 + x[3]);
      }
      
      yTmp = int((y[2] - y[0]) / 2 + y[0]);
      
      textSize((y[2] - y[0]) / 3);
      strokeWeight(4);
      fill(fColor[3], fColor[4], fColor[5]);
      text(fTxt, xTmp, yTmp);
    }
  }
  
  boolean checkState() {
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
    
    return boolean(state);
  }
  
  void setNewString(String newOne) {
    fTxt = newOne;
  }
  
  void addToString(String add) {
    fTxt += add;
  }
  
  void removeFromString(int number) {
    if (number > 0)
      fTxt = fTxt.substring(0, fTxt.length()-number);
  }
  
  String getCurString() {
    return fTxt;
  }
  
  void endEdit() {
    state = 0;
  }
  
}