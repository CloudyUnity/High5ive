# UI Stuff

## Usage

- Create a class inheriting from Screen (examples being the Screen1 and Screen2 classes).
- Create widgets in the contructor (optionally storing them as members).
- Link methods (that take EventInfo, or the relevent subclass as an argument) to events of the widgets using `widget.getEvent().addHandler(e -> method(e));`.
- If the event handler needs to access the widget that the event's being raised on, it can do this using the `EventInfo.widget` member from the argument.
- Add the widget to the screen by calling `this.addWidget(widget);`.

## Creating new widgets

- Create a subclass of Widget.
- If clickable implement `IClickable`, creating an `Event<EventInfo>` member and implementing the interface method that will return this member. This is all you need to do to create a clickable widget, any handlers added to that event will run when the widget is clicked.

## Misc

- There's some stuff like text offsets in Widgets like Button that I half implemented and never bothered removing, so if something seems pointless it probably is.
- Copy this folder out of here and run it as it's own Processing project to mess about with it.
- If anyone wants to add new widgets/clean up the existing code go for it.
