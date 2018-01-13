# Delayed Admin

A tool for administrators to (temporarily) drop admin privileges - to use tools like [Parental Controls](https://support.apple.com/kb/PH18571), [Self Control](http://selfcontrolapp.com), [etc.](https://github.com/miheerdew/delayed-admin/wiki/Tools), on themselves!

Currently it just works on my MacOS Sierra, but should be extensible to other Unix like systems too. The aim would be to create a tool like [abmindicate](http://www.pluckeye.net/abmindicate.html) for MacOS/Unix.

Feel free to open a pull request if you have any suggestions/feedback.

## Warning
**This project is still a prototype. Only follow these instructions if you know what you are doing. There might be a possibility of locking yourself out of admin privilages. To prevent this, make another administrator account.**

## How does it work?

### First an analogy
Say you have a box containing an endless supply of candies, and that lately you have been eating lot more candy than you should be. After all, whenever you have an impulse to eat candy, it is so easy to just open the box and grab one. It's so hard to fight the craving! Now imagine instead that the box had a mechanism that ensures that it only opens 20min after you tell it to. Then it would be so much easier to resist the temptation of eating the candy (becuse even though the craving is there, there is nothing you can do about it, at least until the next 20min).

This is the principle Delayed-Admin is based upon. It is for users who don't want the candy-box (administrator access) to instantly open whenever desired, but still not be sealed off completely. Why would one want to do this? That is because many restrictions can be set (using admin access) that cannot be undone without it.

### The technical bit

On installation, a new group called `delayed-admin` is created with an entry in the sudoers file allowing anyone in the `delayed-admin` group to run the script `/usr/local/bin/delayed` as root. The `delayed` script simply sleeps for some amount of time (as specified in `/etc/delayed-admin.conf`) and then runs the command specified in the argument as root.


## Installation and setup

### MacOS

```
#Install delayed-admin
sudo setup.sh install

#Add the current user to the delayed-admin group
sudo dseditgroup -o edit -a "$USER" -t user delayed-admin

#Remove the current user from the admin group
sudo dseditgroup -o edit -d "$USER" -t user admin
```

### Linux

```
#Install delayed-admin
sudo setup.sh install

#Add the current user to the delayed-admin group
usermod -a -G delayed-admin "$USER"

#Remove the current user from the sudo group
sudo gpasswd -d "$USER" sudo
```

## Uninstall
Before you uninstall, first ensure that you have root access. Then run:

```
sudo setup.sh uninstall
```

## Usage

If you followed the instruction in [Installation and Setup][], now your account must belong to the `delayed-admin` group, but not in the `admin` (or `sudo`) group. Hence you can't directly run `sudo` on any command, but you can run `sudo delayed`:

```
sudo delayed whoami
# Outputs "root" after 30 sec.

sudo delayed
# Get a root shell after 30 sec.
```

The delay can be changed by changing the number of seconds in `/etc/delayed-admin.conf`. The delay at the beginning is 30s.
