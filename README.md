# README

This file contains no code

## Coding Standard

Feel free to disagree with any of these. We can put it up to a vote.

### Variables/Classes

- All member variables look like (m_varName).
- Constant (final) variables use CONSTANT_SNAKE_CASE.
- Non-constant but static/gloabl variables use (s_StaticCase).
- Any classes that are acting as structs should have their identifier appended with (Type). See GameObjectClass.TransformType.
- All interfaces and interface methods should start with (I).
- There should be no global variables if possible (Excluding the class instances created in Main).
- Keep stuff private whenever possible. The codebase should generally only talk in one direction.


### Control Flow/Methods

- There should be as few comments as possible. Use self-documenting code techniques. Use your best judgement.
- Avoid nesting statements multiple times. Use guard clauses and methods to break stuff up.
- Each method should do only a single task and the name should accurately describe what it does. Don’t be afraid of long identifier names.
- The Main tab should only have 2 functions setup() and draw().

### Misc

- Use sameline curly brackets.
- Keep stuff indented properly! Use Ctrl-T to do it automatically.
- (var) is BANNED except for during for loops.
- Keep all scene initialisation inside of ApplicationClass if possible.