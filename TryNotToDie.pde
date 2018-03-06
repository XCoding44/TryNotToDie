Button host;
Button join;

TextField test;

void setup () {
  size(1200, 600);
  frameRate(20);
  textAlign(CENTER, CENTER);
  
  menuDef();
}

void draw() {
  background(0);
  host.display();
  join.display();
  test.display();
  
  join.checkState();
  host.checkState();
}