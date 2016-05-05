# Delayed Admin

## What is it?
This is a tool for administrators to drop admin privilages - to use tools like [Parental Controls](https://support.apple.com/kb/PH18571), [Self Control](http://selfcontrolapp.com) on themselves!

## Intial Setup

First login using an Admin account, open terminal and type -

```
sudo mkdir -p /private/etc/sudoers.d/
EDITOR="cp delayed-admin.sudoers" sudo visudo -f /private/etc/sudoers.d/delayed-admin
sudo cp admin-helper /usr/local/bin/admin-helper
```

## Usage

```sudo admin-helper```

If the current user is in the `admin` group, then the user will be removed from the group. If not, then the user will be given admin privilages after a delay 20 minutes
