public class TEXTBOX {
   private int X = 0, Y = 0, H = 35, W = 200;
   private int TEXTSIZE = 24;
   
   // COLORS
   private color Background = color(255);
   private color Foreground = color(0, 0, 0);
   private color BackgroundSelected = color(230);
   private color Border = color(30, 30, 30);
   
   private boolean BorderEnable = true;
   private int BorderWeight = 1;
   
   private String InputText; 
   private String Text = "";
   private int TextLength = 0;
   private int numOfLines = 0;
   private boolean selected = false;
   private boolean changable = true;
   private boolean isOutputBox = false;
   
   TEXTBOX() {
      // CREATE OBJECT DEFAULT TEXTBOX NOT REALLY USEFUL UNTIL SEARCH IS IMPLEMENTED
   }
   
   TEXTBOX(int x, int y, int w, int h) {
   
     X = x; Y = y; W = w; H = h; 

   }
   
   TEXTBOX(int x, int y, int w, int h, boolean changable, boolean isOutputBox) {
     X = x; Y = y; W = w; H = h; 
     this.changable = changable;
     this.isOutputBox = isOutputBox;
   }
   
   void DRAW() {
      // DRAWING THE BACKGROUND
      
      if (selected) {
         fill(BackgroundSelected);
         
      } else {
         fill(Background);
      }
      
      if (BorderEnable && selected == true) {
         strokeWeight(BorderWeight);
         stroke(Border);
      } else {
         noStroke();
      }
      
      rect(X, Y, W, H);
      
      // DRAWING THE TEXT ITSELF
      fill(Foreground);
      textSize(TEXTSIZE);
      text(Text, X + (textWidth("a") / 2), Y + TEXTSIZE);
     
      if (isOutputBox && InputText != null){
       //PLACED IN HERE TO INSTANTLY SEND TEXT IN THE EVENT OF A TRANSFER AS OPPOSED TO WAITING FOR AN ADDITIONAL KEYPRESS
         OBTAINSTRING(InputText);
         InputText = null;
         
       }
   }
   
   // IF THE KEYCODE IS ENTER RETURN 1
   // ELSE RETURN 0
   boolean KEYPRESSED(char KEY, int KEYCODE) {
      if (selected && changable && isOutputBox == false) {
         if (KEYCODE == (int)BACKSPACE) {
            BACKSPACE();
         } 
         else if (KEYCODE == 32) {
            // SPACE
            addText(' ');
         } 
         else if (KEYCODE == (int)ENTER) {
         
            // TransferText = ENTER(); ERROR
            return true;
            
         } 
         else {
            // CHECK IF THE KEY IS A LETTER OR A NUMBER
            boolean isKeyCapitalLetter = (KEY >= 'A' && KEY <= 'Z');
            boolean isKeySmallLetter = (KEY >= 'a' && KEY <= 'z');
            boolean isKeyNumber = (KEY >= '0' && KEY <= '9');
      
            if (isKeyCapitalLetter || isKeySmallLetter || isKeyNumber) {
               addText(KEY);
            }
         }
     
       
      }
       
     
      return false;
   }
   
   private void addText(char text) {
      // IF THE TEXT WIDTH IS IN BOUNDARIES OF THE TEXTBOX
      if (textWidth(Text + text) < W - 10) {
         Text += text;
         TextLength++;
      }
   }
   

   
   private void BACKSPACE() {
     //BACKSPACE PROGRAM
      if (TextLength - 1 >= 0) {
         Text = Text.substring(0, TextLength - 1);
         TextLength--;
      }
   }
   
   private String ENTER(){
   // FUNCTION FOR SENDING TEXT CURRENTLY IN BOX TO OUTSIDE LIST/VAR
     String tempText = Text;
     Text = "";
     TextLength = 0; 
     return tempText;
   
   }
   
   public void SETINPUTTEXT(String input){
     //SETS INPUT TEXT PRIVATE VARIBLE
     InputText = input;
   
   }
   
   
   
   public void OBTAINSTRING(String InputText){
     //TAKES AN OUTSIDE STRING AND PLACES IT IN TEXTBOX ONLY USED IF ISOUTPUTBOX IS TRUE
     if (numOfLines * 10 < Y){
     Text += InputText;
     Text += "\n";
     numOfLines += 1;
     }
   
   }
   
   // FUNCTION FOR TESTING IS THE POINT
   // OVER THE TEXTBOX
   private boolean OVERBOX(int x, int y) {
      if (x >= X && x <= X + W) {
         if (y >= Y && y <= Y + H) {
            return true;
         }
      }
      
      return false;
   }
   
   void PRESSED(int x, int y) { 
     //FUNCTION TO CHECK IF A BOX SHOULD BE SELECTED 
      if (OVERBOX(x, y)) {
         selected = true;
      } else {
         selected = false;
      }
   }
}

// Code authorship:
// M.Poole, Created textbox widget, 4:15pm 09/03/24
