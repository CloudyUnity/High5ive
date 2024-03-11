# THE DOCS

- Written by Finn Wright 09/03/24

This file contains a short explanation on how the overall project structure works.  
I recommend going over the README.md first for the general coding standard.  
Also you should have some understanding of how Events (Consumer<T>), Interfaces and Inheritance work  
Try to look through these tabs as I'm explaining them to get the best understanding of what's going on.  

### Why do the tabs start with weird letters?

This is because Processing is not an IDE for humans and doesn't have proper project structure. We are stuck with tabs that are ordered alphabetically. For this reason all tabs start with different letters to group similar ones together.  
- FATMKM should always be the first tab  
- C_ is more global/misc/important stuff  
- D_ is a special one just for DataPreprocessor. Should probably be changed to M_  
- M_ is for managers. The classes in charge  
- N_ is for more general classes which have multiple instances across the program  
- W_ is for Widget UI elements including Widget itself  
- X_ is for more front-end design kinda stuff   
- Z_ is for debug classes   

## FATMKM

This tab is the main entry point of the program and contains most of the static/global functions of the program.  
It creates an ApplicationClass and initialises it in setup().  
Inside draw() it calls s_ApplicationClass.frame().  

## ApplicationClass

This class is the king of the program. It has control over many other managers and classes.  
In init() it loads in the data and sets up the screens.  
In frame() it calls on the m_currentScreen to draw itself  

## Screen

This class is only meant to be used by inherited sub-classes seen in ScreenPresets.  
A screen is made up of a list of Widgets, WidgetGroups and Events  
This class is part of the chain that passes input events from FATMKM->ApplicationClass->Screen->Widget  
(Such events like onMouseMoved(), onMouseClick(), onMouseDragged())  
When the events are raised it causes any widgets subscribed to those events to trigger their respective functions. These functions are often defined in the Widgets themselves or in ScreenPresets.  
Each Screen has their own unique ID (defined in Constants) which makes for easier switching between screens.   

## ScreenPresets

This is one of the most important tabs in the program. It holds the information about what Widgets are in each Screen, what they look like, where they are and various other information that can be set.  
Each Screen is it's own class which gets inherited from Screen.  
Inside the constructor of each Screen Preset we use useful functions like createButton(), createCheckbox(), etc to automatically add widgets to the main Screen Widget list. If you don't want to add the widgets directly to the screen then use their constructors (e.g new ButtonUI(...))  
This is also where the scripting for what happens when Events are raised is written. See functions like "redButtonOnClick(EventInfoType e)"  
Remember that the order in which you create Widgets directly affects the order in which they're drawn each frame. (Layering options could be a useful feature to add!)  

## Widget

Let's take a closer look into how Widgets themselves work.  
Every widget has a position, scale, colour and event handling  
There's also a "Grow Mode" which can be enabled on any Widget to make it grow in size when the mouse hovers over it. Juicy!  
Widget is meant to be inherited by various UI elements and implement interfaces such as IClickable or IDraggable if they should do something when clicked/dragged.  

## ButtonUI

This is an example of a Widget that implements IClickable. I recommend reading up on how interfaces work if you're rusty.  
ButtonUI contains a Widget of its own! How cute. Widgetception. It's a LabelUI which is manually drawn from within ButtonUI's draw(). The LabelUI allows the ButtonUI to have text on it automatically.  
Because ButtonUI implements IClickable it has an m_onClickEvent. You can subscribe as many functions as you want to this event and when the button is clicked all of them will be called, one by one.  

## FlightManagerClass

Tom took over here a while ago so he'd be best at explaining this tab.  
In the meanwhile this class basically loads pre-processed flight data and modifies the resulting list based on user queries  

## Minor tabs

InputClass is intended to give accurate keyboard input information but it was made when this project was a game. It hasn't been needed since, can be ignored unless you want keyboard inputs.  

Constants contain all the constants, self-explanitory  

Interfaces contains all interfaces in the program because they are pretty small overall.  

Math contains useful math functions I wanted for my 3D stuff. Feel free to add stuff missing from Processing/math libraries if you want.  

DebugFPS calculates the average FPS of the last 30 frames when DEBUG_FPS_ENABLED is true in Constants  

DebugProfiler allows you to check the time taken by various bits of code. It's very simple to use.  
s_DebugProfiler.startProfileTimer() starts the timer  
s_DebugProfiler.printTimeTakenMillis("Example") ends the timer and prints the result to the console  
This class uses a stack so you can nest multiple profilers and it will still work. Multithreading may cause issues however.  

### What else is in this project?

Inside the project files we have some interesting things to note  
- README.md  
    You should have already read this  
- Docs.md  
    Hey, that's me!  
- Helper Scripts  
    Contains random scripts from other languages generally used for pre-processing data.  
- CSV_Modifier  
    Used for converting CSV files to raw binary data  
- data  
    - Fonts  
    - Images  
        Mostly just 3D related textures and maps in there right now  
    - Preprocessed Data  
        Contains lookup tables and raw binary data used by FlightManagerClass and DataPreprocessorClass  
    - Shaders  
        Vertex and Fragment scripts run by the GPU to render triangles using matrix math. Unless you're in the 3D turbo team you don't need to understand what I just said.  
