---
title: Assembly Language Motor Controller
date: 2016-02-13 12:30:00 -0700
categories: [Projects]
tags: [electronics]     # TAG names should always be lowercase
image: /assets/AssemblyMotorController/preview.jpg
---

Assembly language is a programming language for microchips that is basically one step away from writing binary code. It is fairly tedious to write, which is why very few people code directly in assembly language anymore. So how many lines of assembly language does it take to create a simple PI motor controller on a Motorola 68HC12? About 1500, it turns out...

This motor controller was the final project for my Introduction to Mechatronics class at Cal Poly and it was quite a lot of fun for a number of reasons. First, we had been slowly building up to this project all quarter with lots of little projects that we were able to combine together in the end to make a motor controller. And second, this project gave me a far more intuitive understanding of controls than even my controls class did, but more on that later.

The reason this motor controller took so many lines of code was because it was more than just a motor controller. It had an LCD screen with a text displaying the current speed, motor power, velocity set point, and the controller gains. There was also a keypad that could be used to send commands to change the set point or the gains with sub-menus on the display to carry out these functions. Meanwhile, an interrupt service routine was slated to run every 2 ms to measure the error (from an encoder) and do the necessary control calculations.

In order to accomplish these various tasks 'simultaneously,' we used a series of finite state machines and cooperative multitasking. This means that each task had a set of states that it could be in and that each state would run very quickly to not hog the processor. Therefore, if each task ran through its state very quickly the processor could jump quickly back and forth between the various task to give the appearance of multitasking.

Doing all of this in assembly language presented some very interesting and unique challenges. For example, the processor really only had 6 bytes of 'working memory' to use, which meant every calculation required fetching the data from RAM, doing the actual calculation, and then sending the result back to RAM. Also, the only calculations we could really do were basic arithmetic and logical operations and buffer overflow was a very real problem we had to deal with. All of this meant we had to get really clever with our algorithms and data manipulation in order to get our code to work effectively.

I had done a lot of C/C++ and MATLAB programming before this class, but it was so different from anything I had done that it took a whole new frame of mind and approach to what used to be very simple problems. And that was one of the reasons it was so interesting and rewarding to finally get it all working.

As I mentioned above, another thing that was really fun was getting a very intuitive understanding of controls from this project. Once we had gotten everything all working, my partner and I sat playing with the controller for quite some time since we were able to easily change the velocity set point, gains, and open/closed loop feedback. This gave us a chance to experiment with how different parameters affected the system and get a much better feel for how and why each parameter did what it did. We discovered that a velocity set point of 0 with a high I gain make a great position controller but that if we turned up the I gain too high and the motor experienced even a slight vibration, it would begin oscillating like crazy. We could apply friction to the output shaft as it was spinning and watch how different gains tried to compensate for the error and how an open loop controller would not even realize that there was any error.

These were all things that we had learned theoretically in our controls class, but to get to discover their physical effects for ourselves was very rewarding. It seems like 30 minutes to play with an interactive motor controller like this should be a requirement for any controls class. However, writing all the necessary code in assembly language, while interesting for me, might not be for everyone.