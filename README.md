# README

## People

- Group B, Team 5
- Finn Wright (CloudyUnity)
- Alex Robertson (roberta1tcd)
- Kyara (Cosmo) McWilliam (Cajm0)
- Mateusz Orlowski (MO1805)
- Matthew Poole (Matthew Poole)
- Thomas Creagh (Thomas Creagh)

## Coding Standard

Feel free to disagree with any of these. We can put it up to a vote.  

### Variables/Classes

- All member variables look like "m_varName".  
- Constant (final) variables use CONSTANT_SNAKE_CASE.  
- Non-constant but static/gloabl variables use "s_StaticCase".  
- Any classes that are acting as structs should have their identifier appended with "Type". See GameObjectClass.TransformType.  
- All classes should have their identifier appended with "Class".  
- All interfaces and interface methods should start with "I".  
- There should be no global variables if possible "Excluding the class instances created in Main".  
- Keep stuff private whenever possible. The codebase should generally only talk in one direction.  
- Avoid using this.memberVar when possible
- Keep all member variables at the top of the class/struct above functions


### Control Flow/Methods

- There should be as few comments as possible. Use self-documenting code techniques. Use your best judgement.  
- Avoid nesting statements multiple times. Use guard clauses and methods to break stuff up.  
- Each method should do only a single task and the name should accurately describe what it does. Don't be afraid of long identifier names.  
- The Main tab should have minimal functions like setup() and draw() and getting input.  
- One-line if statements don't need body brackets but the body goes on the next line
- Multi-line if statements need body brackets and the body goes on the next line

### Misc

- Use sameline curly brackets.  
- Keep stuff indented properly! Use Ctrl-T to do it automatically.  
- "var" is BANNED except for during for loops.  
- Keep all scene initialisation inside of ApplicationClass if possible.  
- The game should be framerate independant. Use the static variable s_deltaTime like this:  
    WRONG:   player.position.x += speed;  
    CORRECT: player.position.x += speed * s_deltaTime;  

## How to commit your changes to github using Git Bash  

Note that you might be able to do this using a git extension for processing, cmd or otherwise but I'll explain how I do it.  

1. Open up Git Bash  
2. Change to the directory. For me it's:  
    cd "C:\Users\finnw\OneDrive\Documents\Trinity\CS\Project\FATMKM"  
3. Add all your changes to the current working commit  
    git add .  
4. Make a commit  
    git commit -m "Commit message describing what was changed"  
5. Push your changes to the remote branch  
    git push origin master      
6. If you get no error messages, congrats you have pushed your changes successfully! Go check the github to make sure it worked. If you get an error message like this then continue following these instructions:  
     ! [rejected]        master -> master (fetch first)  
    error: failed to push some refs to 'https://github.com/CloudyUnity/ProcessingFATMKM.git'  

### How to merge your local repo with the master branch:  
7. Pull the master branch changes into your local repo  
    git pull --rebase origin master  
8. You might be asked to resolve some conflicts. If you can get git working with some text editors it can make your life easier.   
9. Conflict with missing file. For example if a file was removed in the master branch but you were making changes to it. Move all your changes outside of the file and then delete it  
    git rm fileNameExample.txt  
10. Other conflicts. I don't have experience here but try your best. Don't accidentaly delete everything without a backup. Try doing this to add new files to the commit:  
    git add .  
11. Now that you have resolved all conflicts you can continue  
    git rebase --continue  
12. You'll be asked to make a commit message again. If you're not familiar with vim text editors this may help:  
    "i" enters insert mode where you can add text to your message  
    "Esc" exits insert mode to allow you to use the following commands  
    ":w" writes and saves the changes   
    ":q" quits the editor. Make sure to do ":w" first   
    You should see this message:  
        Successfully rebased and updated refs/heads/master.  
13. Now that your local repo is synced up it's time to push your changes again
    git push origin master  

### Data Preprocessing and reading:
Type:     FL_DATE    MKT_CARRIER   MKT_CARRIER_FL_NUM  ORIGIN               DEST                 CRS_DEP_TIME         DEP_TIME             CRS_ARR_TIME         ARR_TIME             CANCELLED/DIVERTED  DISTANCE             PADDING
VarSize:  byte       byte          short               short                short                shorts               short                short                short                byte                short                5 bytes
Reading:  0001 1111  0000 1001     0000 0001 0111 0001 0000 0001 0111 0001  0000 0001 0111 0001  1111 1111 1111 1111  1111 1111 1111 1111  1111 1111 1111 1111  1111 1111 1111 1111  0000  0010          1111 1111 1111 1111  0000 0000 0000 0000 0000 0000 0000 0000 0000 0000

Max Bytes: 0001 1111 0000 1001 0000 0001 0111 0001 0000 0001 0111 0001 0000 0001 0111 0001 1111 1111 1111 1111 1111 1111 1111 1111 1111 1111 1111 1111 1111 1111 1111 1111 0000 0010 1111 1111 1111 1111 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000
Max Bits:  00011111000010010000000101110001000000010111000100000001011100011111111111111111111111111111111111111111111111111111111111111111000000101111111111111111000000000000000000000000000000000000

MKT_CARRIER:
AA = 0000
AS = 0001
B6 = 0010
DL = 0011
F9 = 0100
G4 = 0101
HA = 0110
NK = 0111
UA = 1000
WN = 1001

CANCELLED/DIVERTED:
NONE        = 0000
CANCELLED   = 0001
DIVERTED    = 0010

## Roles:
- preprocess data (Kyara (Cosmo) McWilliam (Cajm0))
- read data very efficiently (Thomas Creagh (Thomas Creagh))
- manipulate data (?)
- conjoin data with other dataset (?)
- display data (Alex Robertson (roberta1tcd))
- design the gui place widgets (?)