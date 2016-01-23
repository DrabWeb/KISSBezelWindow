# KISSBezelWindow
<img src="https://a.pomf.cat/xrsqak.png">
Show a customized bezel window from the command line

## Building
Download the source and open it in Xcode and hit run

## Usage
```/path/to/KISSPopoverBezel.app/Contents/MacOS/KISSPopoverBezel <Label text> <Image path(Can also be the name of a OSX system image like NSComputer, NSColorPanel, ETC.)> <Fade in/out time> <How long to be on screen> <Should the label blend in? (true or false)> <Should the image be vibrant? (true or false)>```

Example:
```/path/to/KISSPopoverBezel.app/Contents/MacOS/KISSPopoverBezel NSLockUnlockedTemplate 0.2 1.5 false false```

Also for easy access, I would recommend an alias
```alias kissbezelwindow="/path/to/KISSPopoverBezel.app/Contents/MacOS/KISSPopoverBezel"```

This also adapts to if you have light/dark mode on