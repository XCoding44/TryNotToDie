void menuDef() {
  int[] x_host = {int(width / 10), int(width * 9 / 20), int(width * 11 / 20), int(width / 10)};
  int[] y_host = {int(height * 4 / 10), int(height * 4 / 10), int(height * 6 / 10), int(height * 6 / 10)};
  int[] x_join = {int(width * 9 / 20), int(width * 9 / 10), int(width * 9 / 10), int(width * 11 / 20)};
  int[] c_menu = {255, 255, 255, 0, 100, 200};

  host = new Button(x_host, y_host, "Host a game", c_menu);
  join = new Button(x_join, y_host, "Join a game", c_menu);
  
  int[] x_test = {int(width / 10), int(width * 9 / 10), int(width * 9 / 10), int(width / 10)};
  int[] y_test = {int(height * 8 / 10), int(height * 8 / 10), height, height};
  int[] c_test = {255, 255, 255, 0, 100, 200};
  
  test = new TextField(false, x_test, y_test, "Yo Bro ! How're you today... I don't understand what you just said", c_test);
}