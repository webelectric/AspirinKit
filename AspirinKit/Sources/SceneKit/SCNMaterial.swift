//
//  SCNMaterial.swift
//  AspirinKit
//
//  Copyright © 2015-2017 The Web Electric Corp. All rights reserved.
//
//

import Foundation
import SceneKit
import SpriteKit

public extension SCNMaterial {
    
    public convenience init(diffuseColor:SKColor) {
        self.init()
        self.diffuse.contents = diffuseColor
    }
    
}
