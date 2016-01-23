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
    
    // The path to the image we want to show(If its not an OSX one)
    var imagePath : String = "";
    
    // How long the bezel window should stay on screen
    var screenTime : Float = 0;
    
    // Should we blend the label?
    var blendLabel : Bool = true;
    
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
        if(NSProcessInfo.processInfo().arguments.count < 7) {
            // Print how to use the binary
            print("Usage: KISSPopoverBezel <Label> <Image> <Fade in/out time> <How long to stay> <Blend label(true or false)> <Template(true or false)>");
            
            // Quit the app
            quitApplication();
        }
        
        // Set the label views text to the first argument
        labelView.stringValue = NSProcessInfo.processInfo().arguments[1];
        
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
            
            // Set the image views image to the image at the directory specified in the second argument
            imageView.image = NSImage(byReferencingFile: imagePath);
        }
        else {
            // Set the image views image to the asset images specified in the second argument
            imageView.image = NSImage(named: NSProcessInfo.processInfo().arguments[2]);
        }
        
        // If the iamge views image is nothing...
        if(imageView.image == nil) {
            // Print to the log thatit doesnt exist and prepose what they shoild try
            print("Failed to load image \"" + NSProcessInfo.processInfo().arguments[2] + "\". Perhaps you mistyped it?");
        }
        
        // Set the animators fade in / fade out time as the third argument(Converted to a float)
        NSAnimationContext.currentContext().duration = NSTimeInterval(NSString(string: NSProcessInfo.processInfo().arguments[3]).floatValue);
        
        // Set the bezel windows screen time as the fourth argument
        screenTime = NSString(string: NSProcessInfo.processInfo().arguments[4]).floatValue;
        
        // If the fifth argument is "true"...
        if(NSProcessInfo.processInfo().arguments[5] == "true") {
            // Set blendLabel to true
            blendLabel = true;
        }
        // If the fifth argument is "false"...
        else if(NSProcessInfo.processInfo().arguments[5] == "false") {
            // Set blendLabel to false
            blendLabel = false;
        }
        
        // If the sixth argument is true...
        if(NSProcessInfo.processInfo().arguments[6] == "true") {
            // Set the image to be a template(Blend with vibrancy)
            imageView.image?.template = true;
        }
    }
    
    func fadeOutWindowAndQuit() {
        // Set the animators fade in / fade out time as the third argument(Converted to a float)(For some reason it resets it before this happens)
        NSAnimationContext.currentContext().duration = NSTimeInterval(NSString(string: NSProcessInfo.processInfo().arguments[3]).floatValue);
        
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
        
        // Start a timer for the on screen time + the animation duration, so it fades out and closes after the screen time is done
        NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(screenTime + Float(NSAnimationContext.currentContext().duration)), target:self, selector: Selector("fadeOutWindowAndQuit"), userInfo: nil, repeats:false);
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

