//
//  SceneKit_iOS.swift
//  AspirinKit
//
//  Copyright © 2015-2017 The Web Electric Corp. All rights reserved.
//
//

import Foundation
import SceneKit


public extension SCNVector3  {
    
    public init(x: Double, y: Double, z: Double) {
        self.init(x: Float(x), y: Float(y), z: Float(z))
    }
    public init(x: Int, y: Int, z: Int) {
        self.init(x: Float(x), y: Float(y), z: Float(z))
    }
    public init(x: CGFloat, y: CGFloat, z: CGFloat) {
        self.init(x: Float(x), y: Float(y), z: Float(z))
    }

}
