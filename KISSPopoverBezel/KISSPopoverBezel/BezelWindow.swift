//
//  BezelWindow.swift
//  KISSPopoverBezel
//
//  Created by Seth on 2016-01-23.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

class BezelWindow: NSWindow {
    // Make it so this window cannot be frontmost
    override var canBecomeKeyWindow : Bool { return false }
}
