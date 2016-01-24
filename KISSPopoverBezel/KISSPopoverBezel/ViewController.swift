//
//  ViewController.swift
//  KISSPopoverBezel
//
//  Created by Seth on 2016-01-23.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    // The window that shows the bezel
    var window : NSWindow = NSWindow();
    
    // The visual effect view for the background of the window
    @IBOutlet weak var backgroundVisualEffectView: NSVisualEffectView!
    
    // The label for the bezel window
    @IBOutlet weak var labelView: NSTextField!
    
    // The image view for the bezel window
    @IBOutlet weak var imageView: NSImageView!
    
    // The image view for the bezel window when it should take up the whole window
    @IBOutlet weak var fullSizeImageView: NSImageView!
    
    // The path to the image we want to show(If its not an OSX one)
    var imagePath : String = "";
    
    // The path to the sound file to play(If any)
    var soundPath : String = "";
    
    // The actual sound
    var sound : NSSound = NSSound();
    
    // How long the bezel window should stay on screen
    var screenTime : Float = 0;
    
    // Should we blend the label?
    var blendLabel : Bool = true;
    
    // How long the bezel window should take to fade out
    var fadeOutTime : Float = 0;
    
    // Do we want to show a full size image?
    var fullSize : Bool = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Set the window to load the data we want displayed
        getAndSetValues();
        
        // Style the window
        styleWindow();
    }
    
    func getAndSetValues() {
        // If the argument count is less than 6...
        if(NSProcessInfo.processInfo().arguments.count < 8) {
            // Print how to use the binary
            print("Usage: KISSPopoverBezel <Label> <Image> <Fade in time> <Fade out time> <How long to stay> <Sound directory(Put \"none\" if you dont want one)> <Blend label(true or false)> <Template(true or false)>");
            
            // Quit the app
            quitApplication();
        }
        
        // If we passed a label...
        if(NSProcessInfo.processInfo().arguments[1] != "") {
            // Set the label views text to the first argument
            labelView.stringValue = NSProcessInfo.processInfo().arguments[1];
        }
        else {
            // Set fullSize to true
            fullSize = true;
            
            // Hide the label
            labelView.hidden = true;
            
            // Hide the regular image view
            imageView.hidden = true;
            
            // Show the full size image view
            fullSizeImageView.hidden = false;
        }
        
        // If the second argument contains a /...
        if(NSProcessInfo.processInfo().arguments[2].containsString("/")) {
            // Set imagePath to the second argument
            imagePath = NSProcessInfo.processInfo().arguments[2];
            
            // If the first character is a ~...
            if(imagePath.characters.first == "~") {
                // Remove the first character
                imagePath = imagePath.substringFromIndex(imagePath.startIndex);
                
                // Prepend the home directory
                imagePath = NSHomeDirectory() + imagePath;
            }
            
            // If we said to have a full size image...
            if(fullSize) {
                // Set the full size image views image to the image at the directory specified in the second argument
                fullSizeImageView.image = NSImage(byReferencingFile: imagePath);
            }
            else {
                // Set the image views image to the image at the directory specified in the second argument
                imageView.image = NSImage(byReferencingFile: imagePath);
            }
        }
        else {
            // If we said to have a full size image...
            if(fullSize) {
                // Set the full size image views image to the asset images specified in the second argument
                fullSizeImageView.image = NSImage(named: NSProcessInfo.processInfo().arguments[2]);
            }
            else {
                // Set the image views image to the asset images specified in the second argument
                imageView.image = NSImage(named: NSProcessInfo.processInfo().arguments[2]);
            }
        }
        
        // If we arent in full size mode...
        if(!fullSize) {
            // If the image views image is nothing...
            if(imageView.image == nil) {
                // Print to the log that it doesnt exist and prepose what they should try
                print("Failed to load image \"" + NSProcessInfo.processInfo().arguments[2] + "\". Perhaps you mistyped it?");
            }
        }
        else {
            // If the full size image views image is nothing...
            if(fullSizeImageView.image == nil) {
                // Print to the log that it doesnt exist and prepose what they should try
                print("Failed to load image \"" + NSProcessInfo.processInfo().arguments[2] + "\". Perhaps you mistyped it?");
            }
        }
        
        // Set the animators fade in time as the third argument(Converted to a float)
        NSAnimationContext.currentContext().duration = NSTimeInterval(NSString(string: NSProcessInfo.processInfo().arguments[3]).floatValue);
        
        // Set the fade out time as the fourth argument(Converted to a float)
        fadeOutTime = NSString(string: NSProcessInfo.processInfo().arguments[4]).floatValue;
        
        // Set the bezel windows screen time as the fifth argument
        screenTime = NSString(string: NSProcessInfo.processInfo().arguments[5]).floatValue;
        
        // If the sixth argument is not "none"...
        if(NSProcessInfo.processInfo().arguments[6] != "none") {
            // Set soundPath to the sixth argument
            soundPath = NSProcessInfo.processInfo().arguments[6];
            
            // If the first character is a ~...
            if(imagePath.characters.first == "~") {
                // Remove the first character
                soundPath = soundPath.substringFromIndex(soundPath.startIndex);
                
                // Prepend the home directory
                soundPath = NSHomeDirectory() + soundPath;
            }
            
            // Set sound to be the file at soundPath
            sound = NSSound(contentsOfFile: soundPath, byReference: false)!;
        }
        
        // If the seventh argument is "true"...
        if(NSProcessInfo.processInfo().arguments[7] == "true") {
            // Set blendLabel to true
            blendLabel = true;
        }
        // If the seventh argument is "false"...
        else if(NSProcessInfo.processInfo().arguments[7] == "false") {
            // Set blendLabel to false
            blendLabel = false;
        }
        
        // If the eigth argument is true...
        if(NSProcessInfo.processInfo().arguments[8] == "true") {
            // Set the image to be a template(Blend with vibrancy)
            imageView.image?.template = true;
        }
    }
    
    func fadeOutWindowAndQuit() {
        // Set the animators duration to the fade out time
        NSAnimationContext.currentContext().duration = NSTimeInterval(fadeOutTime);
        
        // Fade out the window
        window.animator().alphaValue = 0;
        
        // Wait for the animations duration
        NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(NSAnimationContext.currentContext().duration), target:self, selector: Selector("quitApplication"), userInfo: nil, repeats:false);
    }
    
    func quitApplication() {
        // Tell the application to terminate
        NSApplication.sharedApplication().terminate(self);
    }
    
    func styleWindow() {
        // Get the main window
        window = NSApplication.sharedApplication().windows.last!;
        
        // Hide the window
        window.alphaValue = 0;
        
        // Destroy the windows titlebar
        window.standardWindowButton(NSWindowButton.CloseButton)?.superview?.superview?.removeFromSuperview();
        
        // Make it so we cant move the window
        window.movable = false;
        
        // Set the window so it can be transparent
        window.opaque = false;
        
        // Set the windows background color to clear
        window.backgroundColor = NSColor.clearColor();
        
        // Set the windows level to be high enough to float over everything else we need to
        window.level = 30;
        
        // Set the background visual effect views material to popover
        backgroundVisualEffectView.material = NSVisualEffectMaterial.Popover;
        
        // If the apple interface style is nil...
        if((NSUserDefaults.standardUserDefaults().stringForKey("AppleInterfaceStyle")) == nil) {
            // Its in light mode, set the background effect views material to match
            // Set it to light
            backgroundVisualEffectView.material = NSVisualEffectMaterial.Light;
            
            // Set it to have the vibrant light appearance
            backgroundVisualEffectView.appearance = NSAppearance(named: NSAppearanceNameVibrantLight);
            
            // Set the material to popover again
            backgroundVisualEffectView.material = NSVisualEffectMaterial.Popover;
        }
        
        // If we said to blend the label...
        if(blendLabel) {
            // Make the label blend in, its ugly without this(In my opinion)
            labelView.alphaValue = 0.4;
        }
        
        // Fade in the window
        window.animator().alphaValue = 1;
        
        // If there was a sound loaded...
        if(sound != NSSound()) {
            // Play the sound
            sound.play();
        }
        
        // Start a timer for the on screen time + the animation duration, so it fades out and closes after the screen time is done
        NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(screenTime + Float(NSAnimationContext.currentContext().duration)), target:self, selector: Selector("fadeOutWindowAndQuit"), userInfo: nil, repeats:false);
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

