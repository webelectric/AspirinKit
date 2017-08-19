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


public extension SCNNode {
    ///utility function, self.clone() + cast to SCNNode
    public func duplicate(_ duplicateGeometry:Bool = false, duplicateMaterial:Bool = false) -> SCNNode {
        let result = self.clone()
        if duplicateGeometry {
            result.geometry = self.geometry?.duplicate(duplicateMaterial)
        }
        else if duplicateMaterial {
            result.geometry?.firstMaterial = self.geometry?.firstMaterial?.duplicate()
        }
        return result
    }
    
    public func duplicateGeometry(_ duplicateMaterial:Bool = false) {
        self.geometry = self.geometry?.duplicate(duplicateMaterial)
    }
    
    public var firstChildNode:SCNNode {
        return self.childNodes[0]
    }
    
    public func cloneOfChildNode(_ named:String, recursively:Bool = true, removeFromParent:Bool = true) -> SCNNode! {
        if let node = self.childNode(withName: named, recursively: recursively) {
            let result = node.clone()
            if removeFromParent { result.removeFromParentNode() }
            return result
        }
        return nil
    }
    
    public func duplicateOfChildNode(_ named:String, recursively:Bool = true, duplicateGeometry:Bool = false, duplicateMaterial:Bool = false, removeFromParent:Bool = true) -> SCNNode! {
        if let node = self.childNode(withName: named, recursively: recursively) {
            let result = node.duplicate(duplicateGeometry, duplicateMaterial:duplicateMaterial)
            if removeFromParent { result.removeFromParentNode() }
            return result
            
        }
        return nil
    }
    
    public func adjustPositionXBy(_ x:Float) {
        self.position = SCNVector3(x: self.position.x.f + x.f, y: self.position.y.f, z: self.position.z.f)
    }
    public func adjustPositionYBy(_ y:Float) {
        self.position = SCNVector3(x: self.position.x.f, y: self.position.y.f + y.f, z: self.position.z.f)
    }
    public func adjustPositionZBy(_ z:Float) {
        self.position = SCNVector3(x: self.position.x.f, y: self.position.y.f, z: self.position.z.f + z.f)
    }
    
    public var positionX:Float {
        get {
            return self.position.x.f
        }
        set {
            self.position = SCNVector3(x: newValue, y: self.position.y.f, z: self.position.z.f)
        }
    }
    
    public var positionY:Float {
        get {
            return self.position.y.f
        }
        set {
            self.position = SCNVector3(x: self.position.x.f, y: newValue, z: self.position.z.f)
        }
    }
    
    public var positionZ:Float {
        get {
            return self.position.z.f
        }
        set {
            self.position = SCNVector3(x: self.position.x.f, y: self.position.y.f, z: newValue)
        }
    }
    
    
    public var eulerAngleX:Float {
        get {
            return self.eulerAngles.x.f
        }
        set {
            self.eulerAngles = SCNVector3(x: newValue, y: self.eulerAngles.y.f, z: self.eulerAngles.z.f)
        }
    }
    
    public var eulerAngleY:Float {
        get {
            return self.position.y.f
        }
        set {
            self.eulerAngles = SCNVector3(x: self.eulerAngles.x.f, y: newValue, z: self.eulerAngles.z.f)
        }
    }
    
    public var eulerAngleZ:Float {
        get {
            return self.eulerAngles.z.f
        }
        set {
            self.eulerAngles = SCNVector3(x: self.eulerAngles.x.f, y: self.eulerAngles.y.f, z: newValue)
        }
    }
}


public extension SCNBox {
    
    public convenience init(width: CGFloat, height: CGFloat, length: CGFloat) {
        self.init(width: width, height: height, length: height, chamferRadius: 0)
    }
    
}


extension SCNGeometry {
    ///utility function, self.copy() + cast to SCNGeometry
    public func duplicate(_ duplicateMaterial:Bool = false) -> SCNGeometry {
        
        var result:SCNGeometry!
        if self is SCNText {
            fatalError("verify duplication of SCN text works now")
            //copy() of SCNText seems bugged (results in 'NSFont instance 0x618000250d40 is over-released.')
            //creating manual copy instead
//            result = TextManager.duplicateTextGeometry(self as! SCNText)
        }
        else {
            result = self.copy() as! SCNGeometry
            if duplicateMaterial {
                result.firstMaterial = self.firstMaterial?.duplicate()
            }
        }
        return result
    }
}


extension SCNMaterial {
    
    ///utility function, self.copy() + cast to SCNMaterial
    public func duplicate() -> SCNMaterial {
        return self.copy() as! SCNMaterial
    }
}


