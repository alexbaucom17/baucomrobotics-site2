---
title: Autonomous Ball Catcher Part 1 - Hardware
date: 2016-05-25 12:30:00 -0700
categories: [Projects]
tags: [robotics, lego]     # TAG names should always be lowercase
---

Launch a ball. Track the ball. Catch the ball. It is a simple concept - one that we humans learn at a very young age while playing ‘catch.’ But to get a robotic system to perform similar actions is a very different game. In this project I will talk about how I built and programmed my own autonomous system to track a ball in flight and catch it in an autonomous cart.

You can see the system in action in the video below. If you want to know how it all works you can watch the rest of the video for a brief overview or continue reading here for a more in depth look at the system.

{% include embed/youtube.html id='lwQgtV-H_iM' %}
_I built an autonomous ball catcher which uses a camera to track the ball and drive a cart to catch it in midair!_

In this post, I will be covering the mechanical design of the system and, in a couple weeks (ish), I will post more about the software, so stay tuned for that!

## System Overview

My ball catcher system is comprised of three main parts: the launcher, the camera, and the cart. The idea is to have the launcher shoot the ball into the air and then have the camera track the ball. As the camera is tracking the ball, the software is making real time estimates about the ball’s flight path and where it will land. This information is relayed to the cart and the cart tries to move quickly to where the ball will land to catch it. Let’s take a look at each of these parts individually.

## Launcher

The launcher went through several iterations to get to its final state. My initial thought was to build something akin to a tennis ball or baseball machine, where spinning wheels propel the ball with great speed. I got a prototype working of this where a single motor would both drive the spinning wheels as well as a rod to push the ball into contact with the wheels. However, the major downfall with this design was that the Lego parts can only have certain spacing between parts. So, even with a lot of tinkering and testing many different wheel varieties, I couldn’t get the wheels spaced properly to grip the ball well. It would either be too tight or too loose, neither of which work for launching a ball with any sort of speed.

![](/assets/BallCatcher1/FirstTry.jpg)
_My first attempt at a launching device_

So, I tried building a catapult device instead but very quickly abandoned that idea since I couldn’t get the ball to launch very high at all. I needed as much air time as possible to give my cart any chance of getting to the ball before it landed.

I finally decided to try using rubber bands instead of motors to be my main energy delivery method (which I should have done with the catapult, but I didn’t think about that until after the fact). I used the rubber bands to make a slingshot-type of device and with some tweaks to the launch angles and pin release, I was able to get quite good flight times. I had to beef up the structure and brace everything quite a bit to make sure no pins or beams snapped. I also had to get clever with how to quickly pull the release pin out, but after a bit of tinkering I arrived and the final design seen here.

![](/assets/BallCatcher1/FinalLauncher.JPG)
_The final launcher design_

## Camera

There wasn’t much to do in the way of hardware design for the camera. It is just a cheap USB webcam that plugs into my computer; however, one consideration was where to place it. I had to place the camera somewhere that could see the ball for as much of its flight as possible, but not so far away that the ball was tiny. I ended up placing the camera on the edge of my desk and then moving the whole launcher system into the middle of my living room to give the camera the best possible view.

## Cart

The biggest factor driving (pun completely unintentional) the design of the cart was speed. I knew that the ball would only be in the air for a second or so at most, so I needed to make sure the cart could actually move quickly enough to reach the goal in time. In order to make the cart move quickly, I had to cut down on weight as much as possible. To do this, I bought a long, flexible data cable and used the NXT brick as a stationary controller connected to the cart. This meant that the heaviest thing on the cart was just the motor, which I couldn’t exactly leave behind. I built a basket on the top of the cart and made a flat surface on the front of it to make sure that the ultrasonic sensor could read the position of the cart accurately.

![](/assets/BallCatcher1/Car.JPG)
_The cart with a large basket to give the best chance of catching the ball_

The trickiest part of the whole design was finding the right gear train. I wanted to gear up the wheels as much as possible so they would turn quickly, but if I made the ratio too high, the cart wouldn’t have enough torque to move. I eventually settled on a ratio of 5:1, which got the cart moving quickly enough to be viable. One problem I did run into was gear slippage. When the motor would try to stop, the gear train would sometimes slip. I was able to mostly fix this by beefing up the mounting system for the gears. This prevented the axles from bending, which kept the gears engaged and stopped them from slipping.

![](/assets/BallCatcher1/CarGearing.JPG)
_The gear train driving the cart. The ratio here is 5:1_

Well, that is about it for the hardware I used for this project. Be sure to check back in a couple weeks for part two where I detail all of the software and code design!