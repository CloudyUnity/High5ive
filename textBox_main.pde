
ArrayList<TEXTBOX> textboxes = new ArrayList<TEXTBOX>();
String TransferText;
TEXTBOX receiver;
TEXTBOX message;

void setup() {

  size(400, 450);
  InitLayout();
}

void draw() {

  background(190);
  for (TEXTBOX t : textboxes) {
    t.DRAW();
  }
}
void InitLayout() {

  receiver = new TEXTBOX ((width - 200) / 2, 50, 200, 30, true, false);
  
  textboxes.add(receiver);

  message = new TEXTBOX((width - 250) / 2, 90, 250, 300, false, true);
  textboxes.add(message);
  
  
  
}

void mousePressed() {

  for (TEXTBOX t : textboxes) {
    t.PRESSED(mouseX, mouseY);
  }
}
void keyPressed() {

  for (TEXTBOX t : textboxes) {
    t.KEYPRESSED(key, keyCode);
  }
  if (keyCode == (int)ENTER){
    message.SETINPUTTEXT(TransferText);
  }
}
