//
//  CATransform3D.swift
//  AspirinKit
//
//  Created by Diego Doval on 2/14/17.
//
//

import Foundation
import CoreGraphics
import QuartzCore

extension CATransform3D : CustomStringConvertible, CustomDebugStringConvertible {
    
    public var isIdentity:Bool {
        get {
            return CATransform3DIsIdentity(self)
        }
    }
    
    public var description:String {
        
        if self.isIdentity {
            return "CATransform3DIdentity"
        }
        let p = PrecisionDecimals.three
        let stringMatrix = "[\(self.m11.format(p)) \(self.m12.format(p)) \(self.m13.format(p)) \(self.m14.format(p))]\n[\(self.m21.format(p)) \(self.m22.format(p)) \(self.m23.format(p)) \(self.m24.format(p))]\n[\(self.m31.format(p)) \(self.m32.format(p)) \(self.m33.format(p)) \(self.m34.format(p))]\n[\(self.m41.format(p)) \(self.m42.format(p)) \(self.m43.format(p)) \(self.m44.format(p))]"
        
        return stringMatrix
    }
    
    public var debugDescription:String {
        return self.description
    }
}
