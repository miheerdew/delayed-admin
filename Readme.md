# Delayed Admin

A tool for administrators to (temporarily) drop admin privileges - to use tools like [Parental Controls](https://support.apple.com/kb/PH18571), [Self Control](http://selfcontrolapp.com), [etc.](https://github.com/miheerdew/delayed-admin/wiki/Tools), on themselves!

Currently it just works on my MacOS Sierra, but should be extensible to other Unix like systems too. The aim would be to create a tool like [abmindicate](http://www.pluckeye.net/abmindicate.html) for MacOS/Unix. 

If you have some suggestions for improvement please feel free to open a pull request or send me an email at miheerdew@gmail.com.

## Warning
This project is still a prototype. Only follow these instructions if you know what you are doing. There might be a possibility of locking yourself out of admin privilages. To prevent this, keep an additional administrators access.

## How does it work?

### First an analogy
Say you have a box containing an endless supply of candies, and that lately you have been eating lot more candy than you should be. After all, whenever you have an impulse to eat candy, it is so easy to just open the box and grab one. It's so hard to fight the craving! Now imagine instead that the box had a mechanism that ensures that it only opens 20min after you tell it to. Then it would be so much easier to resist the temptation of eating the candy (becuse even though the craving is there, there is nothing you can do about it, at least until the next 20min).

This is the principle Delayed-Admin is based upon. It is for users who don't want the candy-box (administrator access) to instantly open whenever desired, but still not be sealed off completely. Why would one want to do this? That is because many restrictions can be set (using admin access) that cannot be undone without it.

### The technical bit

On installation a new group called `delayed-admin` is created with an entry in the sudoers file allowing anyone in the `delayed-admin` group to run the script `/usr/local/bin/delayed` as root. The `delayed` script simply sleeps for some amount of time (as specified in `/etc/delay.conf`) and then runs the command specified in the argument.


## Initial Setup
 Usage

```sudo admin-helper```

If the current user is in the `admin` group, then the user will be instantly removed from the group. If not, then the user will be given admin privilages after a delay 20 minutes. You may need to log out, and log in again for changes to take effect.

## For OS X users
If `myadmin` is already an Admin account (which it most probably is), then you might also need to - 

* Create a new admin account if there isn't one other than `myadmin`.
* Login to the other  admin account and make `myadmin` a standard account (by unchecking "Allow user to administer this computer".

Just use the `myadmin` account. You can forget the `new-admin` account (for instance - save its password is a file readable by root only)



