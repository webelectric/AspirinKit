//
//  Keyboard.swift
//  AspirinKit
//
//  Copyright © 2014 - 2017 The Web Electric Corp.
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
import Carbon
import Cocoa

public typealias KeyComboAction = (Keyboard.KeyCombo,NSEvent?) -> Void

public class GlobalHotKey : Hashable, Equatable {
    public let hotKeyRef:EventHotKeyRef
    public let hotKeyID:UInt32
    
    public init(_ id:UInt32, hotKeyReference:EventHotKeyRef) {
        hotKeyID = id
        hotKeyRef = hotKeyReference

    }
    
    public var hashValue: Int {
        return Int(hotKeyID)
    }
}

public func ==(lhs:GlobalHotKey, rhs:GlobalHotKey) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

private var signaturesToKeyboards:[OSType: Keyboard] = [OSType: Keyboard]()

/**
    Blocks-aware class to simplify OS X keyboard binding on OS X apps using Swift 3
 
    Features:
    * Supports app as well as global hotkeys
    * Swift-friendly wrapper on common Cocoa/Carbon functions
    * Supports multiple instances, plus one default shared keyboard
 
    Example use
 
    ```
        let cmdShiftSpaceCombo = Keyboard.KeyCombo(keyCode: Keyboard.Keys.Space,
                                                    modifierFlags: [.command, .shift])
 
        //register (bind) global keycombo
        Keyboard.sharedKeyboard.bindGlobalKeyCombo(cmdShiftSpaceCombo, action: { [unowned self] (keyCombo:Keyboard.KeyCombo, event: NSEvent?) -> Void  in

                print("CMD-Shift-Space pressed")
        })

        ....
        
 
        //deregister (unbind) global keycombo
        Keyboard.sharedKeyboard.unbindGlobalKeyCombo(cmdShiftSpaceCombo1)


    ```
 
 */
public class Keyboard {
    private static let defaultHotKeySignature:String = "akey"
    var nextHotKeyID:UInt32 = UInt32(1)
    
    private static let __once: () = { () -> Void in
        //one-time init tasks
        
    }()
    
    /*
     *    Virtual keycodes // Values (not constant names)
     *    are From Carbon/Frameworks/HIToolbox/Events.h:
     *
     *    //Original Events.h comment
     *    These constants are the virtual keycodes defined originally in
     *    Inside Mac Volume V, pg. V-191. They identify physical keys on a
     *    keyboard. Those constants with "ANSI" in the name are labeled
     *    according to the key position on an ANSI-standard US keyboard.
     *    For example, kVK_ANSI_A indicates the virtual keycode for the key
     *    with the static letter 'A' in the US keyboard layout. Other keyboard
     *    layouts may have the 'A' key label on a different physical key;
     *    in this case, pressing 'A' will generate a different virtual
     *    keycode.
     */
    public struct Keys {
        public static let A:UInt16 = 0x00
        public static let S:UInt16 = 0x01
        public static let D:UInt16 = 0x02
        public static let F:UInt16 = 0x03
        public static let H:UInt16 = 0x04
        public static let G:UInt16 = 0x05
        public static let Z:UInt16 = 0x06
        public static let X:UInt16 = 0x07
        public static let C:UInt16 = 0x08
        public static let V:UInt16 = 0x09
        public static let B:UInt16 = 0x0B
        public static let Q:UInt16 = 0x0C
        public static let W:UInt16 = 0x0D
        public static let E:UInt16 = 0x0E
        public static let R:UInt16 = 0x0F
        public static let Y:UInt16 = 0x10
        public static let T:UInt16 = 0x11
        public static let NUM_1:UInt16 = 0x12
        public static let NUM_2:UInt16 = 0x13
        public static let NUM_3:UInt16 = 0x14
        public static let NUM_4:UInt16 = 0x15
        public static let NUM_6:UInt16 = 0x16
        public static let NUM_5:UInt16 = 0x17
        public static let Equal:UInt16 = 0x18
        public static let NUM_9:UInt16 = 0x19
        public static let NUM_7:UInt16 = 0x1A
        public static let Minus:UInt16 = 0x1B
        public static let NUM_8:UInt16 = 0x1C
        public static let NUM_0:UInt16 = 0x1D
        public static let RightBracket:UInt16 = 0x1E
        public static let O:UInt16 = 0x1F
        public static let U:UInt16 = 0x20
        public static let LeftBracket:UInt16 = 0x21
        public static let I:UInt16 = 0x22
        public static let P:UInt16 = 0x23
        public static let L:UInt16 = 0x25
        public static let J:UInt16 = 0x26
        public static let Quote:UInt16 = 0x27
        public static let K:UInt16 = 0x28
        public static let Semicolon:UInt16 = 0x29
        public static let Backslash:UInt16 = 0x2A
        public static let Comma:UInt16 = 0x2B
        public static let Slash:UInt16 = 0x2C
        public static let N:UInt16 = 0x2D
        public static let M:UInt16 = 0x2E
        public static let Period:UInt16 = 0x2F
        public static let Grave:UInt16 = 0x32
        public static let KeypadDecimal:UInt16 = 0x41
        public static let KeypadMultiply:UInt16 = 0x43
        public static let KeypadPlus:UInt16 = 0x45
        public static let KeypadClear:UInt16 = 0x47
        public static let KeypadDivide:UInt16 = 0x4B
        public static let KeypadEnter:UInt16 = 0x4C
        public static let KeypadMinus:UInt16 = 0x4E
        public static let KeypadEquals:UInt16 = 0x51
        public static let Keypad0:UInt16 = 0x52
        public static let Keypad1:UInt16 = 0x53
        public static let Keypad2:UInt16 = 0x54
        public static let Keypad3:UInt16 = 0x55
        public static let Keypad4:UInt16 = 0x56
        public static let Keypad5:UInt16 = 0x57
        public static let Keypad6:UInt16 = 0x58
        public static let Keypad7:UInt16 = 0x59
        public static let Keypad8:UInt16 = 0x5B
        public static let Keypad9:UInt16 = 0x5C
        
        /* keycodes for keys that are independent of keyboard layout*/
        public static let Return:UInt16 = 0x24
        public static let Tab   :UInt16 = 0x30
        public static let Space :UInt16 = 0x31
        public static let Delete:UInt16 = 0x33
        public static let Escape:UInt16 = 0x35
        public static let Command:UInt16 = 0x37
        public static let Shift:UInt16 = 0x38
        public static let CapsLock:UInt16 = 0x39
        public static let Option:UInt16 = 0x3A
        public static let Control:UInt16 = 0x3B
        public static let RightShift:UInt16 = 0x3C
        public static let RightOption:UInt16 = 0x3D
        public static let RightControl:UInt16 = 0x3E
        public static let Function:UInt16 = 0x3F
        public static let F17   :UInt16 = 0x40
        public static let VolumeUp:UInt16 = 0x48
        public static let VolumeDown:UInt16 = 0x49
        public static let Mute  :UInt16 = 0x4A
        public static let F18   :UInt16 = 0x4F
        public static let F19   :UInt16 = 0x50
        public static let F20   :UInt16 = 0x5A
        public static let F5    :UInt16 = 0x60
        public static let F6    :UInt16 = 0x61
        public static let F7    :UInt16 = 0x62
        public static let F3    :UInt16 = 0x63
        public static let F8    :UInt16 = 0x64
        public static let F9    :UInt16 = 0x65
        public static let F11   :UInt16 = 0x67
        public static let F13   :UInt16 = 0x69
        public static let F16   :UInt16 = 0x6A
        public static let F14   :UInt16 = 0x6B
        public static let F10   :UInt16 = 0x6D
        public static let F12   :UInt16 = 0x6F
        public static let F15   :UInt16 = 0x71
        public static let Help  :UInt16 = 0x72
        public static let Home  :UInt16 = 0x73
        public static let PageUp:UInt16 = 0x74
        public static let ForwardDelete:UInt16 = 0x75
        public static let F4    :UInt16 = 0x76
        public static let End   :UInt16 = 0x77
        public static let F2    :UInt16 = 0x78
        public static let PageDown:UInt16 = 0x79
        public static let F1    :UInt16 = 0x7A
        public static let LeftArrow:UInt16 = 0x7B
        public static let RightArrow:UInt16 = 0x7C
        public static let DownArrow:UInt16 = 0x7D
        public static let UpArrow:UInt16 = 0x7E
        
        //convenience pre-set combos
        public static let CTRL_LEFT_ARROW:KeyCombo = KeyCombo(keyCode: Keys.LeftArrow, modifierFlags: NSEventModifierFlags.control)
        public static let CTRL_RIGHT_ARROW:KeyCombo = KeyCombo(keyCode: Keys.RightArrow, modifierFlags: NSEventModifierFlags.control)
        public static let CTRL_DOWN_ARROW:KeyCombo = KeyCombo(keyCode: Keys.DownArrow, modifierFlags: NSEventModifierFlags.control)
        public static let CTRL_UP_ARROW:KeyCombo = KeyCombo(keyCode: Keys.UpArrow, modifierFlags: NSEventModifierFlags.control)
        public static let CTRL_SHIFT_LEFT_ARROW:KeyCombo = KeyCombo(keyCode: Keys.LeftArrow, modifierFlags: [.control, .shift])
        public static let CTRL_SHIFT_RIGHT_ARROW:KeyCombo = KeyCombo(keyCode: Keys.RightArrow, modifierFlags: [.control, .shift])
        public static let CTRL_SHIFT_DOWN_ARROW:KeyCombo = KeyCombo(keyCode: Keys.DownArrow, modifierFlags: [.control, .shift])
        public static let CTRL_SHIFT_UP_ARROW:KeyCombo = KeyCombo(keyCode: Keys.UpArrow, modifierFlags: [.control,.shift])
        public static let CMD_LEFT_ARROW:KeyCombo = KeyCombo(keyCode: Keys.LeftArrow, modifierFlags: NSEventModifierFlags.command)
        public static let CMD_RIGHT_ARROW:KeyCombo = KeyCombo(keyCode: Keys.RightArrow, modifierFlags: NSEventModifierFlags.command)
        public static let CMD_DOWN_ARROW:KeyCombo = KeyCombo(keyCode: Keys.DownArrow, modifierFlags: NSEventModifierFlags.command)
        public static let CMD_UP_ARROW:KeyCombo = KeyCombo(keyCode: Keys.UpArrow, modifierFlags: NSEventModifierFlags.command)
        
    }
    
    //IMPORTANT: internally, NEVER use the "modifier flags" value for comparisons since it may contain additional data
    //from an event generated by the system
    public class KeyCombo : Hashable, Equatable {
        public var keyCode:UInt16
        var modifierFlags:NSEventModifierFlags
        public var hasModifiers:Bool { return !modifierFlags.isEmpty }
        public var isCtrlPressed:Bool { return modifierFlags.contains(.control)  }
        public var isCommandPressed:Bool { return modifierFlags.contains(.command)  }
        public var isAltPressed:Bool { return modifierFlags.contains(NSEventModifierFlags.option)  }
        public var isShiftPressed:Bool { return modifierFlags.contains(.shift)  }
        var globalHotKey:GlobalHotKey!
        
        public var carbonModifierFlags:UInt32 {
            var newFlags:Int = 0
            
            if (self.isCtrlPressed) { newFlags |= controlKey }
            if (self.isCommandPressed) { newFlags |= cmdKey }
            if (self.isShiftPressed) { newFlags |= shiftKey }
            if (self.isAltPressed) { newFlags |= optionKey }
            
            return UInt32(newFlags)
        }
        
        var _precomputedHash:Int = 0
        
        public convenience init(event: NSEvent) {
            self.init(keyCode: event.keyCode, modifierFlags: event.modifierFlags)
        }
        
        public init(keyCode:UInt16, modifierFlags:NSEventModifierFlags = []) {
            self.keyCode = keyCode
            self.modifierFlags = modifierFlags
            
            //the hash is simply the keycode plus a power of two value above 2^16 for each
            //of the modifiers, using the bitspace between 17 and 32
            _precomputedHash = Int(keyCode)
            _precomputedHash = isCommandPressed ? ((2 << 17)+_precomputedHash) : _precomputedHash
            _precomputedHash = isCtrlPressed ? ((2 << 18)+_precomputedHash) : _precomputedHash
            _precomputedHash = isAltPressed ? ((2 << 19)+_precomputedHash) : _precomputedHash
            _precomputedHash = isShiftPressed ? ((2 << 20)+_precomputedHash) : _precomputedHash
            
        }
        
        public var hashValue:Int {
            return _precomputedHash
        }
    }
    
    //app keybindings
    var keyBindings:[KeyCombo: KeyComboAction] = [KeyCombo: KeyComboAction]()
    //global os-wide keybindings
    var globalKeyBindings:[KeyCombo: KeyComboAction] = [KeyCombo: KeyComboAction]()
    var globalHotKeyIDsToKeyCombo:[UInt32:KeyCombo] = [UInt32:KeyCombo]()
    var globalKeyCombostoHotKeyID:[KeyCombo:UInt32] = [KeyCombo:UInt32]()
    
    public static let sharedKeyboard:Keyboard = Keyboard(withSignature:Keyboard.defaultHotKeySignature)!
    
    private var hotKeySignature:OSType
    private var eventHandlerReference:EventHandlerRef!
    
    init?(withSignature hkSignature:String) {
        
        let sigCode = OSType(hkSignature.fourCharCode)
        
        if signaturesToKeyboards[sigCode] != nil {
            print("Error, can't register Keyboard signature [\(hkSignature)] twice.")
            return nil
        }
        
        _ = Keyboard.__once
        
        self.hotKeySignature = sigCode
        
        self.installGlobalEventHandler()
    }
    
    deinit {
        _ = RemoveEventHandler(eventHandlerReference)
    }
    
    func installGlobalEventHandler() {
        
        signaturesToKeyboards[self.hotKeySignature] = self
        
        var eventTypeSpec = EventTypeSpec()
        eventTypeSpec.eventClass = OSType(kEventClassKeyboard)
        eventTypeSpec.eventKind = OSType(kEventHotKeyPressed)

        var handlerRef:EventHandlerRef? = nil
        
        InstallEventHandler(GetApplicationEventTarget(), {(nextHandler, theEventRef, userData) -> OSStatus in
            
            guard let eventRef = theEventRef else {
                return noErr
            }
            
            var hkCom = EventHotKeyID()
            
            GetEventParameter(eventRef, EventParamName(kEventParamDirectObject), EventParamType(typeEventHotKeyID), nil, MemoryLayout<EventHotKeyID>.size, nil, &hkCom)
            
            //we place the keyboard objects in a global (private) map to be able to use the simpler
            //registration using a closure. A C function pointer cannot be formed from a closure that captures context
            if let keyboard = signaturesToKeyboards[hkCom.signature] {
                if let keyCombo = keyboard.globalHotKeyIDsToKeyCombo[hkCom.id] {
                    _ = keyboard.processKeyCombo(keyCombo, event: nil, bindings: keyboard.globalKeyBindings)
                }
            }
            
            
            return noErr
            
        }, 1, &eventTypeSpec, nil, &handlerRef)
        
        self.eventHandlerReference = handlerRef

        assert(self.eventHandlerReference != nil)
    }
    
    public func bindKey(_ key:UInt16, action:@escaping KeyComboAction) {
        bindKeyCombo(KeyCombo(keyCode: key), action: action)
    }
    
    public func bindKeyCombo(_ keyCombo:KeyCombo, action:@escaping KeyComboAction) {
        keyBindings[keyCombo] = action
    }
    
    @discardableResult
    public func bindGlobalKeyCombo(_ keyCombo:KeyCombo, action:@escaping KeyComboAction) -> Bool {
        
        if (globalKeyBindings[keyCombo] != nil) {
            NSLog("Warning: Attempting to re-register global keycombo \(keyCombo), ignoring.")
            return true
        }

        var newHotKeyID = EventHotKeyID()
        newHotKeyID.signature = self.hotKeySignature
        newHotKeyID.id = nextHotKeyID
        nextHotKeyID = nextHotKeyID.advanced(by: 1)
        var carbonHotKey:EventHotKeyRef? = nil
        
        let status = RegisterEventHotKey(UInt32(keyCombo.keyCode), keyCombo.carbonModifierFlags, newHotKeyID, GetApplicationEventTarget(), 0, &carbonHotKey)

        if let cHK = carbonHotKey {
            keyCombo.globalHotKey = GlobalHotKey(newHotKeyID.id, hotKeyReference: cHK)
            globalKeyBindings[keyCombo] = action
            globalHotKeyIDsToKeyCombo[newHotKeyID.id] = keyCombo
            globalKeyCombostoHotKeyID[keyCombo] = newHotKeyID.id
        }
        else {
            print("ERROR, carbon hot key nil. RegisterEventHotKey returned [\(status)].")
        }
        
        
        return true
    }
    
    public func unbindKey(_ key:UInt16) {
        unbindKeyCombo(KeyCombo(keyCode: key))
    }
    
    public func unbindKeyCombo(_ keyCombo: KeyCombo) {
        keyBindings.removeValue(forKey: keyCombo)
    }
    
    public func unbindGlobalKeyCombo(_ keyCombo: KeyCombo) {
        
        if (globalKeyBindings[keyCombo] == nil) {
            NSLog("Warning: Attempting to unregister global keycombo \(keyCombo) that is not in dictionary of bindings, ignoring.")
            return
        }
        
        if let hotKeyID = globalKeyCombostoHotKeyID[keyCombo] {
            let actualKeyCombo = globalHotKeyIDsToKeyCombo.removeValue(forKey: hotKeyID)!
            UnregisterEventHotKey(actualKeyCombo.globalHotKey.hotKeyRef)
            globalKeyCombostoHotKeyID.removeValue(forKey: keyCombo)
        }
        globalKeyBindings.removeValue(forKey: keyCombo)
    }
    
    ///process key event, returns false if no bindings match
    public func processEvent(_ event: NSEvent!) -> Bool {
        return self.processEvent(event, bindings: self.keyBindings)
    }
    
    func processEvent(_ e: NSEvent!, bindings:[KeyCombo: KeyComboAction]) -> Bool {
        if let event = e {
            let keyCombo:KeyCombo = event.toKeyCombo()
            return processKeyCombo(keyCombo, event: event, bindings: bindings)
        }
        return false
    }
    
    func processKeyCombo(_ keyCombo: KeyCombo, event: NSEvent!, bindings:[KeyCombo: KeyComboAction]) -> Bool {
        let block:KeyComboAction? = bindings[keyCombo]
        
        if let runBlock = block {
            Thread.dispatchAsyncInBackground({ () -> Void in
                runBlock(keyCombo, event)
            })
        }
        
        return block != nil
    }
    
    
}


public func == (lhs: Keyboard.KeyCombo, rhs: Keyboard.KeyCombo) -> Bool {
    //we compare the precomputed hash since comparing keycode + modifierFlags runs the risk that modifierFlags has extraneous data
    return lhs.hashValue == rhs.hashValue
}


public extension NSEvent {
    public func toKeyCombo() -> Keyboard.KeyCombo { return Keyboard.KeyCombo(keyCode: self.keyCode, modifierFlags: self.modifierFlags) }
}



