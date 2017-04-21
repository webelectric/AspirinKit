//
//  Angle.swift
//  AspirinKit
//
//  Copyright © 2015-2017 The Web Electric Corp. All rights reserved.
//
//

import Foundation

public let π = Float(Double.pi)

public func==(lhs:Angle, rhs:Angle) -> Bool {
    return lhs.sign == rhs.sign && lhs.deg == rhs.deg && lhs.min == rhs.min && lhs.sec == rhs.sec
}

public func+(lhs:Angle, rhs:Angle) -> Angle {
    return lhs.add(rhs)
}

public func-(lhs:Angle, rhs:Angle) -> Angle {
    return lhs.subtract(rhs)
}

public class Angle : CustomStringConvertible {
    public var sign:Int = 1 {
        didSet {
            assert(sign == -1 || sign == 1, "Sign must be either 1 or -1")
        }
    }
    public var deg:UInt = 0
    
    public var min:UInt = 0 {
        didSet {
            assert(min < 60, "Minutes must be less than 60 (value passed=\(min), to add beyond that, check the add(seconds, minutes, degrees) function")
        }
    }
    public var sec:UInt = 0 {
        didSet {
            
            assert(sec < 60, "Seconds must be less than 60 (value passed=\(sec), to add beyond that, check the function self.add(seconds, minutes, degrees)")
        }
    }
    
    //this constructor supports overflows, so for example a call like
    //add(seconds:61, minutes:1) will turn into adding 1 second and 2 minutes
    //it's also possible to specify a sign to the values, which will result in the
    //"correct" assignment
    public init(degrees d:Int = 0, minutes m:Int = 0, seconds s:Int = 0) {
        
        var degValue = d
        var minValue = m
        var secValue = s
        
        if secValue < 0 || secValue > 59 {
            //with this calculation, for example 0' -59'' would turn into -1' 1''
            //the next if() statement would carry the negative over to the degrees
            let sign = secValue < 0 ? -1 : 1
            secValue = abs(secValue)
            minValue += (secValue / 60) * sign //minutes 'overflow' from seconds
            secValue = (secValue % 60)
        }
        
        if minValue < 0 || minValue > 59 {
            let sign = minValue < 0 ? -1 : 1
            minValue = abs(minValue)
            degValue += (minValue / 60) * sign //degrees 'overflow' from minutes
            minValue = (minValue % 60)
        }
        
        self.sign = degValue >= 0 ? 1 : -1
        degValue = abs(degValue)
        
        self.deg = UInt(degValue)
        self.min = UInt(minValue)
        self.sec = UInt(secValue)
    }
    
    public init(degrees d:Float) {
        self.degrees = d
    }
    
    public init(radians r:Float) {
        self.radians = r
    }
    
    public convenience init(degrees d:Double) {
        self.init(degrees:Float(d))
    }
    
    public convenience init(radians r:Double) {
        self.init(radians:Float(r))
    }
    
    public var degrees:Float {
        get {
            let val:Float = Float(deg) + (Float(min)/60) +  (Float(sec)/3600)
            return val * Float(sign)
        }
        set {
            self.sign = newValue < 0 ? -1 : 1
            let absNewValue = abs(newValue)
            let degVal:Float = floor(absNewValue)
            self.deg = UInt(degVal)
            let decimals:Float = (absNewValue - degVal)
            if decimals > 0 {
                let m:Float = decimals*60
                self.min = UInt(floor(m))
                let s:Float = abs((decimals - (m/60)) * 3600) // it's possible to get results like -0.001etc due to Float calculation innacuracies
                self.sec = UInt(floor(s))
            }
            else {
                self.min = 0
                self.sec = 0
            }
        }
    }
    
    public let degreesPerRadian:Float = (Float(Double.pi * 2)/Float(360))
    
    public var radians:Float {
        get {
            return self.degrees * self.degreesPerRadian
        }
        set {
            self.degrees = newValue/self.degreesPerRadian
        }
    }
    
    public var description: String {
        return "Angle: \(deg)°\(min)'\(sec)'' = \(degrees)° = \(radians) radians"
    }
    
    public func subtract(_ angle:Angle) -> Angle {
        return Angle(degrees: self.degrees-angle.degrees)
    }
    
    public func subtract(degrees d:Int = 0, minutes m:Int = 0, seconds s:Int = 0) -> Angle {
        return self.subtract(Angle(degrees: d, minutes: m, seconds: s))
    }
    
    //this function supports overflows, so for example a call like
    //add(seconds:61, minutes:1) will turn into adding 1 second and 2 minutes
    public func add(_ angle:Angle) -> Angle {
        return Angle(degrees: self.degrees+angle.degrees)
    }
    
    //this function supports overflows, so for example a call like
    //add(seconds:61, minutes:1) will turn into adding 1 second and 2 minutes
    public func add(degrees d:Int = 0, minutes m:Int = 0, seconds s:Int = 0) -> Angle {
        return self.add(Angle(degrees: d, minutes: m, seconds: s))
    }
}
