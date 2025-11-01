---
title: Domino Robot Hardware Overview
date: 2021-07-25 12:30:00 -0700
categories: [Projects]
tags: [robotics, dominorobot]     # TAG names should always be lowercase
image: /assets/DominoRobot/HardwareOverview/preview.jpg
---



The final hardware of ‘Dominator’ the Domino Robot has a lot of parts to it. The main body is built from an 80/20 frame with a steel base plate which the drive system is mounted to. There is a large tray on the front of the robot that is used to hold 300 dominoes (15 wide by 20 high) in a grid. The 3d printed funnels on top are used to allow the dominoes to fall into place in the grid more easily. There is also a large counterweight on the back of the robot to ensure the rear wheel keeps enough traction on the ground to avoid slipping.

![](/assets/DominoRobot/HardwareOverview/front_view_annotated-1.jpg)

Speaking of wheels, the whole robot runs on 3 omnidirectional wheels that are spaced at even intervals of 120 degrees. Special control of these wheels allows for the robot to move freely in any direction (the fancy robotics term for this is a ‘[holonomic](https://www.robotplatform.com/knowledge/Classification_of_Robots/Holonomic_and_Non-Holonomic_drive.html)’ system), which is critical for precisely aligning with the dominoes when preparing to place the next tray. The motors are driven by [ClearPath motors](https://teknic.com/products/clearpath-brushless-dc-servo-motors/) which are super accurate and quite powerful for their size. The motors connect to the wheels through a 1:4 belt drive which allows the wheels to provide enough torque to move the robot (it weights ~200 pounds). All of the motors (drive motors and lifter motor) are powered by a pair of 24V 20AH LiPo batteries.

![](/assets/DominoRobot/HardwareOverview/side_view_annotated-1.jpg)

As for electronics, the main ‘brains’ of the robot run on a Raspberry Pi 4 which handles all of the high level communication, heavy calculations, and decision making. It is connected via a USB hub to both of the downward-facing IR cameras, the [Marvelmind](https://marvelmind.com/) indoor GPS sensors, and the [ClearCore](https://teknic.com/products/io-motion-controller/) motor controller. This motor controller handles the lower level control for both the drive system and the tray lifter. It also handles the simple I/O such as the tray servo, manual tray buttons, and tray optical endstop. All of this is powered from a 22.2V LiPo battery which is regulated down to 5V for the devices that need it.

![](/assets/DominoRobot/HardwareOverview/top_view_annotated-1.jpg)

That’s about it for the major hardware components of the robot. Consider checking out the major [software components]({% post_url 2021-07-24-DominoRobotSoftwareArchitecture %}) next!

This is a [broken link](https://www.baucomrobotics.comf/page_that_doesnt_exist.html) test.
