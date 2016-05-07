# Delayed Admin

A tool for administrators to (temporarily) drop admin privilages - to use tools like [Parental Controls](https://support.apple.com/kb/PH18571), [Self Control](http://selfcontrolapp.com), [etc.](https://github.com/miheerdew/delayed-admin/wiki/Tools), on themselves!

Currently it's just tested on my `OS-X El Captain`, but should be extensible to other Unix like systems too.

## How does it work?
The `admin-helper` script adds/removes the user from the `admin` group. Privilage escalation does not happen instantly but requires a delay of 20min thereby serving as a deterrent.

The permission to run the `admin-helper` is given through the [sudoers](https://www.garron.me/en/linux/visudo-command-sudoers-file-sudo-default-editor.html) mechanism.

## Intial Setup

Download and open the `delayed-admin` directory.

Open the `delayed-admin.sudoers` in an editor and change 

``User_Alias DELAYED_ADMINS =``

to

``User_Alias DELAYED_ADMINS = myadmin``

Where `myadmin` is the name of the user for whom you want to (temporarily) drop admin privilages.

Now open the `delayed-admin` directory in the terminal (from an admin account) and type -

```
sudo mkdir -p /private/etc/sudoers.d/
EDITOR="cp delayed-admin.sudoers" sudo visudo -f /private/etc/sudoers.d/delayed-admin
sudo cp admin-helper /usr/local/bin/admin-helper
```

## Usage

```sudo admin-helper```

If the current user is in the `admin` group, then the user will be instantly removed from the group. If not, then the user will be given admin privilages after a delay 20 minutes

## For OS X users
If `myadmin` is already an Admin account (which it most probably is), then you might also need to - 

* Create a new admin account if there isn't one other than `myadmin`.
* Login to the other  admin account and make `myadmin` a standard account (by unchecking "Allow user to administer this computer".

Just use the `myadmin` account. You can forget the `new-admin` account (for instance - save it's password is a file readable by root only)



