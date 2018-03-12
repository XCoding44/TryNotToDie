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
  
  hostB = new Button(x_launch, y_launch, "Launch the Game !", 4, c_host);
  
  int[] x_player = {int(width * 3 / 10), int(width * 3 / 10), int(width * 21 / 40), int(width * 19 / 40), int(width * 29 / 40), int(width * 27 / 40), int(width * 9 / 10), int(width * 9 / 10)};
  int[] y_player = {int(height * 3 / 20), int(height * 5 / 20), int(height * 3 / 20), int(height * 5 / 20), int(height * 3 / 20), int(height * 5 / 20), int(height * 3 / 20), int(height * 5 / 20)};
  String[] ch_player = {"3", "4", "5"};
  
  int[] x_mode = {int(width * 3 / 10), int(width * 3 / 10), int(width * 25 / 40), int(width * 23 / 40), int(width * 9 / 10), int(width * 9 / 10)};
  int[] y_mode = {int(height * 6 / 20), int(height * 8 / 20), int(height * 6 / 20), int(height * 8 / 20), int(height * 6 / 20), int(height * 8 / 20)};
  String[] ch_mode = {"Free-for-all", "Cooperation"};
  
  hostC = new ChoiceBox[2];
  hostC[0] = new ChoiceBox(x_player, y_player, ch_player, c_host);
  hostC[1] = new ChoiceBox(x_mode, y_mode, ch_mode, c_host);
  
  int[] x_ip = {int(width / 2 - 10), int(width / 2 + 10), int(width / 2 + 10), int(width / 2 - 10)};
  int[] y_ip = {0, 0, int(height / 10), int(height / 10)};
  
  int[] x_lbl_play = {int(width / 5 - 10), int(width / 5 + 10), int(width / 5 + 10), int(width / 5 - 10)};
  int[] y_lbl_play = {int(height * 3 / 20), int(height * 3 / 20), int(height * 5 / 20), int(height * 5 / 20)};
  
  int[] x_lbl_mode = {int(width / 5 - 10), int(width / 5 + 10), int(width / 5 + 10), int(width / 5 - 10)};
  int[] y_lbl_mode = {int(height * 6 / 20), int(height * 6 / 20), int(height * 8 / 20), int(height * 8 / 20)};
  
  int[] x_play_list = {int(width * 3 / 5 - 10), int(width * 3 / 5 + 10), int(width * 3 / 5 + 10), int(width * 3 / 5 - 10)};
  int[] y_play_list = {int(height * 23 / 40), int(height * 23 / 40), int(height * 29 / 40), int(height * 29 / 40)};
  
  int[] x_lbl_list = {int(width / 5 - 10), int(width / 5 + 10), int(width / 5 + 10), int(width / 5 - 10)};
  int[] y_lbl_list = {int(height * 12 / 20), int(height * 12 / 20), int(height * 14 / 20), int(height * 14 / 20)};
  
  hostF = new TextField[5];
  hostF[0] = new TextField(false, x_ip, y_ip, "127.0.0.1", c_host);
  hostF[1] = new TextField(false, x_lbl_play, y_lbl_play, "Number of players", c_host);
  hostF[2] = new TextField(false, x_lbl_mode, y_lbl_mode, "Type of battle", c_host);
  hostF[3] = new TextField(false, x_play_list, y_play_list, "", c_host);
  hostF[4] = new TextField(false, x_lbl_list, y_lbl_list, "Connected players", c_host);
  
  /* JOIN MENU */
  int[] x_join_ip = {int(width * 5 / 20), int(width * 16 / 20), int(width * 15 / 20), int(width * 4 / 20)};
  int[] y_join_ip = {0, 0, int(height / 10), int(height / 10)};
  int[] c_join = {255, 255, 255, 200, 0, 0};
  
  int[] x_name = {int(width * 5 / 20), int(width * 16 / 20), int(width * 15 / 20), int(width * 4 / 20)};
  int[] y_name = {int(height * 3 / 20), int(height * 3 / 20), int(height * 5 / 20), int(height * 5 / 20)};
  
  joinF = new TextField[2];
  joinF[0] = new TextField(true, x_join_ip, y_join_ip, "> Host IP <", c_join);
  joinF[1] = new TextField(true, x_name, y_name, "> Your name <", c_join);
  
  int[] x_connect = {int(width * 7 / 20), int(width * 14 / 20), int(width * 13 / 20), int(width * 6 / 20)};
  int[] y_connect = {int(height * 9 / 10), int(height * 9 / 10), height, height};
  
  joinB = new Button(x_connect, y_connect, "Connect to the host !", 3, c_join);
}