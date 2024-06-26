[![Build Status](https://travis-ci.org/miheerdew/delayed-admin.png)](https://travis-ci.org/miheerdew/delayed-admin)
# Delayed Admin

A tool for administrators to (temporarily) drop admin privileges when using `sudo` - to use tools like [Parental Controls](https://support.apple.com/kb/PH18571), [Self Control](http://selfcontrolapp.com), [etc.](https://github.com/miheerdew/delayed-admin/wiki/Tools), on themselves!

The code has been [tested](https://travis-ci.org/miheerdew/delayed-admin) on MacOS and Ubuntu, but it should work for other unix like systems too. 

Feel free to open a new issue if you have any suggestions, questions or feedback!

## Warning
**It is possible to lock yourself out of admin privileges while you play around with this project. To prevent this, keep another administrator account which you can access if things go wrong.** (BTW, if you wish to lock that password up somewhere online see [Lockbox](https://lockbox.pluckeye.net/help)).

## Tutorials
[Tutorial for linux](https://www.ostechnix.com/delayed-admin-temporarily-drop-admin-privileges-administrators/) by SK.

## How does it work?

### First an analogy
Say you have a box containing an endless supply of candies, and that lately you have been eating lot more candy than you should be. After all, whenever you have an impulse to eat candy, it is so easy to just open the box and grab one. It's so hard to fight the craving!

 Now, imagine instead that the box had a mechanism to ensure that it only opened 20 min after you tell it to. Then it would be much easier to resist the temptation of eating the candy, because even though the craving is there, there is nothing you can do about it, at least for the next 20 minutes.

This is the principle Delayed Admin is based upon. It gives you a delayed access to admin privileges (the candy-box).

### The technical bit

On installation, a new group called `delayed-admin` is created with an entry in the sudoers file allowing anyone in the `delayed-admin` group to run the script `/usr/local/bin/delayed` as root. The `delayed` script simply sleeps for some amount of time (as specified in `/etc/delayed-admin.conf`) and runs the command in its argument as root.


## Why would anyone use this?

 Self-control. Suppose Anand runs MacOS/Linux on his laptop. He wants to enforce a no-screen time and restrict his visits to certain websites. Sure, he can install [a parental control app](http://www.noobslab.com/2017/01/timekpr-parental-control-application.html), or [change some settings](https://serverfault.com/a/139794), or use [url-blacklists](https://github.com/StevenBlack/hosts). But being an administrator for his laptop, he can also uninstall that program, or remove those settings anytime.

This is where Delayed Admin would help. Anand only retains a delayed administrator access so that he can still do the routine system update or any other administrator stuff that he wants, but only after waiting for 20 minutes. Basically, this deters him from taking administator actions at whim, allowing only for deliberate ones.

In this example he would set up those parental controls, and then use `delayed` to deter him from disabling them. 

## How to use it?

### Install
To install, change to the delayed-admin directory and run:

```
sudo ./setup.sh install
```

This will go through a couple of actions. Ensure that the installation was successful before moving further. 



### Usage

There are two ways to use Delayed-Admin: using either the timed lock or the unlock delay. 

1. **Timed Lock:** This will pause administrator access till the specified period of time. 

	For instance, if Anand wants to forgo his administrator access for the next 2 hours, he can run:
	
	```
	sudo ./abdicate.sh "now+2hr"
	```
	
	He will now be an ordinary user for the next 2 hours, after which he will regain administrator access. The time argument is the time at which the administrator access should be regained. 
	
	See `man at` for the syntax permitted by the last argument (e.g on Fedora you might have to say `"now + 2 hour"`).  You might have to log out for changes to completely take effect. 
	
2. **Unlock Delay:** This is a slightly more complicated concept, but it is at the heart of Delayed-Admin. The [analogy](#first-an-analogy) describes this, and you also can think of it as back door to admin privileges, that requires a delay to open.

   To see the usage, let us take a scenario. Suppose Anand has already set up a program that logs him out between 10 PM-6 AM. Now, he doesn't wants to use his administrator access impulsively so he [installs](#install) Delayed-Admin. After this he should:
   
    - Lock his administrator access
      
      ```
      ./admin-helper.sh lock
      ```
      
      That is it. But depending on your OS, you might have to log out for changes to completely take effect. Now he doesn't have sudo access.
      
      ```
      ./admin-helper.sh status
      # Admin access is locked
      
      sudo whoami
      # Sorry, user Anand is not allowed to execute as root 
      ```
      
    - Until he wants to use his administrator access again. Then he can either run the `delayed` command, or unlock his administrator access using `admin-helper`. But neither of these actions will be instantaneous.
      
      ```      
      sudo delayed whoami
      # Wait for 30s before returning 
      # root
      
      sudo delayed
      # Wait for 30s before returning a root shell
      
      ./admin-helper.sh unlock
      # Wait for 30s before unlocking
      
      # Now this works.
      sudo whoami
      # root
      ```    
      He can, of course, change the delay to a larger value by editing the file `/etc/delayed-admin.conf` 
      
      **Exercise:** After following the above instructions, change the value of delay from 30s to 1200s (i.e 20min). 

### Uninstall

First, unlock yourself if your admin-access is locked. Then, to undo the changes made during the install step, run:

```
sudo ./setup.sh uninstall
```

## License

See the [LICENSE](LICENSE) file for license rights and limitations (MIT)
