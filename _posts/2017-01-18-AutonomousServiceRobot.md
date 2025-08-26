---
title: Autonomous Service Robot
date: 2017-01-18 12:30:00 -0700
categories: [Projects]
tags: [robotics, ros]     # TAG names should always be lowercase
---

## Introduction

This past semester I got a chance to work on a really cool project that involved designing service robots to roam the halls of Penn and help people with various tasks. At the beginning of the semester, we were basically given a standardized hardware platform with no real software capabilities designed yet so it was up to our class (about 12 students) to design all of the core functionality and integrate it together into a functional robot by the end of the semester. We broke up into 3 focus groups: navigation, vision, and manipulation. These focus groups each developed basic functionality for the robots for about 1/4 of the course. The last ¼ of the course was all about integrating the focus group software into one cohesive system and actually getting the robots to complete various tasks.

The hardware platform we used is show in the picture below. For more details on the hardware, please refer to [this paper](https://www.seas.upenn.edu/~eeaton/papers/Eaton2016Design.pdf). We used the Robot Operating System ([ROS](https://wiki.ros.org/)) as the messaging framework.

![](/assets/MyFirstComputerBuild/parts.jpg)
_The standardized hardware platform: Kobuki Turtlebot base, Intel NUC, Microsoft Kinect, Hokuyo URG-04LX Lidar (not pictured, normally mounted on the white velcro strips)_

## Navigation

I was part of the navigation focus group and it was our job to enable the robot to explore and navigate the environment, which in our case was primarily the hallways of the Levine Building at Penn. Due to the open-source nature of ROS, many of the core navigation functionalities already had software packages written, so we didn’t have to reinvent the wheel when it came to [exploration](https://wiki.ros.org/hector_exploration_planner), [SLAM](https://wiki.ros.org/gmapping), [localization](https://wiki.ros.org/amcl), or [motion planning](https://wiki.ros.org/move_base). However, we did have to link these existing software packages together and tweak them to make them work for our applications, which was not a trivial task.

The major problem we ran into was building maps and localizing in long, featureless hallways (at least featureless according to a lidar). Since long hallways were the primary environment that these robots were to be operating in, this posed quite a challenge. We tried experimenting with various software packages, spent many hours tweaking parameters for each of the packages, and researched adding supplementary sensor streams such as wifi or vision. Due to time constraints, in the end we had some software and a set of parameters that was passable, but not as robust as any of us really wanted. The robot could build great maps and drive around with very few problems in feature-rich areas, but would often get lost and confused when driving straight down a hallway. I will be continuing work on this project during this semester as an independent study and this is one of the primary areas I would like to research further and ideally improve.

![](/assets/MyFirstComputerBuild/parts.jpg)
_One of the maps we made that shows some of the issues we had. Many of the straight hallways sections are too short and curved slightly. Also, the loop closure is fairly poor here._

One of the custom pieces of software my group worked on was a map labelling service. Instead of needing to give exact coordinates for the robot to move to, it is much more natural for humans to give a location name. We designed a system that could label various points on the map and use the label names to give the robot directions as to where to go. For one of our demos we also had fun integrating this label service with Amazon’s Alexa so that we could give voice commands to the robot.

{% include embed/youtube.html id='Ht-k5_tc5kA' %}

## Team Integration

For the team integration portion of this project, our team chose to make our primary task a pickup and delivery task. The idea is that a user could ask the robot to do something like go get some coffee from the break room or deliver a note to someone in a different part of the building. Unfortunately, due to time constraints and limitations based on what the focus groups were able to achieve, we were only able to put together a basic delivery system. However, the idea of this project is to pass off our work to the next group of students so the framework and core functionalities were far more important than the actual execution of the task.

The core of our system integration was something we called the Executable Task Description Framework. When brainstorming various tasks for the service robots to do, we realized that many of the high level tasks that we wanted the robots to do could be broken down into individual subtasks fairly easily. By tying these subtasks to things that the robot could directly execute (such as go to a location, recognize a person, or grab an object), the actual task execution could be described as a series of these subtasks. Once we made this framework and defined a variety of subtasks, creating different high level tasks was just a matter of linking the subtasks together in a reasonable order. This framework made it very easy to add new subtasks and high level tasks.

One drawback of this approach is that it would likely be difficult to represent tasks that required complex logic or dynamic subtask transitions. However, for the type of simple service tasks we were working on, this approach was more than sufficient.

{% include embed/youtube.html id='R6E29iKANF8' %}
 
## Conclusion

Overall, this project was a great hands-on experience of the challenges of designing an entire robot system. In classes we often focus on one small aspect of the system and how it works but in this course I got the chance to explore every level of the system and figure out how to make all of it work together. I am excited to continue this work during the upcoming semester and hope to make a lot more progress with these robots!