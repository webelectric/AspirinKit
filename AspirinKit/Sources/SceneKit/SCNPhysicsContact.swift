//
//  SCNPhysicsContact.swift
//  AspirinKit
//
//  Created by Diego Doval on 2/14/17.
//
//

import Foundation
import SceneKit
import SpriteKit

public extension SCNPhysicsContact {
    public func match(_ category: Int, block: (_ matching: SCNNode, _ other: SCNNode) -> Void) {
        if self.nodeA.physicsBody!.categoryBitMask == category {
            block(self.nodeA, self.nodeB)
        }
        
        if self.nodeB.physicsBody!.categoryBitMask == category {
            block(self.nodeB, self.nodeA)
        }
    }
}
