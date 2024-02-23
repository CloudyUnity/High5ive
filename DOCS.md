# DOCS

This is where the codebase structure will be explained. One file at a time  

## FATMKM

This is the Main entry point of the program and the only place non-constant global variables are found  
Two objects are created initially. The ApplicationClass and InputClass.  
s_ApplicationClass should not be called by anyone other than this file. s_InputClass is free to be called by anyone as I'll show later.  
There are also two functions keyPressed() and keyReleased() that are required to be in this file.  

## ApplicationClass

This class is the heart of the program. It sits on the top of the program telling everyone else what to do. Try not to call anything here from lower down the program.  
This class is used to initialise everything in the scene such as world terrain, the player, camera, etc. This is done in init().  
frame() is called every frame and has a few roles. It updates s_deltaTime, calls frame() on all GameObjectClasses, sometimes calls fixedFrame() and then renders the scene through RenderClass.
fixedFrame() is called at a fixed rate over time rather than frame() which is called whenever possible. This method is useful for doing physics/collision calculations.  
millis() gives the total amount of milliseconds that have passed since the program started.  
initGameObject(String) is a function useful for shortening the code of creating a gameobject and adding it to a list. Expect a lot more of this kind of code in ApplicationClass because init() will get very long over time.  

## InputClass

This class as you can imagine manages all the inputs for the keyboard. Future support for mouse or controller inputs can be added in the future if needed.  
getKey(char) returns if the key represented by the char is currently being held down. There is no support for keys not represented by characters (e.g. F1).  
getKeyDown(char) returns if the key represented by the char was pressed this frame.  
getKeyUp(char) returns if the key represented by the char was released this frame.  
getMillisSincePressed(char) returns how many milliseconds it has been since the key was pressed. This is useful for input buffering.  
setKeyState(char, boolean) and frame() should never be called by anyone other than FATMKM.  
Here is how you can use these functions:
    if (s_InputClass.getKey('W'))
        position.y += speed * s_deltaTime;
    if (s_InputClass.getKeyDown('E'))
        openInventory();
    if (isGrounded && s_InputClass.getMillisSincePressed(' ') < 20)
        jump();

## RenderClass

RenderClass is the class used to render everything in the scene. Most notably the list of all GameObjects.  
It also manages the camera transform and backgroundColor but these could be moved elsewhere later.  
render(ArrayList<GameObjectClass>) sets the background color and renders all gameobjects.  
This class doesn't have much to do right now but will become very important if we start implementing shaders and post-processing.  

## GameObjectClass

"go" stands for "GameObject". You'll see it throughout the project.  
The GameObjectClass is the class that almost all scene actors will inherit from.  
This class will change depending on if the game we make will be 2D or 3D.  
m_nameIdentifier will be used for debug purposes and to allow different gameobjects to find each other in the list.  
m_color is to tint images/models.  
m_renderingEnabled determines if the go is rendered.  
frame() and fixedFrame() are meant to be overriden by subclasses to provide functionality to the objects.  

### TransformType

    This struct contains 3 vectors for the world position, rotation and scale.  
    The Parent member is to link the transform to another one. For example a hat linked to a human. The hat could have a position of (0, 5, 0) to stay 5 units above the humans position at all times.  

## Constants

Almost all constants should go in here.  

## Example: Creating a PlayerClass

TODO