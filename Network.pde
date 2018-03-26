Client cl = null;
Server se = null;

void netSetup(boolean _cl, String ip) {
  if (_cl) {
    cl = new Client(this, ip, 19132);
  }
  else {
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
      msgs.add(cl.readString());
    }
  }
  else {
    Client tmp = se.available();
    
    while(tmp != null) {
      msgs.add(tmp.readString());
      
      tmp = se.available();
    }
  }
  
  return msgs;
}
