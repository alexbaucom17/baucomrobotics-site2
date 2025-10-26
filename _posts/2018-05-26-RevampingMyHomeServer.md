---
title: Revamping my Home Server with Ubuntu and Docker
date: 2018-05-26 12:30:00 -0700
categories: [Projects]
tags: [server, ubuntu, docker]     # TAG names should always be lowercase
image: /assets/RevampingServer/preview.png
---


A few months back, I re-purposed some old computer parts to make myself a simple file server. I originally set everything up with [Amahi](https://www.amahi.org/) because it promised to be simple and powerful. While it was a good stepping stone for me into the world of home servers, I quickly outgrew it's capabilities and wanted my own system that I had more control over.

So, I set out to make my own with [Ubuntu](https://www.ubuntu.com/) as the base OS and decided to try out [Docker](https://www.docker.com/) along the way. This post is not designed to be a tutorial, but rather provide detail about the process I went through to get my system up and running. This worked for me and should be applicable to those with similar setups, but your mileage may vary.

## Goals

The features I wanted for my server were:

- Samba server for the home network
- Automatic duplication and backups for all data on the server
- Plex media server
- Factorio server
- Pi-hole 

## Initial Setup

First, I had to remove Amahi and install Ubuntu without wiping any of my existing data. Fortunately, I had planned ahead for this sort of situation and had my server set up with two 2 TB hard drives with my data and a single 120 GB hard drive to use as a boot drive. So for safety I unplugged the two hard drives and followed the [standard installation instructions for Ubuntu 16.04 Server](https://tutorials.ubuntu.com/tutorial/tutorial-install-ubuntu-server#0). The only hiccup I encountered was that I used Unetbootin to create my bootable USB, which apparently doesn't work as well as it used to. Thankfully the Ubuntu installer warned me of this and [recommended using rufus](https://tutorials.ubuntu.com/tutorial/tutorial-create-a-usb-stick-on-windows#0) instead, which worked perfectly.

Once Ubuntu was installed, I set up all of the standard things like SSH and a static IP. Then I reconnected my hard drives and was ready for the next step.

## RAID

On Amahi, my drive duplication setup had been setup using [greyhole](https://www.greyhole.net/) and I wanted to convert it to a standard RAID 1 array. To do this, I first verified that both drives had the same data by looking at the folder sizes on each drive with

`du -hs /path/to/directory`

This is sort of a poor man's verification but I used it more as a sanity check to make sure nothing major was missing. Since Greyhole was keeping everything in sync I didn't feel the need to do a thorough check.

Next, I copied all of the data from one of my hard drives to an external hard drive, just in case something went wrong with building the RAID array (I also had an offsite crashplan backup of the server if things went really wrong).

To convert the array to RAID, I first needed to wipe one disk and initialize a raid array there as a degraded array missing a disk. Then I copied the data into the raid array and wiped the second disk. Finally, I could add the second disk to the raid array and have it rebuild itself. I follow two excellent tutorials [here](https://www.guyrutenberg.com/2013/12/01/setting-up-raid-using-mdadm-on-existing-drive/) and [here](https://wiki.archlinux.org/index.php/Convert_a_single_drive_system_to_RAID). Since I did not need to have my boot partition on the RAID array, I was able to skip all of the step in those tutorials regarding GRUB.

After the RAID array finished setting itself up I had a boot drive at _/dev/sda_ and a new array at _/dev/md0_ composed of _/dev/sdb_ and _/sev/sdc_. I set up my _/etc/fstab_ file to auto mount the array at _/media/raid_.

## Samba

Now that all of my data was present, I wanted to set up Samba to make that data available to all of the other PCs in my house. I followed [this guide](https://help.ubuntu.com/community/How%20to%20Create%20a%20Network%20Share%20Via%20Samba%20Via%20CLI%20%28Command-line%20interface/Linux%20Terminal%29%20-%20Uncomplicated,%20Simple%20and%20Brief%20Way!) which was straightforward and worked perfectly for me. The basic gist was that I installed samba, set up the users I needed, edited _/etc/samba/smb.conf_ to add my shares, and rebooted the samba service. Just like that all of my files were available to the rest of the network.

## Firewall

Since this server was eventually going to have some public facing ports, I set up a [firewall using ufw](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu-16-04). I opened ports for samba and ssh initially, but as I installed new programs I made sure to open any ports that those applications required as well.

## Docker

Now that the key functionality that I needed from the server was back up and running, I could experiment with some other things that I wanted to add. I was vaguely familiar with Docker and thought that it sounded like a great way to make the server easier to manage and allow me to test out various programs and apps without breaking everything else.

Installation and setup was pretty easy and [this thread summarizes it well](https://askubuntu.com/questions/938700/how-do-i-install-docker-on-ubuntu-16-04-lts). I also opted to [create a docker group](https://docs.docker.com/install/linux/linux-postinstall/) and add my user to it so that I didn't have to use sudo for all of my docker commands.

At this point I also stumbled across a [docker container manager called Portainer](https://www.ostechnix.com/portainer-an-easiest-way-to-manage-docker/), which I decided to try out. It turned out to be super useful and did all of the things I needed to do with Docker but with a nice GUI. I still had to use the command line for a number of things, but Portainer made it pretty easy to check the status of my containers and do most of the other basic things I needed to do with Docker. My favorite feature is the Duplicate/Edit function which allows me to easily edit the container and parameters and Portainer will automatically stop the existing container and redeploy a new container with my updates with the same name.

With docker set up the remaining installations were all quite straightforward as there were existing containers for all of them that only required some minor customization, usually through adjusting environment variables.

## Duplicati

I chose to convert all of my backups over to [Duplicati](https://www.duplicati.com/) with a [B2 backend](https://www.backblaze.com/) since my one year of CrashPlan Pro at 75% discount was expiring. I only have about 500 GB of data to backup so an unlimied plan (which is all CrashPlan offers) doesn't make a ton of sense for me. With free uploads and general storage only costing $0.005/GB my monthly bill should only be around $2.50 (possibly less after compression and de-duplication) for the storage and about $5 if I needed to restore the entire backup for some reason.

I chose Duplicati because it is free for all platforms, integrates with a number of different storage back ends, and has a docker container. The documentation for this container is on [Docker Hub](https://hub.docker.com/r/linuxserver/duplicati/) but all I needed to get it running for me was:

```bash
docker create \
  --name=duplicati \
  -v /home/alex/duplicati_config:/config \
  -v /home/alex/duplicati_local_backup:/backups \
  -v /media/raid/:/source \
  -e PGID=1000 -e PUID=1000  \
  -p 8200:8200 \
  --restart=always  \
  linuxserver/duplicati
```

All the rest of the setup happened on the web gui which is very easy to use. Duplicati is currently working on seeding the backup of the shared data on my server and I will be replacing CrashPlan on all of the local machines as well to backup any data there that doesn't get moved over to the server.

## Factorio

[Factorio](https://factorio.com/) is a game about automation and logistics management that I enjoy playing and it allows for multiplayer games by running a server. Previously, I had used my main PC as the server which totally works, but the downside is that if I leave the game or turn of my PC, nobody else can play on my server. So, I wanted to set up a persistent game server and luckily one of the community members has set up a [docker container](https://hub.docker.com/r/dtandersen/factorio/) that can do just that. The only extra step I had to take was to forward port 34197/udp on my router so that the game was publicly available on the multiplayer server browser.

## Plex

I had heard of [Plex](https://www.plex.tv/) previously but had not ever really used it. Now that I had docker set up and experimenting with it was as easy as [spinning up a container](https://hub.docker.com/r/plexinc/pms-docker/) to test it out, I decided to give it a shot. I copied some of my movies into a new folder for Plex to use, set up the container, opened [a lot of firewall ports](https://support.plex.tv/articles/201543147-what-network-ports-do-i-need-to-allow-through-my-firewall/), and installed the Plex app on my TV. Just like that I could now browse all of my (limited collection of) movies on my TV. Neat! I opted not to open up ports in my router as I don't expect to need access to my movies while out and about, but this would be a pretty easy change down the road if I decided I wanted that feature turned on.

## Pi-hole

[Pi-hole](https://pi-hole.net/) is another one of those programs that I had heard of, but never tried it out (which is kind of funny because I have like two extra Raspberry Pis sitting in a drawer, oh well). Turns out there is also a [docker container for Pi-Hole](https://hub.docker.com/r/diginc/pi-hole/) which was mostly straightforward to get running. The only hiccups I ran into was that I had Apache running by default (but not being used) so I had to go disable it and for some reason the container started up okay for me but the logs showed Pi-hole initialization didn't seem to complete successfully. Connecting to the container and running

`pihole -r`

restarted the initialization script and walked me through the setup options. After completing this step, everything was up and running correctly for me.

So far the main ad-blocking functionality of Pi-hole has been working great for me with my router DNS pointed to the Pi-hole server, however, this setup [does have some limitations](https://discourse.pi-hole.net/t/how-do-i-configure-my-devices-to-use-pi-hole-as-their-dns-server/245) such as not having per-host tracking or the ability to resolve hostnames. I may try to change my configuration in the future to allow those features.

## Conclusion

Overall, this was quite a successful update of my server and I am much happier with the state it is in now. I am much more comfortable with the Ubuntu command line than I was with the Fedora version that Amahi was built on top of. Additionally, the flexibility of Docker has made it very easy to set up new features without fear of breaking anything else and has allowed me to get more functionality out of my server than I probably otherwise would have, simply because it is so easy to set up and use new containers. Finally, I have found my core file sharing and backup features to be much more robust and reliable than they were previously, which I am very pleased with.
