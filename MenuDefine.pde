void menuDef() {
  /* MAIN MENU */  
  int[] x_host = {int(width / 10), int(width * 9 / 20), int(width * 11 / 20), int(width / 10)};
  int[] y_host = {int(height * 4 / 10), int(height * 4 / 10), int(height * 6 / 10), int(height * 6 / 10)};
  int[] x_join = {int(width * 9 / 20), int(width * 9 / 10), int(width * 9 / 10), int(width * 11 / 20)};
  int[] c_menu = {255, 255, 255, 0, 100, 200};

  menuB = new Button[2];
  menuB[0] = new Button(x_host, y_host, "Host a game", 1, c_menu);
  menuB[1] = new Button(x_join, y_host, "Join a game", 2, c_menu);
  
  /* HOST MENU */
  int[] x_launch = {int(width * 7 / 20), int(width * 14 / 20), int(width * 13 / 20), int(width * 6 / 20)};
  int[] y_launch = {int(height * 9 / 10), int(height * 9 / 10), height, height};
  int[] c_host = {255, 255, 255, 0, 200, 0};
  
  hostB = new Button(x_launch, y_launch, "Launch the Game !", 3, c_host);
  
  int[] x_test = {int(width / 10), int(width / 10), int(width * 4 / 10), int(width * 1 / 3), int(width * 2 / 3), int(width * 6 / 10), int(width * 9 / 10), int(width * 9 / 10)};
  int[] y_test = {int(height * 3 / 20), int(height * 5 / 20), int(height * 3 / 20), int(height * 5 / 20), int(height * 3 / 20), int(height * 5 / 20), int(height * 3 / 20), int(height * 5 / 20)};
  String[] ch_test = {"Choose ME !", "No ! Me !", "OH ! Yes !"};
  
  test = new ChoiceBox(x_test, y_test, ch_test, c_host);
  
  int[] x_ip = {int(width / 2 - 10), int(width / 2 + 10), int(width / 2 + 10), int(width / 2 - 10)};
  int[] y_ip = {0, 0, int(height / 10), int(height / 10)};
  
  hostF = new TextField[2];
  hostF[0] = new TextField(false, x_ip, y_ip, "127.0.0.1", c_host);
  hostF[1] = new TextField(false, x_ip, y_ip, "127.0.0.1", c_host);
}