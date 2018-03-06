class TextField {
  
  boolean write;
  int[] x;
  int[] y;
  String fTxt;
  int[] fColor; /* 0 = fill / 1 = stroke */
  int state = 0; /* 0 = released / 1 = pressed */
  
  TextField(boolean _write, int[] _x, int[] _y, String _fTxt, int[] _fColor) {
    write = _write;
    x = _x; y = _y;
    fTxt = _fTxt;
    fColor = _fColor;
  }
  
  void display() {
    int xTmp, yTmp = 0;
    
    if (write) {
      /*=== Part for writing TextField ===*/
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
      
      textSize((y[2] - y[0]) / 5);
      strokeWeight(4);
      fill(fColor[3], fColor[4], fColor[5]);
      text(fTxt, xTmp, yTmp);
    }
  }
  
}