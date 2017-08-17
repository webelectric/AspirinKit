//
//  Device.swift
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
import CoreGraphics


extension Collection where Index == Int {
    
    /**
     Picks a random element of the collection.
     
     - returns: A random element of the collection.
     */
    func randomElement() -> Iterator.Element? {
        return isEmpty ? nil : self[Int(arc4random_uniform(UInt32(endIndex)))]
    }
    
}

/*!
 
 (ArguablyInsane)Overrides:
 
 There's some disparities between iOS and OSX types that make it impossible to work cross-platform without these additions
 For example in iOS SCNVector has x,y,z as Float whereas OSX has them as CGFloat.
 
 CGFloat and Float are, for good reasons, not automatically interchangeable
 
 So -- as a solution we create these symmetric function calls so that any Float or CGFloat or double can be easily used as the other
 since for our purposes the differences are irrelevant (ideally, everything would be floats)
 */

public extension Int {
    
    public var cgf:CGFloat {
        return CGFloat(self)
    }
    
    public var f:Float {
        return Float(self)
    }
    
    public var d:Double {
        return Double(self)
    }
    
    public var i:Int {
        return self
    }
    
    public var squared:Int {
        return self * self
    }
    
}

public extension CGFloat {
    public func asIntFromDigits(_ precision: PrecisionDecimals) -> Int {
        return Int(floor(self * CGFloat(precision.rawValue)))
    }
    
    public var cgf:CGFloat {
        return self
    }
    
    public var f:Float {
        return Float(self)
    }
    
    public var d:Double {
        return Double(self)
    }
    
    public var i:Int {
        return Int(self)
    }
    
    public var squared:CGFloat {
        return self * self
    }
    
    func scale(by scale:CGFloat) -> CGFloat {
        return self * scale
    }
}

///see showAlert functions on UIViewController and NSApplicationDelegate extensions in AspirinKit
public enum CommonAlertType {
    ///on iOS maps to .actionSheet, on macOS maps to NSApplicationDelegate.beginSheetModal
    case sheet
    ///on iOS maps to .alert, on macOS maps to NSApplicationDelegate.runModal
    case alert
}

///see showAlert functions on UIViewController and NSApplicationDelegate extensions in AspirinKit
public enum CommonAlertButtonType {
    
    ///typically used for 'ok'. on macOS this translates to firstButton, on iOS to .`default`
    case ok
    case cancel
    case destructive
}

public enum CommonAlertStyle {
    case warning, informational, critical
}

public extension Float {
    
    public var cgf:CGFloat {
        return CGFloat(self)
    }
    
    public var f:Float {
        return self
    }
    
    public var d:Double {
        return Double(self)
    }
    
    public var i:Int {
        return Int(self)
    }
    
    public var squared:Float {
        return self * self
    }
    
    func scale(by scale:Float) -> Float {
        return self * scale
    }
    
    
    ///returns the number as an Int including the number of digits requested. For example, let x = 4.356 ; x.asIntFromDigits(2) returns 435
    //this allows pseudo-fixed point comparisons
    public func asIntFromDigits(_ precision: PrecisionDecimals) -> Int {
        return Int(floor(self * Float(precision.rawValue)))
    }
    
    ///converts to a string of the format nn%, e.g. 0.85 -> 85%
    public func asPercentString() -> String {
        let intVal:Int = Int(self * 100)
        return "\(intVal)%"
    }
}

public extension Double {
    
    public var cgf:CGFloat {
        return CGFloat(self)
    }
    
    public var f:Float {
        return Float(self)
    }
    
    public var d:Double {
        return self
    }
    
    public var i:Int {
        return Int(self)
    }
    
    public var squared:Double {
        return self * self
    }
    
    ///returns the number as an Int including the number of digits requested. For example, let x = 4.356 ; x.asIntFromDigits(2) returns 435
    //this allows pseudo-fixed point comparisons
    public func asIntFromDigits(_ precision: PrecisionDecimals) -> Int {
        return Int(floor(self * Double(precision.rawValue)))
    }
    
    public func asPercentString() -> String {
        return Float(self).asPercentString()
    }
}


public extension Float {
    public func format(_ precision:PrecisionDecimals = .two) -> String {
        return String(format: precision.formatString, self) //was "%.5f" instead of formatstring
    }
}

public extension CGFloat {
    public func format(_ precision:PrecisionDecimals = .two) -> String {
        
        return String(format: precision.formatString, self) //was "%.5f" instead of formatstring
    }
}


//MARK: comparison extensions

public enum PrecisionDecimals : Int {
    case zero = 1
    case one = 10
    case two = 100
    case three = 1000
    case four = 10000
    case five = 100000
    
    public var formatString:String {
        var decimals:Int = 0
        switch self {
        case .zero:
            decimals = 0
        case .one:
            decimals = 1
        case .two:
            decimals = 2
        case .three:
            decimals = 3
        case .four:
            decimals = 4
        case .five:
            decimals = 5
        }
        return "%.\(decimals)f"
        
    }
}

public func ==(lhs:Float, rhs:(value:Float, precision: PrecisionDecimals)) -> Bool {
    return lhs.asIntFromDigits(rhs.precision) == rhs.value.asIntFromDigits(rhs.precision)
}

public func ==(lhs:CGFloat, rhs:(value:CGFloat, precision: PrecisionDecimals)) -> Bool {
    return lhs.asIntFromDigits(rhs.precision) == rhs.value.asIntFromDigits(rhs.precision)
}

public func ==(lhs:Double, rhs:(value:Double, precision: PrecisionDecimals)) -> Bool {
    return lhs.asIntFromDigits(rhs.precision) == rhs.value.asIntFromDigits(rhs.precision)
}

public func !=(lhs:Float, rhs:(value:Float, precision: PrecisionDecimals)) -> Bool {
    return lhs.asIntFromDigits(rhs.precision) != rhs.value.asIntFromDigits(rhs.precision)
}

public func !=(lhs:CGFloat, rhs:(value:CGFloat, precision: PrecisionDecimals)) -> Bool {
    return lhs.asIntFromDigits(rhs.precision) != rhs.value.asIntFromDigits(rhs.precision)
}

public func !=(lhs:Double, rhs:(value:Double, precision: PrecisionDecimals)) -> Bool {
    return lhs.asIntFromDigits(rhs.precision) != rhs.value.asIntFromDigits(rhs.precision)
}

