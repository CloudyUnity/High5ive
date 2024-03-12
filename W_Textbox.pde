public class TextboxUI extends Widget implements IKeyInput, IClickable {
   private int fontSize = 24;
   private StringBuilder m_text;
   private int m_cursorPosition;
   
   private Event<KeyPressedEventInfoType> m_onKeyPressedEvent;
   private Event<EventInfoType> m_onClickEvent;
   private Event<StringEnteredEventInfoType> m_onStringEnteredEvent;
   
   private int m_timer;
   private boolean m_drawBar;
   
   public TextboxUI(int x, int y, int width, int height) {
     super(x, y, width, height);
     m_text = new StringBuilder();
     m_onKeyPressedEvent = new Event<KeyPressedEventInfoType>();
     m_onClickEvent = new Event<EventInfoType>();
     m_onStringEnteredEvent = new Event<StringEnteredEventInfoType>();
     m_timer = 30;
     m_drawBar = true;
     m_cursorPosition = 0;
     
     m_onKeyPressedEvent.addHandler(e -> onKeyPressed(e));
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
      textAlign(LEFT, CENTER);
      fill(m_foregroundColour);
      textSize(fontSize);
      if (!isFocused())
        text(m_text.toString(), m_pos.x, m_pos.y, m_scale.x, m_scale.y);
      else {
        m_timer -= 1;
        if (m_timer == 0) {
          m_timer = 30;
          m_drawBar = !m_drawBar;
        }
        StringBuilder output = new StringBuilder();
        output.append(m_text.toString());
        output.insert(m_cursorPosition, m_drawBar ? "|" : " ");
        text(output.toString(), m_pos.x, m_pos.y, m_scale.x, m_scale.y);
      }
   }

   public void setText(String text) {
      m_text.setLength(0);
      m_text.append(text);
      m_cursorPosition = text.length() - 1;
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
   
   private void onKeyPressed(KeyPressedEventInfoType e) {
     if (e.pressedKey == BACKSPACE && m_text.length() > 0) {
       m_text.deleteCharAt(m_text.length() - 1);
       m_cursorPosition--;
     } else if (e.pressedKey == LEFT && m_text.length() > 0) {
       m_cursorPosition--;
     } else if (e.pressedKey == RIGHT && m_cursorPosition < m_text.length()) {
       m_cursorPosition++;
     } else if (e.pressedKey == RETURN || e.pressedKey == ENTER) {
       m_onStringEnteredEvent.raise(new StringEnteredEventInfoType((int)m_pos.x, (int)m_pos.y, m_text.toString(), this));
     } else {
       m_text.append(e.pressedKey);
       m_cursorPosition++;
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
