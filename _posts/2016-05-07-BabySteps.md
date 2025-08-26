---
title: Baby Steps
date: 2016-05-07 12:30:00 -0700
categories: [Projects]
tags: [robotics]     # TAG names should always be lowercase
---

Have you ever thought about how hard it is to walk? It's not something we often think about but, in reality, walking is incredibly difficult! Each step takes coordination between your brain and all the muscles in your legs. Each muscle has to move and contract in the proper sequence to move your leg out, place it on the ground, move forward, and repeat. Not only does your brain have to coordinate your leg motion, but your hips and torso also have to move so that your center of mass remains supported by the current leg that is touching the ground. Lastly, if there is any unevenness in the floor or you trip over a crack in the sidewalk, your brain needs to (very quickly) determine where to put your legs and arms to either catch yourself and prevent a fall, or protect yourself as you fall. It is an incredible and complicated process and when you try to teach a robot how to do it, this complexity really shows.

As part of my work at Penn I have worked on biped locomotion with Penn's RoboCup team. Our goal is to get a group of Aldebaran Nao robots to play soccer, and it is quite challenging. These robots have to be able to identify a soccer ball, walk to it, kick it (towards the opponent's goal hopefully), and eventually get the ball into the goal. A big part of all of this requires the robot to be able to walk smoothly without falling over. Unfortunately for our team, the current walk is not very stable and the robots tend to fall over quite often. So, one of the other students and I began learning all about bipedal locomotion in hopes of figuring out how to help fix this problem. 

One of the biggest problems with our current system is that the robots don't have a great way to balance themselves and so if they think they are beginning to fall, they simply freeze in place and hope they don't fall. You can see how well this works in the video below:

{% include embed/youtube.html id='3nQkBoIdSag' %}

What we really need for these robots is better closed loop feedback. We need a way for the robots to know where they are and, if they get bumped or encounter another disturbance, figure out how to adjust their motion to prevent themselves from falling.

One way the robot can sense its stance is by using the encoders in all of the motors. If we can measure what angle all of the motors of all of the joints are at, we can use a technique called forward kinematics to figure out the location of each joint in 3D space. Then, since we know the mass of each of those joints, we can calculate where the center of mass of the robot is and where each of the feet are. Once we know where the center of mass is relative to the feet, we can determine if the robot is stable or not and then calculate the appropriate actions to take to keep it stable.

Another way we can help the robot determine if it is stable is by using the on-board gyroscope and inertial measurement unit (IMU) that the robots have in their chests. Currently, the system does use the gyroscope a little bit, but it appears to only be for very small corrections and determining if the robot is starting to fall. What we would really like to do is use the gyro and IMU to help determine how the center of mass of the robot is moving. Using the joint angles we can get an estimate of the position, but it is hard to determine how fast the center of mass is moving with just the joint angles. But, by using data from the gyroscope and IMU we can estimate the velocity fairly easily. Estimating the velocity is important because the robot can make different corrections based on how fast it is moving and the more information we can get about how it is positioned and how it is moving, the more accurately we can calculate what actions to take to remain stable.

One final feedback we can implement is footstep feedback. The Nao has pressure sensors in its feet which can let it know when its feet have touched the ground. Our system currently doesn't do anything with these sensors but they would be very helpful for letting the robot know if its foot touched the ground at a different time than it was expecting and to be able to correct its timing for the future.

All of these are ideas we have been researching and reviewing in order to determine the best way to get our robots walking stably. We have begun the actual implementation of the motor angle feedback as well as a general overhaul of the current walking code so that it is well documented for the future. Hopefully in the next couple months we can get everything up and running (or should I say walking) well with improved stability and less falling!

-------------------------------

If you want to read a more in depth review of a few different walking methods that we reviewed, you can read [this paper]({{ '/assets/BabySteps/projectReport.pdf' | relative_url}}) that I wrote.