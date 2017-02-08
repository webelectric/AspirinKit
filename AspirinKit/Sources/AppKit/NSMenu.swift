//
//  NSMenu.swift
//  AspirinKit
//
//  Copyright © 2012 - 2017 The Web Electric Corp.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import AppKit

public extension NSVisualEffectView {
    
    public var isVibrant:Bool {
        set {
            self.state = newValue ? .followsWindowActiveState : .inactive
        }
        get {
            return self.state != .inactive
        }
    }
}

public extension NSMenu {
    public func itemWithRepresentedObject<T: Equatable>(_ obj:T) -> NSMenuItem? {
        for item in self.items {
            
            if let repObj = item.representedObject as? T {
                if repObj == obj {
                    return item
                }
            }
        }
        return nil
    }
}

public extension NSMenuItem {
    public var isOn:Bool {
        set {
            self.state = newValue ? NSOnState : NSOffState
        }
        get {
            return self.state == NSOnState
        }
    }
    
    public var isOff:Bool {
        set {
            self.isOn = !newValue
        }
        get {
            return !self.isOn
        }
    }
}
