# KISSBezelWindow
<img src="https://a.pomf.cat/xrsqak.png">
Show a customized bezel window from the command line

## Building
Download the source and open it in Xcode and hit run

## Usage
```/path/to/KISSPopoverBezel.app/Contents/MacOS/KISSPopoverBezel <Label> <Image> <Fade in time> <Fade out time> <How long to stay> <Sound directory(Put "none" if you dont want one)> <Blend label(true or false)> <Template(true or false)>```

Example:
```/path/to/KISSPopoverBezel.app/Contents/MacOS/KISSPopoverBezel "KISSBezelWindow" NSLockUnlockedTemplate 0.1 0.3 1.5 /System/Library/Sounds/Pop.aiff false true```

Also for easy access, I would recommend an alias
```alias kissbezelwindow="/path/to/KISSPopoverBezel.app/Contents/MacOS/KISSPopoverBezel"```

This also adapts to if you have light/dark mode on