---
title: Domino Robot Design Journey
date: 2021-07-25 12:30:00 -0700
categories: [Projects]
tags: [robotics, dominorobot]     # TAG names should always be lowercase
---


## The Origin Story

This whole project started in May of 2019 when I attended Maker Faire (RIP) in the Bay Area and went to a talk featuring Mark Rober.

![](/assets/MyFirstComputerBuild/parts.jpg)
_Me at Maker Faire 2019 attending Mark Rober’s talk._

During this talk, someone asked Mark a question about one project he had always wanted to do but had never been able to. He said he had a vision for a robot that would set up ton dominos in a gymnasium overnight and that he had tried some small prototypes, but hadn’t had any luck. He then said that if anyone in the audience knew how to do something like that, to get in touch with him. I knew a fair bit about robotics, so I sent him an email saying I could help with the project but didn’t expect I would ever hear back from him.

He emailed back less than two hours later.

Turns out, there were two Stanford Mechanical Engineering students who also heard the talk and were interested in working on the project too. And just like that, the team was started.

We all met up later that week to brainstorm ideas, which went great, until Mark pulled out his flamethrower and the meeting devolved into a bunch of nerds goofing off with fire.

![](/assets/MyFirstComputerBuild/parts.jpg)
_The first team meeting around the iconic Mark Rober workbench._

![](/assets/MyFirstComputerBuild/parts.jpg)
_Mark looking awesome with his flamethrower._

## Initial Prototypes

After that first brainstorming meeting, a few clear challenges emerged.

The first challenge was the sheer scale of the undertaking. From the outset, Mark wanted to place at least 100,000 dominos and many of our early designs had the robot carrying all of the dominos and placing a single domino at a time. When you start doing the math of how heavy 100,000 dominos would be (around 850 kg or 1875 lb) or how long it would take to place them all individually (at even 3 seconds/domino you are looking at 3.5 days nonstop!) it became clear that we needed to approach this differently. 

One of the designs that was sketched out early on involved using a tray that could hold a bunch of dominos and drop them all at once with a sliding mechanism underneath. This tray could then be dropped off on a conveyor belt where it would be refilled and then picked back up later. This idea solved both the weight issue (only carry a few of the dominos at a time) and the timing issue (place many dominos at once and allow various parts to run in parallel). While the final version didn’t turn out exactly like this, many of the same ideas are present in both!

![](/assets/MyFirstComputerBuild/parts.jpg)
_My early (and very messy) sketches of a possible design involving a grid-like tray that can drop a bunch of dominos at once and then let the tray be refilled by a separate system._

The second major challenge was localization (fancy robotics word for “ensuring the robot knows where it is”). The robot was going to need to place down dominos close enough that they could knock each other over, but not so close as to knock over already placed dominos. This meant that the robot would need to know its position extremely accurately. This accurate positioning also had to be very reliable as even a single mistake could cause the robot to knock all the dominos down. One of the initial ideas was to try and measure the domino positions relative to the robot with an ultrasonic sensor, which actually seemed quite promising, but turned out to be problematic later on. It was a similar story for the Marvlemind Indoor ‘GPS’ sensors: early testing looked quite promising, but it didn’t scale as well as we expected (See section on The Last Centimeter Problem below for more details on these challenges).

![](/assets/MyFirstComputerBuild/parts.jpg)
_Testing the accuracy of an ultrasonic sensor and whether or not it can detect dominos with gaps in them. Turns out that it can (but only in very specific conditions)._

The third major challenge was ensuring accurate driving. Even if we solved the localization problem and the robot knew where it was very precisely, if it could not control its motion properly, it would not be able to place the dominos accurately enough, or worse, it could knock the dominos over. Early on, I decided that using some sort of omni-directional drive system would massively simplify this problem because it would allow the robot to perform very small correctional motions to align with the dominos without having to back up, adjust, and re-approach the dominos. Imagine the challenge of trying to move exactly 1 inch to the left in your car - that is hard because the car isn’t designed to drive sideways easily. Using these special wheels can help fix that problem, so I bought a cheap [Mecanum wheel](https://en.wikipedia.org/wiki/Mecanum_wheel) kit and Arduino online to test out, and this turned into the very first mobile prototype.

{% include embed/youtube.html id='Ht-k5_tc5kA' %}
_The first motor tests. Every robot has to start somewhere!_

{% include embed/youtube.html id='Ht-k5_tc5kA' %}
_The very first prototype driving around._

It was quickly apparent that this first prototype was far too small to put much else on, and so I scaled up to a slightly larger robot, got some more reliable motors, and switched out the Mecanum wheels for true [omnidirectional wheels](https://en.wikipedia.org/wiki/Omni_wheel). I used this prototype to develop the first versions of the kinematics, the control loop, localization using the Marvelminds, network communication, and master GUI. This was all done using only a single Arduino Mega on the robot which posed some interesting challenges, especially around memory and compute limits. However, this prototype was used for about 6 months and helped me work out many of the foundational pieces of the system.

{% include embed/youtube.html id='Ht-k5_tc5kA' %}
_Testing the omnidirectional wheels on the second prototype._

{% include embed/youtube.html id='Ht-k5_tc5kA' %}
_Testing how accurate the Marvelminds are on the second prototype._

## Motor Mayhem

Once the prototypes had outlived their usefulness, it was time to scale up the robot. However, this introduced a whole host of problems with the drive system which took quite a while to sort out.

See, the main problem is I had no idea how to properly select a motor for a robot. Sure, I had worked with plenty of robot motors before, but they had always been part of the robot chassis or someone else had done the work of finding the right one. I hadn’t ever had to size one for myself. Needless to say, I had a lot to learn.

The first motors we tried were stepper motors. I had some reservations about using steppers as drive motors for the robot, but I figured they were worth a shot. They turned out to be undersized to carry the load we needed and the Arduino couldn’t send step pulses fast enough to move the robot at any appreciable speed. I could get the robot to drive around a little bit, but it wasn’t great.

{% include embed/youtube.html id='Ht-k5_tc5kA' %}
_Full sized robot using stepper motors as the drive system. It sort of worked, but wasn’t great and was a pain to work with._

Then, I made things worse by switching to DC motors. These motors were too fast and couldn’t provide enough torque at low speed to control the robot well. Additionally, sometimes a few of the wheels would get good traction and others would slip, causing the robot to spin wildly. It turned out that the MDF board of my prototype was springy enough to keep all the wheels on the ground, but once we mounted these wheels to a steel plate there was no longer any springiness that kept all four wheels on the ground and so I started to see a lot of slipping.

{% include embed/youtube.html id='Ht-k5_tc5kA' %}
_Testing with the DC motors where some of the wheels lose traction._

At this point, I realized I didn’t know what I was doing and so Mark reached out to a few of his YouTube buddies ([Sean Hodgins](https://www.youtube.com/channel/UCE-bw6PRKuDlH6fP1mP4nOw), [James Bruton](https://www.youtube.com/user/jamesbruton), and Shane from [Stuff Made Here](https://www.youtube.com/c/StuffMadeHere/featured)) for some help. All of them graciously provided super useful feedback and suggestions which helped get us back on the right track.

The right track ended up being to use [ClearPath servos](https://teknic.com/products/clearpath-brushless-dc-servo-motors/) which are super accurate and provide a ton of torque, add a belt reduction to even further improve the output torque, and to drop down to only three wheels to ensure there wasn’t any wheel slippage. The move from four wheels to three wheels was important because getting all four wheels to make good contact with the ground is difficult. This is because it only takes three points to define a plane and is the same reason a stool with three legs will never wobble, but a chair or table with four legs can.

The awesome folks over at Teknic helped us pick the right motor for our needs, provided all three motors and one of their [ClearCore](https://teknic.com/products/io-motion-controller/) controllers to us, and helped us dial in the motor tunings (seriously, huge shoutout to Brendan, Erik, and Matt for all their help). With these new motors and modifications, the base of the robot was finally able to drive around reliably.

{% include embed/youtube.html id='Ht-k5_tc5kA' %}
_Drive tests with the ClearPath motors which work much better. The slight jerk at the start of each motion was fixed later on with improved trajectory generation._

## More Pi Please

Another major change that happened around the same time as switching the motors was a switch from an Arduino to a Raspberry Pi as the main computer on the robot. This was done for a few reasons: the ClearCore was easiest to interface with over USB serial, the Marvelmind sensors would also benefit from having a USB connection (instead of being forwarded to the robot via the laptop which wasn’t great for latency), and the code was growing complex enough that the available memory and compute on the Arduino simply weren’t cutting it anymore.

There were certainly some challenges to overcome while porting the software (dealing with the complexity of an OS, figuring out how to create a C++ build system, finding C++ libraries instead of Arduino ones, etc.), but it actually went quite smoothly overall and the end result had many benefits over the Arduino. For starters, I was able to mock out all of the devices the Pi would communicate with and actually write a suite of unit tests that enabled quite a lot of development to happen without the physical robot needing to be present. I was also able to set up a proper configuration library and logging system which also made development much smoother.

Once this major porting effort was completed, the overall robot software architecture stayed roughly the same for the rest of the project: the main control and communication all happened on the Pi and low level motor commands were forwarded along to the ClearCore to handle. 

## Tray Testing

At this point, the robot could now drive around nicely using the new motors controlled by the new software system, so the next step was to add the tray to the front of the robot. In a bit of a happy accident, it turned out that the ClearCore had an extra port for controlling a stepper motor that we weren’t using for the drive system and also had enough other I/O ports to handle the tray servo, homing switch, and manual buttons. So, other than having to do some power conversions to get the 24V from the ClearCore down to 5V for driving the tray servo, it was quite straightforward to hook up all of the parts of the tray to the controller and test it out.

After coding up a few simple state machines to sequence the actions for homing and placing dominos, the tray just… worked! It was one of the few pieces of the project that pretty much worked all the time and never had any major issues.

{% include embed/youtube.html id='Ht-k5_tc5kA' %}
_Testing dropping a line of dominos with the tray._

{% include embed/youtube.html id='Ht-k5_tc5kA' %}
_A fun little slo-mo shot I took of the dominos falling out of the tray._

## The Last Centimeter Problem

Based on the results of testing on the early prototypes, the plan for localization was basically to use the Marvelmind sensors as it looked like I was getting sub-centimeter accuracy, which seemed sufficient. If that proved not to be good enough, the backup plan was to add ultrasonic sensors to detect the dominos as those had accuracy of a few millimeters.

And, oh boy, did I underestimate the complexity here (sensing a theme yet?). I won’t bore you with all of the details but here is a list of just a few of the critical problems that I ran into with that plan:

1. The Marvelmind sensor accuracy scales as a function of distance to the base stations. The early tests were in a very small shop where the base stations were quite close to the robot. When we moved to the larger shop, the accuracy got much worse.

2. The robot is quite long with the tray sticking out in front, which meant that small changes in the angle of the robot compounded into much larger changes of the position of the front of the tray. In order to maintain alignment of the dominos, the robot angle had to be accurate to less than half a degree, and the Marvelminds simply couldn’t do that.

3. While the ultrasonic sensors could detect the dominos quite accurately in the right conditions, the robot did not have the right conditions. When trying to use forward facing sensors to detect the dominos in front of the robot, the ultrasonic pings would echo off of the floor and the bottom of the tray and cause false readings that were too hard to filter. When trying to use sideways facing sensors to detect the dominos to one side of the robot, the sensors were too close and the edge of the dominos too small to reliably detect them. 

![](/assets/MyFirstComputerBuild/parts.jpg)
_Testing the ultrasonic sensors on the robot. The ‘blinders’ on the top and bottom were an attempt to reduce reflections that caused problematic measurements._

![](/assets/MyFirstComputerBuild/parts.jpg)
_Setting down dominos using the ultrasonic sensors. You can see that the alignment is… not very good. This is due to the very noisy readings coming from the ultrasonic sensors._

After a few days of trying without success to get these previous methods to work, we decided to ditch the ultrasonic sensors and use the Marvelminds only to get the placement location roughly right, but we still needed something to help out with the final alignment of the dominos. After some discussion, we decided on using downward facing cameras with markers on the ground.

I hacked together some code and cameras to test out the marker tracking and it turned out to work quite well! Within a few days the system could set down groups of dominos next to each other that were aligned enough to look good and knock each other over.

{% include embed/youtube.html id='Ht-k5_tc5kA' %}
_The first test of the vision system with the camera sketchily taped to a stick. But hey, it proved out the concept!_

{% include embed/youtube.html id='Ht-k5_tc5kA' %}
_One of the first tests of setting down multiple groups of dominos._

## Dom’s Final Form

All the pieces of the robot were finally in place, so the only thing left to do was to start scaling up the testing and figuring out what would break. Fortunately, no critical problems with the robot were found during this testing, just a lot of small tweaks here and there to improve the reliability. For example, keen-eyed readers may have noticed that the placement of the Marvelminds in these test videos is different from the the final version. Moving the sensors out much further gave significantly better angular tracking when driving longer distances and helped the robot stay localized much better when travelling across the warehouse. I also added some better ‘safety’ features such as automatically shutting the motors off if the ClearCore did not receive any updates from the Raspberry Pi within a few hundred milliseconds to prevent the robot from driving into the dominos in the case of a communication problem.

And, after ironing out many of these last reliability challenges, the robot did its job amazingly well and set up over 100,000 dominos in just over 24 hours of runtime. It also beat [Lily Hevesh](https://www.youtube.com/user/Hevesh5) in a head to head competition and set a world record. All in all, the engineering effort paid off and we got an awesome robot and a pretty sweet video out of it.

![](/assets/MyFirstComputerBuild/parts.jpg)
_Filming with Lily Hevesh. The robot set up the blue in the same time Lily did the red and white._

![](/assets/MyFirstComputerBuild/parts.jpg)
_Waiting nervously for the the big moment where all the dominos would get knocked over._

![](/assets/MyFirstComputerBuild/parts.jpg)
_Congratulating Dom after the dominos fell over._

![](/assets/MyFirstComputerBuild/parts.jpg)
_The aftermath. Cleaning up 100,000 dominos is a lot of work!!_

Thanks for reading about this crazy engineering journey I went on to make this robot a reality. If you are interested in more details about how the final [hardware]({% post_url 2021-07-26-DominoRobotHardwareOverview %}) or [software]({% post_url 2021-07-24-DominoRobotSoftwareArchitecture %}) worked, I’ve written up articles about those. If you want to dive deep into the technical workings of the [control system]({% post_url 2021-07-22-DominoRobotControlSystem %}) or [trajectory generation]({% post_url 2021-07-23-DominoRobotTrajectoryGeneration %}), I got posts about those as well. 
