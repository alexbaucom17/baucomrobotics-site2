---
title: The World Cup... of Robot Soccer!
date: 2016-07-14 12:30:00 -0700
categories: [Projects]
tags: [robotics, robocup]     # TAG names should always be lowercase
---

A few weeks ago I had the chance to attend [RoboCup 2016](https://www.robocup.org/) in Leipzig, Germany. RoboCup is sort of like the World Cup, but for robots. Various teams from around the world bring their robots together to compete in robotic soccer as well as all sorts of other events like search and rescue, the Amazon Picking Challenge, industrial logistics, and home service. 

There are many different soccer leagues but the one that our team was a part of was the [Standard Platform League](http://www.tzi.de/spl/bin/view/Website/WebHome) (SPL). This league requires all teams to use only Aldebaran Nao robots and the competition involves programming them to play soccer autonomously. Read on to find out how our robots performed and how they work or scroll to the bottom if you just want to see pictures.

## Penn’s performance

Our team from Penn managed to do pretty well this year. We made it to the quarterfinals (out of 24 teams) and lost in that round to the team that would become the eventual champions. This is the best our team has done in several years and it was a great experience to get to be a part of.  Check out one of our matches below!

{% include embed/youtube.html id='r8tikQlTfRA' %}

There are four major tasks that each robot has to do well in order to play robotic soccer: vision (seeing the ball, the field lines, and other robots), localization (determining where the robot is on the field), locomotion (walking and kicking), and behavior (individual player strategy as well as team strategy). During this year’s competition, we were able to do all of these tasks with various degrees of success.

The vision system was able to detect all of the lines and features on the field very well and could usually find the ball. We had a lot of trouble when the ball was really far away and close to a field line because both the ball and line are white, which made the ball hard to distinguish from the line. Our vision system could not do any sort of robot detection, which means that our robots simply played soccer under the assumption that no other robots were on the field. This was obviously an incorrect assumption, but it was a simple and easy approach as detecting other robots is actually very hard.

The localization system worked very well this year. In previous years we had problems with the robots getting ‘flipped’ (basically attacking their own goal by accident) but we were able to take advantage of a new sensor the robots had in order to drastically cut down on the ‘flipping’ incidents (more on how this works later). Since the vision system did such a good job at detecting lines on the field, we were able to use these lines and other field features to help the robot figure out where it was at almost all times. The system definitely wasn’t perfect, but our robots were surprisingly good at keeping track of their locations on the field.

The locomotion system was probably our weakest link at the competition. Much of the locomotion code is several years old and nobody on our team knows how it really works or how to adjust it. Our robots walked very slowly, tended to be unstable, and fell over a lot. Additionally, we had problems with the hip joints overheating after the robots had been playing for a long time. We have been working on new code to address a lot of these problems, but it wasn’t ready in time for the competition. 

The behavior system worked well enough, but there is a lot of room for improvement. The biggest thing that the behavior system needs to do is make sure that one player is always going for the ball. If any of the good teams in the league are given any space or time to walk up and aim the ball, they will almost always score. Unfortunately, we had some problems where sometimes several players would see the ball, but none of them would go for it and we weren’t really sure why. Sometimes they would back up like they were trying to play a defender position or sometimes they would just stand there and look at the ball but not do anything. The behavior system is relatively large and complicated and during the competition we were not able to hunt down the source of this problem.

## My contributions

My main focus for the months leading up to the competition and at the competition itself was improving the localization system. This year we finally upgraded all of our robots to the Nao Version 5 instead of having some Version 5 and some Version 4. The Version 5 robots have a crucial yaw axis gyroscope which means the robots can detect when they turn left or right. Using this sensor allowed the system to track the orientation of the robot during the match much more accurately and prevent the dreaded ‘flipping’ scenarios almost entirely.

The operating system on the Nao does some internal computations to keep track of the roll, pitch, and yaw angles of the robot based on an accelerometer and gyroscope. The biggest issue that I ran into is that the yaw angle could drift over time (this is because gyroscopes inherently drift and, since the robot is almost always vertical,  the accelerometer can hardly ever correct the drift in the yaw direction). In order to compensate for this drift, I introduced a yaw error value into the system that would attempt to estimate how far the angle had drifted. It worked by updating this error value every time it saw a landmark like a line, corner, or the center circle. This update would consider all possible angles the robot could be at given the landmark it had seen. Once it found the most probable angle, it compared that to the angle given by the internal sensors and found the error between them. This error could then be used to update the yaw error term to give a more accurate angle estimate.

## Future work

Even though our team did relatively well at the competition this year, we still have a lot of things we can improve on for next year. Our locomotion system desperately needs an overhaul so we can walk and kick as quickly and accurately as some of the better teams. Our vision systems needs improvement to detect the ball more accurately when it is far away as well as detect robots on the opposing team. Our behavior system needs to be simplified and streamlined in order to make sure we get one robot on the ball at all times. Our localization system needs fine tuning and testing to be more accurate and reliable. And lastly, we need to add more debugging and logging tools to our arsenal so that we can more easily diagnose and fix bugs and problems. If we can work on improving many of these things, I think we have a very good chance of making it to the semi-finals or even finals next year!

## Picture gallery

Here are some pictures of stuff that was going on at RoboCup 2016!

![](/assets/MyFirstComputerBuild/parts.jpg)
_Our team: humans and robots_

![](/assets/MyFirstComputerBuild/parts.jpg)
_Our team: humans and robots_

![](/assets/MyFirstComputerBuild/parts.jpg)
_The venue: Leipzig-Messe_

![](/assets/MyFirstComputerBuild/parts.jpg)
_The venue: Leipzig-Messe_

![](/assets/MyFirstComputerBuild/parts.jpg)
_Getting the robots ready for action_

![](/assets/MyFirstComputerBuild/parts.jpg)
_Getting the robots ready for action_

![](/assets/MyFirstComputerBuild/parts.jpg)
_Robots from all teams around the world_

![](/assets/MyFirstComputerBuild/parts.jpg)
_Robots from all teams around the world_

![](/assets/MyFirstComputerBuild/parts.jpg)
_Our robots getting 'interviewed' by CNET_

![](/assets/MyFirstComputerBuild/parts.jpg)
_Our robots getting 'interviewed' by CNET_

![](/assets/MyFirstComputerBuild/parts.jpg)
_Robots ready to play a match_

![](/assets/MyFirstComputerBuild/parts.jpg)
_Robots ready to play a match_

![](/assets/MyFirstComputerBuild/parts.jpg)
_The main SPL field_

![](/assets/MyFirstComputerBuild/parts.jpg)
_The main SPL field_

![](/assets/MyFirstComputerBuild/parts.jpg)
_The main Mid Sized League field_

![](/assets/MyFirstComputerBuild/parts.jpg)
_The main Mid Sized League field_

![](/assets/MyFirstComputerBuild/parts.jpg)
_Mid Sized League robots_

![](/assets/MyFirstComputerBuild/parts.jpg)
_Mid Sized League robots_

![](/assets/MyFirstComputerBuild/parts.jpg)
_Adult Sized Humanoid League Robot_

![](/assets/MyFirstComputerBuild/parts.jpg)
_Adult Sized Humanoid League Robot_

![](/assets/MyFirstComputerBuild/parts.jpg)
_Humanoid Rescue Robot_

![](/assets/MyFirstComputerBuild/parts.jpg)
_Humanoid Rescue Robot_

![](/assets/MyFirstComputerBuild/parts.jpg)
_Closing Banquet_

![](/assets/MyFirstComputerBuild/parts.jpg)
_Closing Banquet_
