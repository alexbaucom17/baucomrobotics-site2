---
title: Cal Poly RoboRodentia 2015
date: 2016-03-15 12:30:00 -0700
categories: [Projects]
tags: [robotics]     # TAG names should always be lowercase
---

While I was studying at Cal Poly San Luis Obispo, I got the chance to participate in a competition called RoboRodentia during my freshman year. Our robot performed rather poorly since all our sensors decided to stop working the day of the competition and ever since then I vowed I would re-enter the competition and do better. Due to other circumstances, I didn't get that chance until my senior year when I decided to try flying solo and entering my own robot.

The competition involved moving rings from one set of horizontal rungs to another set, across the field. Higher rungs were worth more points but the highest rung was taller than the robot was allowed to be at the start (but they were allowed to unfold). So, the robot below, built out of trusty LEGO NXT, was what I came up with.

![](/assets/RoboRodentia/Tower.jpg)
_My robot with a lifting gripper and an unfolding tower to reach higher_

If you can't already tell, there is a lot going on with this robot - not to mention I was using so many motors that I had to use 2 NXT bricks as well. The basic idea was to have a tower that unfolds and then a winch system that lifts the gripper up (the string running through the holes is the winch 'cable'). The gripper itself has a motor in it to close around the rings to grab them and there were two light sensors pointed down to detect lines on the competition table. 

Clearly I forgot the best rule of engineering - K.I.S.S. (Keep It Simple Stupid).

And if that wasn't enough, take a look at my programming task diagram below...

![](/assets/RoboRodentia/task_diagram.jpg)
_Programming task diagram (click to enlarge)_

Okay maybe I should explain why this system is so complicated. The reason for such an unwieldy multi tasking system was because I was using this project as a substitute final project for my mechatronics class where we did a lot of C++ multi-tasking and finite state machines and such. So I needed to do all of this in C++ with multi-tasking for this to count as my final project. I found a system called NXT OSEK that would allow me to write C++ code and run it on the NXTs which was really nifty - except that it was extremely complicated and had very little documentation.

Needless to say, my complicated system did not fare so well. In fact I didn't even end up competing because my overly complicated mechanical design caused too many problems for my overly complicated programming design to overcome and I ended up running out of time to finish.

However, I don't count this as a lost cause. In fact, it is one of the projects that I feel that I have learned the most from. Not only did I learn a ton about C++ multi-tasking, finite state machines, and low level resource usage, but I learned some valuable design skills and exactly what NOT to do when designing important things. I was far too confident in my own ability to solve every little issue with my code that I neglected proper mechanical design.

A great example of this was my line following light sensor. I didn't think to measure how far away it was from the center of the robot so when my robot would follow the line to the wall, the ring inside the gripper wasn't even aligned with the peg it was supposed to go on! Giving even two seconds of thought to this would have made me realize that if I put the light sensor in the right position, the robot would be all lined up and just have to drive straight!

This overconfidence also made me realize how essential it is to have other people to work with, especially the kind that can tell you when your idea is ridiculous. I wanted to do every part of this project myself because I wanted to learn it all and do it all my way. But, as I eventually learned, my way is often not the best way. And that is the way it should be. Great inventions, systems, and products are never made by a single person. They are made by teams of brilliant people that work together to do something that no single person could. That is the power and beauty of specialization and cooperation. And that understanding, as well as a healthy dose of humility, was something I was able to walk away from this project with.

If you are interested in any of the actual code, you can find it here: [RoboRodentia Github](https://github.com/BaucomRobotics/RoboRodentia)