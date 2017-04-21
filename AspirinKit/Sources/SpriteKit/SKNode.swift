//
//  SKNode.swift
//  AspirinKit
//
//  Copyright © 2015 - 2017 The Web Electric Corp.
//
//

import Foundation
import SceneKit
import SpriteKit

public extension SKSpriteNode {
    public convenience init(imageNamed name: String, position: CGPoint, scale: CGFloat = 1.0) {
        self.init(imageNamed: name)
        self.position = position
        xScale = scale
        yScale = scale
    }
}

