# README

## People

- Group B, Team 5
- Alex Robertson (roberta1tcd)
- Finn Wright (CloudyUnity)
- Kyara (Cosmo) McWilliam (Kya-ra)
- Mateusz Orlowski (MO1805)
- Matthew Poole (MPoole1105)
- Thomas Creagh (ThomasCreagh)

## Coding Standard

### Variables/Classes

- All member variables look like "m_varName".  
- Constant (final) variables use CONSTANT_SNAKE_CASE.  
- Non-constant but static/gloabl variables use "s_StaticCase".  
- Any classes that are acting as structs should have their identifier appended with "Type".  
- All classes should have their identifier appended with "Class".  
- All interfaces and interface methods should start with "I".  
- There should be no global variables if possible (Excluding the class instances created in Main).    
- Keep stuff private whenever possible. The codebase should generally only talk in one direction.  
- Avoid using this.memberVar when possible  
- Keep all member variables at the top of the class/struct above functions  
- Store colours as ints, then when needed call `fill(color(m_colour))` as it seems to be unreliable if the `fill` call will work otherwise.  

### Control Flow/Methods

- There should be as few comments as possible. Use self-documenting code techniques. Use your best judgement.  
- The spec requires comments. Use comments.
- Avoid nesting statements multiple times. Use guard clauses and methods to break stuff up.  
- Each method should do only a single task and the name should accurately describe what it does. Don't be afraid of long identifier names.  
- The Main tab should have minimal functions like setup() and draw() and getting input.  
- One-line if statements don't need body brackets but the body goes on the next line
- Multi-line if statements need body brackets and the body goes on the next line

### Misc

- Use sameline curly brackets.  
- Keep stuff indented properly! Use Ctrl-T to do it automatically.  
- "var" is BANNED except for during foreach loops.  

## Troubleshooting

- Getting the error "The nested type ApplicationClass cannot hide an enclosing type.":
    - Delete "sketch.properties" file.
    - Ensure project directory is named "High5ive".
