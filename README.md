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

Feel free to disagree with any of these. We can put it up to a vote.  

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
14. Once committed to master, delete your branch or local repo to prevent it getting behind.

### Data Preprocessing [US Dataset]:

```
_--------------------------------------------------------------------------------------------------_
| Type:    | FL_DATE             | MKT_CARRIER         | MKT_CARRIER_FL_NUM  | ORIGIN              |
| VarSize: | byte                | short               | short               | short               |
| Reading: | 0001 1111           | 0000 0001 0101 1101 | 0000 0001 0111 0000 | 0000 0001 0111 0000 |
|--------------------------------------------------------------------------------------------------|
| Type:    | DEST                | CRS_DEP_TIME        | DEP_TIME            | DEP_DELAY           |
| VarSize: | short               | shorts              | short               | short               |
| Reading: | 0000 0001 0111 0000 | 1111 1111 1111 1111 | 1111 1111 1111 1111 | 1111 1111 1111 1111 |
|--------------------------------------------------------------------------------------------------|
| Type:    | DEP_DELAY           | CRS_ARR_TIME        | ARR_TIME            | CANCELLED/DIVERTED  |
| VarSize: | short               | short               | short               | byte                |        
| Reading: | 1111 1111 1111 1111 | 1111 1111 1111 1111 | 1111 1111 1111 1111 | 0000 0010          |
|--------------------------------------------------------------------------------------------------|
| Type:    | DISTANCE            | PADDING                                                         |
| VarSize: | short               | 0 bytes                                                         |
| Reading: | 1111 1111 1111 1111 |                                                                 |
-__________________________________________________________________________________________________-

Max Bytes: 0001 1111,  0000 0001 0101 1101,  0000 0001 0111 000,  0000 0001 0111 0000,  0000 0001 0111 0000,  1111 1111 1111 1111,  1111 1111 1111 1111,  1111 1111 1111 1111,  1111 1111 1111 1111,  1111 1111 1111 1111,  1111 1111 1111 1111,  0000 0010,  1111 1111 1111 1111
Max Bits:  0001111100001001000000010111000000000001011100000000000101110000111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111000000101111111111111111

Total Bytes: 23 bytes
Total Bits: 184 bits

Total file lines: 563,737
Total file size: 12,965,951 bytes   or  12.965951 mega bytes

MKT_CARRIER:
AA = 0000 0001 0011 0100 [0x0134]
AS = 0000 0001 0100 1011 [0x014B]
B6 = 0000 0001 0101 1101 [0x015D]
DL = 0000 0001 1101 1010 [0x01DA]
F9 = 0000 0010 0011 0110 [0x0236]
G4 = 0000 0010 0101 1110 [0x025E]
HA = 0000 0010 1010 1000 [0x02A8]
NK = 0000 0011 1101 1011 [0x03DB]
UA = 0000 0101 0010 0010 [0x0522]
WN = 0000 0101 1001 0011 [0x0593]

ORIGIN and DEST:
ABE = 0000 0000 0000 0000 [0x0000]
ABI = 0000 0000 0000 0001 [0x0001]
    ...
JMS = 0000 0000 1011 1010 [0x00BA]
    ...
YKM = 0000 0001 0111 0100 [0x0174]
YUM = 0000 0001 0111 0101 [0x0175]

CANCELLED/DIVERTED:
NONE        = 0000 0000 [0x00]
CANCELLED   = 0000 0001 [0x01]
DIVERTED    = 0000 0010 [0x02]
```
## Data Preprocessing [World Version]:
```
routes.csv: Contains a code for the operating airline, the origin airport IATA code and the destination airport IATA code
airlines.csv: Contains the IATA code and name of every airline in the dataset
airports.csv: Contains the IATA code, name and coordinates of 8k airports around the world
```

## Troubleshooting

- Cannot get working directory:
    - Use `sketchPath()`
- Fill not working with a variable of type `color`:
    - Store the colour as an `int` then call fill as `fill(color(variable));`
- Getting the error "The nested type ApplicationClass cannot hide an enclosing type.":
    - Delete "sketch.properties" file.
    - Ensure project directory is named "High5ive".

## Jobs:

- Preprocess data into binary (Kyara (Cosmo) McWilliam (Cajm0))
- Read data very efficiently (Thomas Creagh (Thomas Creagh))
- Query data (Thomas Creagh (Thomas Creagh) & Kyara (Cosmo) McWilliam (Cajm0))
- Manipulate data (Thomas Creagh (Thomas Creagh) & Kyara (Cosmo) McWilliam (Cajm0))
- Conjoin data with other dataset (Thomas Creagh (Thomas Creagh) & Kyara (Cosmo) McWilliam (Cajm0))
- Create GUI widgets (Alex Robertson (roberta1tcd))
- 3D flight map (Finn Wright (CloudyUnity))
- Design the gui place widgets (?)
