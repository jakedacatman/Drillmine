# Drillmine
## Computercraft mining program that detects lava and uses it to refuel
###
**_important!_**
if you put something lower then his Y coordinate Then he might get stuck in bedrock
if his chunk unloads the program will stop and he will never come back

**Usage**:
Simply place an empty bucket in his 16th slot and run the script,
eg drillmine 68 "68" is the turtles y coordinate

**BUGS**:

Falling blocks make him come back lower then intended

He digs his next shaft to go up randomly instead of in front of him

He prints *Found lava refueling...* 3 or 4 times for every one lava block he finds

If you find other bugs please open an issue or make a pull request since we all you're probably a better coder then me :P

#TODO
Create custom move function that deals with falling blocks and keeps track of Turtle's y posision

create config file and create startup file so he can keep going even if the chunk unloads idea from orequarry

make the code cleaner right now its pretty ugly

fix the readme this is the first time i've done this :P
