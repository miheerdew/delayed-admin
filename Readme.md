# Delayed Admin

A tool for administrators to (temporarily) drop admin privileges - to use tools like [Parental Controls](https://support.apple.com/kb/PH18571), [Self Control](http://selfcontrolapp.com), [etc.](https://github.com/miheerdew/delayed-admin/wiki/Tools), on themselves!

Currently, it's tested on MacOS, but should work on Unix like systems. The aim is to create a tool like [abmindicate](http://www.pluckeye.net/abmindicate.html) for MacOS/Unix.

Feel free to open a pull request if you have any suggestions/feedback.

## Tutorials
[Tutorial for linux](https://www.ostechnix.com/delayed-admin-temporarily-drop-admin-privileges-administrators/) by SK.

## How does it work?

### First an analogy
Say you have a box containing an endless supply of candies, and that lately you have been eating lot more candy than you should be. After all, whenever you have an impulse to eat candy, it is so easy to just open the box and grab one. It's so hard to fight the craving!

 Now, imagine instead that the box had a mechanism to ensures that it only opens 20 min after you tell it to. Then it would be so much easier to resist the temptation of eating the candy (becuse even though the craving is there, there is nothing you can do about it, at least until the next 20 min).

This is the principle Delayed Admin is based upon. It gives you a delayed access to admin privilieges (the candy-box).

### The technical bit

On installation, a new group called `delayed-admin` is created with an entry in the sudoers file allowing anyone in the `delayed-admin` group to run the script `/usr/local/bin/delayed` as root. The `delayed` script simply sleeps for some amount of time (as specified in `/etc/delayed-admin.conf`) and then runs the command specified in the argument as root.


## Why would anyone use this?

 Self-control. Suppose Anand runs MacOS/Linux on his laptop. He wants to enforce a no-screen time and restrict his visits to certain websites. Sure, he can install [a parental control app](http://www.noobslab.com/2017/01/timekpr-parental-control-application.html), or [change some settings](https://serverfault.com/a/139794), or use [url-blacklists](https://github.com/StevenBlack/hosts). But being an administrator for his laptop, he can also uninstall that program, remove those settings anytime.

This is where delayed admin helps. Anand only retains a delayed adminstrator access, so that he can still do the routine system update (or any other administrator stuff), but only after waiting for a slight delay (default is 30s but he can change it to 20 min). Basically, this prevents him from taking actions at whim, allowing only deliberate ones.

In this example he would set up those parental controls, and then use delayed admin to deter him from disabling them.

## Installation and setup

### MacOS

```
#Install delayed-admin
sudo ./setup.sh install

#Add the current user to the delayed-admin group
sudo dseditgroup -o edit -a "$USER" -t user delayed-admin

#Remove the current user from the admin group
sudo dseditgroup -o edit -d "$USER" -t user admin
```

### Linux

```
#Install delayed-admin
sudo ./setup.sh install

#Add the current user to the delayed-admin group
usermod -a -G delayed-admin "$USER"

#Remove the current user from the sudo group
sudo gpasswd -d "$USER" sudo
```

## Uninstall
Before you uninstall, first ensure that you have root access. Then run:

```
sudo ./setup.sh uninstall
```

## Usage

If you followed the instruction in [Installation and Setup](#installation-and-setup), now your account must belong to the `delayed-admin` group, but not to the `admin` (or `sudo`) group. Hence you can't directly run `sudo` on any command, but you can run `sudo delayed`:

```
sudo delayed whoami
# Outputs "root" after 30 sec.

sudo delayed
# Get a root shell after 30 sec.
```

The delay can be changed by changing the number of seconds in `/etc/delayed-admin.conf`. After you are comfortable, it is recommended to change it to 1200 (i.e. 20 min).

## License

See the [LICENSE](LICENSE) file for license rights and limitations (MIT)
