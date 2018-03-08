class ChoiceBox {
  
  int[] x;
  int[] y;
  String[] choices;
  int[] cColor;
  int state = 1;
  
  ChoiceBox(int[] _x, int[] _y, String[] _choices, int[] _cColor) {
    x = _x;
    y = _y;
    choices = _choices;
    cColor = _cColor;
  }
  
  void display() {
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
        xTmp = int((x[2*i+1] - x[2*i-2]) / 2 + x[2*i-2]);
        yTmp = int((y[2*i+1] - y[2*i-2]) / 2 + y[2*i-2]);
      }
      else {
        xTmp = int((x[2*i] - x[2*i-1]) / 2 + x[2*i-1]);
        yTmp = int((y[2*i+1] - y[2*i-2]) / 2 + y[2*i-2]);
      }
      
      textSize((y[2*i+1] - y[2*i-2]) / 3);
      fill(cColor[3] - subColor, cColor[4] - subColor, cColor[5] - subColor);
      text(choices[i-1], xTmp, yTmp);
    }
  }
  
  void checkState() {
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
  
  String getChoiceAsStr() {
    return choices[state - 1];
  }
  
  int getChoiceAsInt() {
    return state-1;
  }

}