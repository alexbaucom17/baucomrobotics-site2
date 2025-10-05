---
title: Robust Mobile Robot Navigation
date: 2017-05-09 12:30:00 -0700
categories: [Projects]
tags: [robotics, ros]     # TAG names should always be lowercase
---

As I talked about in one of my [previous posts]({% link _posts/2017-01-18-AutonomousServiceRobot.md %}), I have been working on mobile robot navigation for an autonomous service robot project. During the Fall semester, the navigation team was able to successfully enable the robot to navigate the hallways, albeit with quite a bit of last minute hacking. This past semester, I have been continuing work on the navigation system as an independent study research project and I was able to actually achieve robust navigation!

For our purposes, we defined 'robustness' to be the ability to reliably do the following:

- Build good quality maps
- Maintain localization during navigation, even in crowded or featureless areas
- Navigate to goals while avoiding obstacles
- Recover appropriately from collisions with unexpected obstacles or path obstructions
- Run for extended periods of time in unsupervised, real-world environments

To build good quality maps, we switched from [gmapping](https://wiki.ros.org/gmapping) to a new package from Google called [Cartographer](https://google-cartographer-ros.readthedocs.io/en/latest/). With a bit of tuning (including some very helpful tips from the developers themselves), the robot was able to build incredibly detailed and accurate maps like the one here.

![](/assets/RobustNavigation/towne_levine_full.png)
_A large scale, high quality map made by Cartographer. The map is about 90m long and 70m tall._

With the better quality map, the robot was able to maintain its localization in the hallways very easily since the map matched the real world so accurately. However, it would still sometimes have trouble extricating itself from a crowded area with lots of obstacles if it accidentally ran into something. To solve this problem, we switched to a new local planner called [teb_local_planner](https://wiki.ros.org/teb_local_planner), which is a far better planner than the default planner that many people use. This planner avoids obstacles very well and can handle backing up to go around an unexpected obstacle with ease. You can see it in action in the video below. 

{% include embed/youtube.html id='pcN7uQKB4n8' %}

Even though this planner is great at getting out of sticky situations, it sometimes still fails. In that case, the default behavior is to just stop and wait for a new command. But stopping dead in the middle of the hallway is not really ideal behavior for a robot. So, I designed a robust controller to handle these failure states and try alternative recovery methods. If these still fail, then the robot will simply return to some home position (such as the charger) and wait for new instructions there. This process is implemented as a finite state machine as shown in this diagram.

![](/assets/RobustNavigation/RobustNavFlowchart.png)
_Finite state machine diagram for robust navigation package_

Once all of these changes were made to the navigation system, I designed a small 'torture test' for the robot. I labeled many locations in a map and had the robot randomly choose a point to navigate to, go there, pick a new point at random, and repeat. Over the course of two hours the robot visited 50 locations and drove an estimated 2 km. Despite all of this, the robot did not have a single incident where it got lost or stuck, even though it was driving through crowded hallways and several students tried to mess with the robot by jumping in front of it. You can see the test in action (including one student's attempt to confuse the robot) in the video below.

{% include embed/youtube.html id='gLFzHBPRMmU' %}

With the success of the torture test, I had met all of the objectives required for 'robust navigation' and was able to end the project on a good note. Overall, I am very pleased with how much progress I was able to make on the navigation system from last semester. It was a lot of fun to work on and to get to see all parts of the navigation system come together and work well. It is also exciting to know that much of this work will be used as the basis for future classes and projects with these service robots. I hope to get a personal tour from one of the robots when I come back to visit Penn sometime!

 If anyone is interested, a lot more information, including all of the code, is publicly available on [Github](https://github.com/GRASP-ML/ServiceRobots).
