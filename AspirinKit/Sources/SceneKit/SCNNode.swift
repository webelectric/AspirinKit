//
//  SCNNode.swift
//  AspirinKit
//
//  Copyright © 2015-2017 The Web Electric Corp. All rights reserved.
//
//

import Foundation
import SceneKit
import SpriteKit

public extension SCNNode {

    public class func sphere(ofRadius radius:Float, color:SKColor = .white) -> SCNNode {
        let geometry = SCNSphere(radius: radius.cgf)
        let material = SCNMaterial(diffuseColor: color)
        return SCNNode(geometry: geometry, material: material)
    }
    
    public class func box(ofSide side:Float, chamferRadius: Float = 0, color:SKColor = .white) -> SCNNode {
        let geometry = SCNBox(width: side.cgf, height: side.cgf, length: side.cgf, chamferRadius: chamferRadius.cgf)
        let material = SCNMaterial(diffuseColor: color)
        return SCNNode(geometry: geometry, material: material)
    }

    public class func plane(ofSide side:Float, chamferRadius: Float = 0, color:SKColor = .white) -> SCNNode {
        let geometry = SCNPlane(width: side.cgf, height: side.cgf)
        let material = SCNMaterial(diffuseColor: color)
        return SCNNode(geometry: geometry, material: material)
    }

    public convenience init(geometry:SCNGeometry, color:SKColor) {
        let material = SCNMaterial(diffuseColor: color)
        self.init(geometry: geometry, material: material)
    }

    public convenience init(geometry:SCNGeometry, material:SCNMaterial) {
        self.init(geometry: geometry)
        self.geometry?.firstMaterial = material
    }
}
