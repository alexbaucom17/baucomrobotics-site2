---
title: Making Google and Alexa Play Nice
date: 2017-01-06 12:30:00 -0700
categories: [Projects]
tags: [raspberry pi, DIY]     # TAG names should always be lowercase
---

For Christmas I got an Amazon Echo Dot as a gift. I had played with one a little bit before and thought they were pretty neat but I had never used on for an extended period of time.

I had a lot of fun setting it up and exploring the various features but I was bummed to find out that the Echo Dot did not support interfacing with Google Music, which is the streaming service I use for all of my music. However, one of the things I was most excited for about the Echo Dot was that it supported custom skills and commands. So, a few quick Google searches later and I found exactly what I wanted: instructions and code for setting up a custom Alexa skill to interface with Google Music.

The README for this project is excellent and had pretty good installation instructions that got me up and running on my raspberry pi pretty quickly, although I did have to install a couple extra libraries (libssl-dev and libffi-dev) that for whatever reason were not automatically installed and their absence would cause the build to fail. I was also not familiar with foreman and ngrok before this project so it took some tinkering with those to get everything to work. But after all that I could tell Alexa to have Google Music play my music.... but it only worked about 50% of the time. The other 50% of the time I would get a timeout error.

After several hours of testing various configurations, I finally determined the culprit... my raspberry pi was too slow. Apparently this software is relatively CPU intensive (at least when handling requests) and my poor raspberry pi couldn't handle it. Thankfully, I happened to have a raspberry pi 3 (which is about 10x faster than the original raspberry pi) laying around that I was able to get set up and it worked like a charm! Check out the video below to see it in action!

If you want to do this project yourself, check it out on [Github](https://github.com/stevenleeg/geemusic). Like I said, the documentation is pretty good and everything is relatively straightforward. At the time of writing this, the original developer (and several others that have started helping) are actively working on it to fix bugs and add more enhancements so keep checking back on the project if it doesn't quite do everything you want it to do just yet.

{% include embed/youtube.html id='XlhSE15_uKI' %}
