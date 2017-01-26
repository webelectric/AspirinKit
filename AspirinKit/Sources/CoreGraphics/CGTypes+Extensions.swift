//
//  CGTypes+Extensions.swift
//  AspirinKit
//
//  Created by Diego Doval on 1/26/17.
//
//

import Foundation
import CoreGraphics

public extension CGRect {
    
    public func shrink(by dim:Float) -> CGRect {
        return self.shrink(by: CGFloat(dim))
    }
    
    public func shrink(by dim:Int) -> CGRect {
        return self.shrink(by: CGFloat(dim))
    }
    
    public func shrink(by dim:Double) -> CGRect {
        return self.shrink(by: CGFloat(dim))
    }
    
    public func shrink(by dim:CGFloat) -> CGRect {
        return CGRect(x: self.origin.x - dim, y: self.origin.y - dim, width: self.size.width - dim, height: self.size.height - dim)
    }
}
