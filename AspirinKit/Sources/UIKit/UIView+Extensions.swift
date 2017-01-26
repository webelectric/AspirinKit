//
//  UIView+Extensions.swift
//  AspirinKit
//
//  Created by Diego Doval on 1/26/17.
//
//

import Foundation
import UIKit

public extension UIView {
    public func centerInSuperview() {
        if let s = self.superview {
            self.center = CGPoint(x: s.bounds.size.width/2 - self.bounds.size.width/2, y: s.bounds.size.height/2 - self.bounds.size.height/2)
        }
    }
    
    
}
