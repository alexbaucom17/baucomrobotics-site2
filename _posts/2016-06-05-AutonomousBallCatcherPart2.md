---
title: Autonomous Ball Catcher Part 2 - Software
date: 2016-06-05 12:30:00 -0700
categories: [Projects]
tags: [robotics, lego]     # TAG names should always be lowercase
math: true
---



If you have read my previous post you will know that I recently built an automated ball catcher and programmed it to track and catch a ball. In that post I showed off the hardware and a video of it in action, so check it out [here]({% post_url 2016-05-24-AutonomousBallCatcherPart1 %}) if you missed it! In this post I will talk about the software behind making the catcher work. If you would like to look through the source code itself, you can find all if it on my [Github page](https://github.com/BaucomRobotics/BallCatcher).

I used MATLAB as the main coding environment, mostly because I am very familiar with it and it is great for doing all sorts of high level programming. To communicate with my Lego NXT, I downloaded a toolbox which you can find [here](https://www.mindstorms.rwth-aachen.de/). This let me do stuff like read the sensors and control the motors through the NXT. The structure of the software can be broken down as follows: initialization, image analysis, flight path analysis, and cart control.

## Initialization

The initialization here was pretty standard. I defined a lot of parameters and variables, established communication with the NXT, and prepped the camera to grab frames. The hardest part of the initialization was the camera calibration. MATLAB has a nice built in calibrator that makes getting the intrinsic parameters of the camera pretty easy, but it took a while for me to figure out how to get all the extrinsic parameters needed to use the camera projection equation (more on that later).

What I ended up doing was manually selecting points in my image that would form parallel lines in the horizontal and vertical directions. From these lines I could find the vanishing points of the image and then compute the rotation matrix for the camera. The translation vector was just measured since both the location of the camera and the launcher were static and known positions.

Once all the parameters of the camera had been determined, the last couple steps of the initialization were to determine the starting location of the cart and then launch the ball. I used the ultrasonic sensor to measure the starting location of the cart. Since I defined the location of the launcher to be the origin of my world coordinate system, I needed to know where the cart was starting from in order to take that extra distance into account when figuring out how far it needed to move. After all of the initialization was done, I sent the command to the launcher motor and let the ball fly!

## Image analysis

Once the ball launched, the main loop of the program could begin. The first thing I did each time through the loop was grab a new image from the camera. This was by far the slowest part of the program and was the main thing preventing my program from being more accurate. Even though my camera could record at 30 fps, it could only ever get 10-15 fps when used in my code. I don't totally understand why this happened but I think it had something to do with how MATLAB handled getting images from the camera. This obviously made it a bit trickier to catch the ball when I only had 10 or so frames to work with.

Once the image was received, it was color segmented (using the built in color thresholder app which is super useful!) to isolate only the red of the image, which was just the ball. This made it really easy for a simple blob analysis to be performed (using the built in MATLAB function) and the location of the ball in the image to be determined. Once the centroid of the ball in pixel coordinates was known, the location then had to be converted to real-world 3D coordinates. This was done by taking the standard camera projection equation:

$$ \lambda x = K [R|t]X $$


And inverting it to solve for the world coordinates

$$
X = R^T{K^{-1}\lambda x - t}
$$

This was a fairly simple calculation since all of the parameters were known from the calibration step during initialization. Once I had the 3D coordinates of the ball, I could try to determine where the ball was going to land.

## Flight path analysis

In order to figure out where the ball was going to land, we need to go back to high school physics. We know that a projectile in the air is subject only to the acceleration due to gravity (assuming we ignore air resistance, which is a safe assumption here). In physics we learned that in the vertical direction we can model projectile motion with a second order polynomial. Also, we can model the motion in the horizontal direction as a first order polynomial.

Armed with the power of high school education, I could use MATLAB’s polyfit function to fit a second order polynomial to the data in the y direction (time vs height) and a first order polynomial to the data in the x direction (time vs distance).  I could then find the roots of the time vs height function, and that gave me the time the ball would hit the ground. One of these values was always be negative due to the setup of the launch, so I could just ignore that. Once I knew what time the ball would hit the ground, I plugged that time into the time vs distance function to figure out how far away from the launcher the ball would be when it landed. With this information, I could now tell the cart where it needed to get to in order to catch the ball. The idea was that with each iteration through the loop, there would be another point to add to this model that should get the landing estimate more and more accurate over time.

A couple side notes here. First, this model needed to be corrected for the height of the cart and the launcher to find the correct time and distance. Second, this model would only work once 3 data points were acquired, since 3 points are needed to fit a parabola, so this section of the code had to wait until there were 3 frames with the ball detected before running. Lastly, due to the previous note, the cart didn’t know where to go until 3 frames with the ball had been captured. Since the NXT motors could not be geared up enough to get to the ball in time if if waited until this 3rd frame to start moving, I implemented a ‘default landing distance’ that was an estimate of where the ball landed on average during my tests. This default distance would at least get the cart moving in the right direction and was corrected for later once the analysis could be performed.

## Control

That last thing I needed to do was to tell the cart how to get to the estimated landing location. I did this by converting the distance from millimeters to degrees by using the circumference of the cart wheels and the gearing ratio. Once I knew how many degrees the cart motor needed to rotate, I could read the encoder on the motor and see how close it was to that number of degrees. This difference, or error, was then by multiplied by a gain to make a simple proportional controller. This controller told me how much power to send to the motors proportional to how close the cart was to the landing zone. Once the error was small enough,  the motors stopped and I hoped the ball landed in the basket!

## Conclusion

Once the ball had either landed in the cart or missed and hit the ground, the loop exited and some simple post processing was done. First, an image showing all of the detected ball locations was compiled and displayed. And next, a plot of all the estimated flight paths was created. Both of these can be seen below. Once those images were made, all the variables were cleaned up, the camera was released, and the NXT was disconnected. And that is about it!

I hope that was interesting and informative and gave you a glimpse into how this whole system worked. Again, if you want to look at the code in more depth or use parts of it in your own system, feel free to check out the [Github page](https://github.com/BaucomRobotics/BallCatcher).

![](/assets/MyFirstComputerBuild/parts.jpg)
_A composite image showing all of the detected ball locations in white. Some of the detections look like streaks due to the motion blur from the camera so the centroid of the detected area was used as an estimate of the ball's location._

![](/assets/MyFirstComputerBuild/parts.jpg)
_A graph showing the estimated trajectories of the ball. The motion blur error caused the first estimate with only three points to be upside-down, but you can see the rest of the landing estimates converging nicely over time._
