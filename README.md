# README

## People

- Group B, Team 5
- Finn Wright (CloudyUnity)
- Alex Robertson (roberta1tcd)
- Kyara (Cosmo) McWilliam (Cajm0)
- Mateusz Orlowski (MO1805)
- Matthew Poole (Matthew Poole)
- Thomas Creagh (Thomas Creagh)

## Attributions

Data from openflights (https://openflights.org/faq) and the US Bureau of Transportation Statistics (https://www.transtats.bts.gov/DL_SelectFields.aspx?gnoyr_VQ=FGK&QO_fu146_anzr=b0-gvzr)

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
_----------------------------------------------------------------------------------------------------------_
| Type:    | FL_DATE             | MKT_CARRIER         | MKT_CARRIER_FL_NUM  |                             |
| VarSize: | byte                | byte                | short               |                             |
| Reading: | 0001 1111           | 0000 1001           | 0000 0001 0111 0001 |                             |
|----------------------------------------------------------------------------------------------------------|
| Type:    | ORIGIN              | DEST                | CRS_DEP_TIME        | DEP_TIME                    |
| VarSize: | short               | short               | shorts              | short                       |
| Reading: | 0000 0001 0111 0001 | 0000 0001 0111 0001 | 1111 1111 1111 1111 | 1111 1111 1111 1111         |
|----------------------------------------------------------------------------------------------------------|
| Type:    | CRS_ARR_TIME        | ARR_TIME            |                                                   |
| VarSize: | short               | short               |                                                   |         
| Reading: | 1111 1111 1111 1111 | 1111 1111 1111 1111 |                                                   | 
|----------------------------------------------------------------------------------------------------------|
| Type:    | CANCELLED/DIVERTED  | DISTANCE            | PADDING                                           |
| VarSize: | byte                | short               | 0 bytes                                           |
| Reading: | 0000  0010          | 1111 1111 1111 1111 |                                                   |
-__________________________________________________________________________________________________________-

Max Bytes: 0001 1111 0000 1001 0000 0001 0111 000 0000 0001 0111 0000 0000 0001 0111 0000 1111 1111 1111 1111 1111 1111 1111 1111 1111 1111 1111 1111 1111 1111 1111 1111 0000 0010 1111 1111 1111 1111
Max Bits:  0001111100001001000000010111000000000010111000000000001011100001111111111111111111111111111111111111111111111111111111111111111000000101111111111111111

Total Bytes: 19 bytes
Total Bits: 152 bits

Total file lines: 563,737
Total file size: 10,711,003 bytes   or  10.711003 mega bytes

MKT_CARRIER:
AA = 0000 0000 [0x00]
AS = 0000 0001 [0x01]
B6 = 0000 0010 [0x02]
DL = 0000 0011 [0x03]
F9 = 0000 0100 [0x04]
G4 = 0000 0101 [0x05]
HA = 0000 0110 [0x06]
NK = 0000 0111 [0x07]
UA = 0000 1000 [0x08]
WN = 0000 1001 [0x09]

ORIGIN and DEST:
ABE = 0000 0000 0000 0000 [0x0000]
    ...
YUM = 0000 0001 0111 0001 [0x0170]

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
    - Ensure project directory is named "FATMKM".

## Jobs:

- Preprocess data into binary (Kyara (Cosmo) McWilliam (Cajm0))
- Read data very efficiently (Thomas Creagh (Thomas Creagh))
- Query data (Thomas Creagh (Thomas Creagh))
- Manipulate data (?)
- Conjoin data with other dataset (?)
- Create GUI widgets (Alex Robertson (roberta1tcd))
- 3D flight map (Finn Wright (CloudyUnity))
- Design the gui place widgets (?)
