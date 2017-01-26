//
//  UIColor+Extensions.swift
//  AspirinKit
//
//  Created by Diego Doval on 1/26/17.
//
//

import Foundation
import UIKit


public extension UIColor {
    
    public var coreImageColor: CIColor {
        return CIColor(color: self)
    }
    
    public var components: (red: Float, green: Float, blue: Float, alpha: Float) {
        let color = coreImageColor
        return (Float(color.red), Float(color.green), Float(color.blue), Float(color.alpha))
    }
}
