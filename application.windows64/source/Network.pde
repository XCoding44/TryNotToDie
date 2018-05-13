Client cl = null;
Server se = null;

void netSetup(boolean _cl, String ip) {
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

void sendMsg(boolean _cl, String message) {
  if (_cl) {
    cl.write(message);
  }
  else {
    se.write(message);
  }
}
  
ArrayList<String> getMsg(boolean _cl) {
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
