public class TextboxUI extends Widget implements IKeyInput, IClickable {
   private int fontSize = 24;
   private StringBuilder m_text;
   
   private Event<KeyPressedEventInfoType> m_onKeyPressedEvent;
   private Event<EventInfoType> m_onClickEvent;
   private Event<StringEnteredEventInfoType> m_onStringEnteredEvent;
   
   public TextboxUI(int x, int y, int width, int height) {
     super(x, y, width, height);
     m_text = new StringBuilder();
     m_onKeyPressedEvent = new Event<KeyPressedEventInfoType>();
     m_onClickEvent = new Event<EventInfoType>();
     m_onStringEnteredEvent = new Event<StringEnteredEventInfoType>();
     
     m_onKeyPressedEvent.addHandler(e -> onKeyPressed(e));
   }
   
   @ Override
   public void draw() {
      // DRAWING THE BACKGROUND
      super.draw();
      
      fill(m_backgroundColour);

      rect(m_pos.x, m_pos.y, m_scale.x, m_scale.y);
            
      // DRAWING THE TEXT ITSELF
      textAlign(LEFT, CENTER);
      fill(m_foregroundColour);
      textSize(fontSize);
      text(m_text.toString(), m_pos.x, m_pos.y, m_scale.x, m_scale.y);
   }

   public void setText(String text) {
      m_text.setLength(0);
      m_text.append(text);
   }
   
   public String getText() {
     return m_text.toString();
   }
   
   public Event<KeyPressedEventInfoType> getOnKeyPressedEvent() {
     return m_onKeyPressedEvent; 
   }
   
   public Event<EventInfoType> getOnClickEvent() {
     return m_onClickEvent;
   }
   
   public Event<StringEnteredEventInfoType> getOnStringEnteredEvent() {
     return m_onStringEnteredEvent;
   }
   
   private void onKeyPressed(KeyPressedEventInfoType e) {
     if (e.pressedKey == BACKSPACE && m_text.length() > 0) {
       m_text.deleteCharAt(m_text.length() - 1);
     } else if (e.pressedKey == RETURN || e.pressedKey == ENTER) {
       m_onStringEnteredEvent.raise(new StringEnteredEventInfoType((int)m_pos.x, (int)m_pos.y, m_text.toString(), this));
     } else {
       m_text.append(e.pressedKey);
     }
   }
}

// Code authorship:
// M.Poole, Created textbox widget, 4:15pm 09/03/24
// A. Robertson, Adapted textbox to fit in with the event system, 15:00 11/03/2024
