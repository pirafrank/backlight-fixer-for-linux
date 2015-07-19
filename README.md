# Backlight fixer for Linux

A way to fix FN backlight keys on Linux systems **running Intel i915**

### When

When your FN keys don't work

### How to use

1. ```sudo apt-get install inotify-tools```

2. Clone this repo 

3. Edit *MULTIPLIER* variable dividing max-bri

4. Run as root the script that fits your laptop. Looking at the folders in ```/sys/class/backlight``` may help you choose.

### What's next

  - automatically set multiplier
  - check at start for inotify-tools to be installed
  - installation script
  - automatically run at startup
  - unify scripts (automatically detect non-Intel folder in /sys/class/backlight)

### Credits and License

This work is a based on [this gist](https://gist.github.com/michel-slm/1082058) by Michel Alexandre Salim then edited by me. To know about the license, read it in the script files.