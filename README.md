##Robot Localization Animation
##What you need to know
In this project you will practice implementation of an algorithm for a robot localization problem (see [Documentation](/Documentation/Example.pdf), example 3 for the algorithm description). Given a grid world, a sensory error and a sequence of observations, a robot must
estimate the room it is in at the time of the last observation.

A grid world is represented by an n x m matrix M of integers, each of which in binary shows that there are obstacles in
directions <North, South, West, East> (in this order). In other words, M[i][j] = 10 means that at location [i][j] of the grid
there are obstacles to the North and West of this location (since 10 in binary is 1010 and binary 1 represents an
obstacle). A sequence of observations is given in capital letters: NW, NS, for example. NW means that there are
obstacles to the North and West.

The matrix M is given in the input file “[input.txt](Tests/input1.txt)” and the sensory error together with a sequence of observations are
given in a command line.

For example, if the content of input.txt file is:
<pre>
10 12 9
7 15 7
</pre>
Then the corresponding Grid World is:

![Image of Grid World](Images/GridWorld1.png)


####Development Team (a-z)
Ethan, Jay, Kevin, Spencer
