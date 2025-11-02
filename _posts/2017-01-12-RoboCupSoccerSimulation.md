---
title: RoboCup Soccer Simulation
date: 2017-01-12 12:30:00 -0700
categories: [Projects]
tags: [robotics, robocup]     # TAG names should always be lowercase
image: /assets/RobocupSimulation/preview.jpg
---

## Introduction and Background

Robots are complicated and don’t always work correctly. That is why it is often far easier to do robotic design work in a simulation – they work perfectly every time there. This is an issue we have run into with our RoboCup team. Running all of the robots at the same time is quite an ordeal and it can be very hard to get useful tests completed if robots keep malfunctioning for whatever reason. It is even harder if we want to test edge cases where the robots need to be in a very specific configuration.

Previously, our team did not have any easy simulation tools, especially for testing behavior algorithms or strategies, which often require all the robots to be running for useful analysis. So, I took it upon myself to build such a simulation.

I started with the goal of making a simulation that our team could use to quickly prototype and test different behavior strategies before implementing them on the real robots. This would ideally allow us to try a wide variety of strategies and compare them to see which ones might be the best. The simulation did accomplish this but, in the end, this also turned into a much larger machine learning project as well.

## Simulation Details

The simulation itself was written in MATLAB and contains four main components: the game controller, the ball, the world, and the players. The game controller handles all of the high level simulation details. The ball, world, and players are all defined as objects which the game controller instantiates and updates at every time step. The game controller also utilizes several other utility functions that handle field animation, detecting collisions, and resetting the ball or players when they go out of bounds.

The ball object is fairly simple. It keeps track of the ball's location and velocity on the field as well as the last player to touch it (for enforcing out of bounds rules). When the ball is kicked or collides with an object, it is given a velocity based on the kick strength or the collision physics. The ball update method then simulates the ball motion at each timestep and performs deceleration of the ball based on a configurable friction parameter.

The world object contains all of the information about the state of the world. It gathers data from each player and the ball and aggregates all of it into 'observations' that the players can make about the world. This centralized world model allows the simulation to run significantly faster than having every player object make these 'observations'. The world object also is fully configurable with regards to the noise of player observations. Parameters can be set to allow players to have a perfect observation of the world or a very noisy observation. This allows for testing the robustness of different positioning methods to noise in the environment and observations. Lastly, the world object also handles dynamic player role switching. Once again, this computation was centralized in order to speed up the runtime of the simulation. However, care was taken to ensure that the algorithm was implemented in a way that would not make the role switching behave any differently than if the computations were performed locally on each robot (since each robot does its own computations during a match).

The player object is the most complicated class in this simulation. Each player makes an ‘observation’ by querying the world object and then uses this information in a behavior function to determine what it should do. The behavior is primarily responsible for setting a desired velocity. The actual velocity is then computed from the desired velocity based on acceleration and the maximum velocity of the player. The behavior function for each player is a simple finite state machine that has states for searching, approaching the ball, kicking, and moving. The move state calls a function handle that was given to the player at initialization which allows for specifying different movement strategies for different players. This function is responsible for taking in information about the world and specifying a desired velocity for the player to execute.

Below is a video of the simulation in action. Feel free to watch it at 2X speed as the rendering was a bit slow. The player behavior here is fairly simplistic as it was still in early development when this was recorded.

{% include embed/youtube.html id='HoWtrkSvRUk' %}

## Potential field functions

Once the basic simulation was completed, I decided to try designing new types of player positioning systems to hopefully improve the overall team strategy. One of the methods I explored in depth was potential field functions.

Potential field functions are quick to compute and offer a lot of flexibility in defining positioning strategies. My implementation defines one positioning function and the weights of the function change depending on the player’s role. This one function is made up of several heuristic functions that define how attracted or repelled a player should be from different features such as the sidelines, the ball, other players, etc. Since these functions are all additive, it is straightforward to create more heuristic functions and add them to the main function.

The key aspects of the potential field function that have to be hand-designed are the metrics to measure as part of computing the potential field. Starting from the work of Vail and Veloso and building upon it through trial and error, I came up with the following metrics to use: distance to each sideline, distance to each teammate, distance to the ball, distance to the attacking shotpath (defined as the vector from the ball to the center of the attacking goal), distance to the defending shotpath (defined as the vector from the ball to the center of the defending goal), distance to the attacking goal, distance to the defending goal, and an interaction term that is a function of the distance to the attacking shotpath and the distance to the ball.

Each heuristic has its own set of weights for each role and the total function is simply a sum of all the weighted attractive and repulsive functions. The functions for each role are machine generated before running the simulation for runtime optimization. During the simulation, each player only has to calculate the metrics previously mentioned and then pass them into the proper function for their role. Local gradient descent on the potential function is used to determine player velocity and they have reached the ‘desired position’ whenever the reach the field minimum. Local minima is not a major concern due to the dynamic nature of the environment.

![](/assets/RobocupSimulation/attacker_pff.jpg)
_Visualization of the potential field function for the attacking player. A rough estimate of the path the player would take if the environment remained static is shown in red._

![](/assets/RobocupSimulation/defender_pff.jpg)
_Visualization of the potential field function for the defending player. A rough estimate of the path the player would take if the environment remained static is shown in red._

## Learning details

While it is possible to hand tune parameters for each role of the potential field function, I wanted to see if the simulation could be used to learn better parameters. To do this, the simulation was modified to accept a vector of weights as an input and output a score that reflects how well each team performed. This score was based on the number of goals scored by each team, whether they were own goals, and how often players went out of bounds.

The [Nelder-Mead simplex learning algorithm](https://www.scholarpedia.org/article/Nelder-Mead_algorithm) was chosen for learning since it was easy to implement and, most importantly, doesn't need large numbers of function evaluations to converge. Due to the linear nature (time-wise) of the simulation, massive parallelization was not an option and so every effort was made to optimize the simulation code; however, a 10 minute match still required about 20 seconds to run on a single thread of an i5 desktop processor. This made it important to use an algorithm that minimized the number of required function evaluations.

Even with all of these optimizations I decided it was not feasible to run the number of trials I needed on my personal desktop. So, I decided to run the simulation on AWS where there is a lot more compute power and I can still use my own computer while the simulation runs. Unfortunately, due to some weird issues with MATLAB and AWS I have not been able to run the full simulation yet. However, some preliminary qualitative analysis of small scale runs indicate that the learned positioning is improving the performance of the team as a whole. Intelligent behaviors such as the supporter moving to empty space in anticipation of a rebounded shot or the defenders working together to block more of the goal are appearing occasionally in testing, which shows promise for this method.

## Future work

This project became a lot bigger and more involved than I had anticipated when I set out to build a simulation tool for our RoboCup team. I have learned a ton about motion planning, multi-robot coordination, optimization, and machine learning. I hope to get the simulation running on AWS soon and see if the learning really can improve performance in this case. I will be sure to update this post if/when I get those results. In the mean time I am going to start working on taking some of what I learned from all my simulation testing and port it over to the actual robots since we have the U.S. Open competition coming up in a few months!

## The Code

If you would like to look at or play with any of the source code you can check it out on [Github](https://github.com/alexbaucom17/RoboCupSoccerSim).
