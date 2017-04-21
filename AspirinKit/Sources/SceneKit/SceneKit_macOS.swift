//
//  SceneKit_macOS.swift
//  AspirinKit
//
//  Copyright © 2015-2017 The Web Electric Corp. All rights reserved.
//
//

import Foundation
import SceneKit

public extension SCNVector3  {
    
    public init(x: Double, y: Double, z: Double) {
        self.init(x: CGFloat(x), y: CGFloat(y), z: CGFloat(z))
    }
    
    public init(x: Float, y: Float, z: Float) {
        self.init(x: CGFloat(x), y: CGFloat(y), z: CGFloat(z))
    }
    
    public init(x: Int, y: Int, z: Int) {
        self.init(x: CGFloat(x), y: CGFloat(y), z: CGFloat(z))
    }
}
