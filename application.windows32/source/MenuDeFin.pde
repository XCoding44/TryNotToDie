void menu(int nbrP, String[] y) { /*variable classement joueur */

  strokeWeight(5);
  fill(89, 138, 229);
  stroke(51, 206, 255);
  quad(width * 1/20, height * 3/14 , width * 19/20, height * 3/14, width * 19/20, height * 11/35, width * 1/20, height * 11/35); /* rectangle 1er joueur */
  fill(0, 0, 0);
  textSize(16);
  text("1er joueur", width * 2/10, height * 19/70);
  text(y[0], width * 4/10, height * 19/70); /* le pseudo du 1er joueur */
  
  if (nbrP == 2) {
  strokeWeight(5);
  fill(89, 138, 229);
  stroke(51, 206, 255);
  quad(width * 1/20, height * 13/35, width * 19/20, height * 13/35, width * 19/20, height * 33/70, width * 1/20, height * 33/70); /* rectangle 2e joueur */
  fill(0, 0, 0);
  text("2e joueur", width * 2/10, height * 30/70);
  text(y[1], width * 4/10, height * 30/70);
  }
  else if (nbrP == 3) {
  strokeWeight(5);
  fill(89, 138, 229);
  stroke(51, 206, 255);
  quad(width * 1/20, height * 37/70, width * 19/20, height * 37/70, width * 19/20, height * 22/35, width * 1/20, height * 22/35); /* rectangle 3e joueur */
  fill(0, 0, 0);
  text("3e joueur", width * 2/10, height * 41/70);
  text(y[2], width * 4/10, height * 41/70);
  }
  else if (nbrP == 4) { /* si le nbr de joueur = 4 */
    strokeWeight(5);
    fill(89, 138, 229);
    stroke(51, 206, 255);
    quad(width * 1/20, height * 24/35, width * 19/20, height * 24/35, width * 19/20, height * 11/14, width * 1/20, height * 11/14); /* rectangle 4e joueur */
    fill(0, 0, 0);
    text("4e joueur", width * 2/10, height * 52/70);
    text(y[3], height * 4/10, height * 52/70);
  } 
  else if (nbrP == 5) { /* si le nbr de joueur = 5 */
    strokeWeight(5);
    fill(89, 138, 229);
    stroke(51, 206, 255);
    quad(width * 1/20, height * 24/35, width * 19/20, height * 24/35, width * 19/20, height * 11/14, width * 1/20, height * 11/14); /* rectangle 4e joueur */
    fill(0, 0, 0);
    text("4e joueur", width * 2/10, height * 52/70);
    text(y[3], height * 4/10, height * 52/70);

    strokeWeight(5);
    fill(89, 138, 229);
    stroke(51, 206, 255);
    quad(width * 1/20, height * 59/70, width * 19/20, height * 59/70, width * 19/20, height * 33/35, width * 1/20, height * 33/35); /* rectangle 5e joueur */
    fill(0, 0, 0);
    text("5e joueur", width * 2/10, height * 63/70);
    text(y[4], width * 4/10, height * 63/70);
  }
}
