ArrayList<DecorObj> Objects = new ArrayList<DecorObj>();
int nextObjs = 1000;
int nextTrap = 0;

boolean ended = false;

void BackObjDisp(boolean dispAtBack) { /* dispAtBack is to choose if the objects drawn by this function are at the background or not */
  DecorObj tmp = null;
  int xMin, xMax, yMin, yMax;
  
  for (int i = 0; i < Objects.size(); i++) {
    tmp = Objects.get(i);
    
    if (tmp.x <= int(c_player._x) - width * 3/2) {
      Objects.remove(i);
    }
    else if ((tmp.y < (height * 3 / 4) - 50 && dispAtBack) || (dispAtBack && tmp.trapObj) || (tmp.y >= (height * 3 / 4) - 50 && !dispAtBack && !tmp.trapObj) || (tmp.name == "Clouds" && !dispAtBack)) {
      tmp.display();
    }
    
    xMin = int(tmp.x - c_player._x - tmp.sX/2);
    xMax = int(tmp.x - c_player._x + tmp.sX/2);
    yMin = int(tmp.y - tmp.sY/2);
    yMax = int(tmp.y + tmp.sY/2);
    
    if (tmp.trapObj && mouseX >= xMin && mouseX <= xMax && mouseY >= yMin && mouseY <= yMax && mousePressed && c_player.gm) {
      tmp.opened = true;
      
      if (se != null) {
        sendMsg(false, "trap_open:" + i + "-");
      }
    }
  }
  
  if (c_player._x >= 2000 && !ended) {
    ended = true;
    Objects.add(new DecorObj(int(c_player._x) + width * 3 / 2, "Clouds", false)); /* Afficher les nuages de fin */
  }
  
  if (c_player._x >= nextObjs && !ended) {
    nextObjs = int(c_player._x + random(500, 1500));
    BackObjAdd();
  }
  
  if (c_player._x >= nextTrap && c_player.gm && !ended) {
    nextTrap = int(c_player._x + random(1000, 2000));
    TrapAdd();
  }
}

void BackObjAdd() {
  int type = int(random(3));
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
  
  Objects.add(new DecorObj(int(c_player._x) + width * 3 / 2, name, false));
}

void TrapAdd() {
  int type = int(random(4));
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
  
  Objects.add(new DecorObj(int(c_player._x) + width * 3 / 2, name, true));
  
  if (se != null) {
    sendMsg(false, "trap:" + int(c_player._x + width * 3 / 2) + ":" + name + "-");
    println("sending...");
  }
}