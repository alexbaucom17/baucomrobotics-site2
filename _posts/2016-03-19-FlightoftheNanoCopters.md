---
title: Flight of the Nano-copters
date: 2016-03-19 12:30:00 -0700
categories: [Projects]
tags: [robotics]     # TAG names should always be lowercase
---


For one of my classes at Penn, I got a chance to learn all about how to make quad copters autonomous. All the 'drones' that have been becoming popular recently are almost all radio controlled, with some of the more expensive ones having a few layers of autonomy between it and the user. But for this class, we wanted to figure out how to make the quad completely autonomous - we wanted to get to a specified point without hitting obstacles with no other human input. We can do this by breaking this problem into three smaller parts: control, obstacle avoidance, and motion planning. These parts are discussed some more below, but first here is a video of our code running on a small quadcopter in Dr. Vijay Kumar's lab. In this video the quad was told to navigate to a series of waypoints that formed a spiral and it reached them all successfully and autonomously.

{% include embed/youtube.html id='vXQ08AYLwYQ' %}


## Control

All quads (even RC ones) have to have a controller. And no, I'm not talking about a physical controller with buttons. The controller is a set of mathematical equations that lets the human fly the quad in the X, Y, Z, and yaw directions, as opposed to having to operate each motor independently - that would be impossible! For our autonomous quad, we want to control exactly the same things: the XYZ position and yaw orientation. Since the quad is symmetrical, we can basically just ignore the yaw and concentrate on getting the quad to the right position. 

I'll spare the gritty details (unless you want all of them - [this](https://robo.fish/wiki/images/d/dd/Trajectory_Generation_and_Control_for_Quadrotors_Daniel_Mellinger.pdf) is Daniel Mellinger's dissertation which is a very, very detailed description of everything I am discussing), but we also need to control the pitch and roll of the quad in order to move in the X and Y directions. Due to some nice properties of the system, we can calculate the pitch and roll based on what our desired X and Y velocities are. Then, using a lot of math, we can simplify everything to a set of equations that, when given a desired position, velocity, and acceleration in 3D, can take these desired values, along with the actual values measured by sensors, and tell us how fast the motors need to spin to make that happen. Neat!


## Obstacle Avoidance

So now we can tell our quad where to go and how fast to go there - but what if we tell it to go somewhere were there is an obstacle? Or what if there is an obstacle in the way of where we tell it to go? We want our quad to be able to avoid these obstacles automatically. Due to the complexity of obstacle avoidance, this class only covered static environments where all the objects in the environment are known.

There are many different ways to tackle this problem, but one of the simplest is to make a grid and only allow the quad to travel into cells with no obstacles in them. There are drawbacks to this approach but if the obstacles are sufficiently large and you pick a reasonable grid resolution, then it actually works really well. Once all of the cells without obstacles in them have been identified, a graph search algorithm such as Dijkstra's algorithm or A* can be used to find the shortest path to the goal. Since we have restricted the search to only open cells, this path will automatically avoid obstacles.

One practical thing that must be considered is the size of the quad and the obstacles relative to the grid size. If our quad is, for example, 50 cm in diameter and we choose a grid size of 10 cm, we will run into problems (literally...). Since our quad encompass 5 cells we cannot say that a cell immediately next to an obstacle is empty or it will crash into the obstacle when trying to fly into that cell. So, we either need to adjust our grid size or implement some padding around the obstacles that will provide enough margin for the quad to fly safely in any cells we mark as empty.

## Motion Planning

Just because we now have the shortest safe path through the space doesn't mean that is the best path to fly. It could have lots of right angle turns or zigzag in places we could just fly in a straight line. So now what we want to do is take that optimal path in the grid world and make a smooth, continuous trajectory in the real world for the quad to fly that reasonably follows the optimal path.

The first step to do this is to simplify the path. There are many ways to do this, but a simple way is just to find the longest straight line segments between points on the path. This will make the quad start wherever is is and fly straight for as long as it can and then turn onto another path that will go straight for as long as it can. This works well for large, open spaces with few obstacles where there aren't many tight turns needed. A more clever method would be required for a small space needing precise maneuvers. 

Once we have reduced this path to a few essential points, we can actually plan a trajectory. To make it really smooth with no abrupt motions, we can use a motion called a cubic spline. This makes the trajectory position, velocity, and acceleration a polynomial function which ensures that there are no jumps or spikes in the commanded values. For every set of points, we can generate a set of polynomials that will connect them by putting constraints on the position, velocity, and acceleration at each point. Then, using a lot of math again, we can solve for polynomial functions that satisfy these constraints and then we have a nice smooth trajectory that will go through each of the points we specified!

The video below shows all of this in action. The black path is the optimal path generated by the path planning algorithm. The big blue dots are the simplified path found by finding the longest straight line paths. The blue and red trails from the quad are the actual path it flies using the controller (blue is the desired position and red is the actual position).

{% include embed/youtube.html id='k99iDmmlUww' %}

## Improvements

As cool as all of this is, there is still a lot of room for improvement. In the simulation video, you can see that there are a lot more blue dots on the straight line path then there really needs to be. This is because with the cubic spline implementation I had, if points were too far apart, the quad could veer off the path since only the points it had to reach were specified. Even in the video you can see the quad doesn't always stay along the straight line path, especially on turns. Part of this is the fault of the cubic spline and the math behind it, but part of it is due to poor choices of straight line points. The path has quite a few right angles that pose challenges for the robot and a more clever algorithm to simplify the optimal (black) path could help a lot in keeping the robot on course.

Also, this system assumes we know the exact position and velocity of the quad at all times: that is how the controller can even work at all. To achieve that, we have to have a special room with really expensive motion capture equipment that lets us get that exact information. The next section of this class deals with how to use cameras and sensors on board the quad to try to reproduce some of that information so we could fly somewhere without the expensive motion capture equipment.