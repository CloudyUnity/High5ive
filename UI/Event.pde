class Event<T extends EventInfo> {
  public Event() {
    this.eventHandlers = new ArrayList<Consumer<T>>();
  }
  
  public void addHandler(Consumer<T> handler) {
    if (handler != null)
      this.eventHandlers.add(handler);
  }
  
  public void raise(T e) {
    for (Consumer<T> handler : eventHandlers)
      handler.accept(e);
  }
  
  ArrayList<Consumer<T>> eventHandlers;
}
