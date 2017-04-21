//
//  CGTypes.swift
//  AspirinKit
//
//  Copyright © 2012 - 2017 The Web Electric Corp.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

//
//  Copyright © 2016 The Web Electric Corp. All rights reserved.
//

import Foundation
import CoreGraphics
import SpriteKit

#if os(OSX)
    import AppKit
#else
    import UIKit
#endif

public extension String {
    
    var cgFloat:CGFloat? {
        if let f = self.float {
            return CGFloat(f)
        }
        return nil
    }
    
}

#if !os(OSX)
    public extension NSValue {
        public var pointValue:CGPoint {
            return self.cgPointValue
        }
    }
#endif

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


public extension CGSize {
    public init(width:Float, height: Float) {
        self.init(width:width.cgf, height:height.cgf)
    }
}


#if os(OSX)
    public extension CGPoint {
        public init(nsPoint:NSPoint) {
            self.init(x:nsPoint.x, y:nsPoint.y)
        }
    }
    
    public extension CGSize {
        public init(nsSize:NSSize) {
            self.init(width:nsSize.width, height:nsSize.height)
        }
    }
#endif

public func absoluteDistance(between firstPoint:(CGFloat), and secondPoint:(CGFloat)) -> CGFloat {
    return CGFloat(absoluteDistance(between: firstPoint.f, and: secondPoint.f))
}

public func absoluteDistance(between firstPoint:(Float), and secondPoint:(Float)) -> Float {
    return (firstPoint > secondPoint) ? (firstPoint - secondPoint) : (secondPoint - firstPoint);
}

