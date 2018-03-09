Client cl;
Server se;

void netSetup(boolean _cl, String ip) {
  if (_cl) {
    cl = new Client(this, ip, 19132);
  }
  else {
    se = new Server(this, 19132);
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
      msgs.add(tmp.readString() + ":" + tmp.ip());
      
      tmp = se.available();
    }
  }
  
  return msgs;
}