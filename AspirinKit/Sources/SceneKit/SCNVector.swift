//
//  SCNVector.swift
//  AspirinKit
//
//  Copyright © 2015-2017 The Web Electric Corp. All rights reserved.
//
//

import Foundation
import SceneKit
import SpriteKit

extension SCNVector4: CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description: String {
        return String(format: "(%.3f,%.3f,%.3f,%.3f)", self.x, self.y, self.z, self.w)
    }
    
    public var debugDescription: String {
        return self.description
    }
}

extension SCNVector3: CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description: String {
        return String(format: "(%.3f,%.3f,%.3f)", self.x, self.y, self.z)
    }
    
    public var debugDescription: String {
        return self.description
    }
    
    public func scaled(by scale:CGFloat) -> SCNVector3 {
        return self.scaled(by:Float(scale))
    }
    
    ///returns a new SCNVector3 with each value multiplied by the scale value
    public func scaled(by scale:Float) -> SCNVector3 {
        return SCNVector3(x: self.x.f * scale, y: self.y.f * scale, z: self.z.f * scale)
    }

    ///returns a new SCNVector3 with each value multiplied by the scale value
    public func scale(by scale:CGFloat) -> SCNVector3 {
        return self.scale(by: Float(scale))
    }
    
    ///returns a new SCNVector3 with each value multiplied by the scale value
    public func scale(by scale:Float) -> SCNVector3 {
        return SCNVector3(x: self.x.f * scale.f, y: self.y.f * scale.f, z: self.z.f * scale.f)
    }
    
    public func clone() -> SCNVector3 {
        return SCNVector3(x: self.x.f, y: self.y.f, z: self.z.f)
    }
}

public func *(lhs:SCNVector3, rhs:Float) -> SCNVector3 {
    return lhs.scale(by: rhs)
}

public func *(lhs:SCNVector3, rhs:CGFloat) -> SCNVector3 {
    return lhs.scale(by: rhs)
}

public func +(lhs:SCNVector3, rhs:SCNVector3) -> SCNVector3 {
    return SCNVector3(x: lhs.x+rhs.x, y: lhs.y+rhs.y, z: lhs.z+rhs.z)
}

public func -(lhs:SCNVector3, rhs:SCNVector3) -> SCNVector3 {
    return SCNVector3(x: lhs.x-rhs.x, y: lhs.y-rhs.y, z: lhs.z-rhs.z)
}
