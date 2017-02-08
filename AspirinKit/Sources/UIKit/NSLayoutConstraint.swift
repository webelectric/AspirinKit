//
//  NSLayoutConstraint+Extensions.swift
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

import Foundation
import UIKit

///  Common NSLayoutConstraint programmatic constraints
public extension NSLayoutConstraint {
    
    public class func addConstraintsForCentering(view subView:UIView, inView toView:UIView, withSize size:CGSize) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontal:NSLayoutConstraint = NSLayoutConstraint(item: subView, attribute: .centerX, relatedBy: .equal, toItem: toView, attribute: .centerX, multiplier: 1, constant: 0)
        
        let vertical:NSLayoutConstraint = NSLayoutConstraint(item: subView, attribute: .centerY, relatedBy: .equal, toItem: toView, attribute: .centerY, multiplier: 1, constant: 0)
        
        let height:NSLayoutConstraint = NSLayoutConstraint(item: subView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: CGFloat(size.height))
        let width:NSLayoutConstraint = NSLayoutConstraint(item: subView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: CGFloat(size.width))
        
        NSLayoutConstraint.activate([width, height, horizontal, vertical])
        
    }
    
    //topBottomAttribute must be either .top or .bottom
    public class func addConstraintsForLocking(view subView:UIView, inView toView:UIView, at topBottomAttribute:NSLayoutAttribute, withHeight height:Float) {
        
        subView.translatesAutoresizingMaskIntoConstraints = false
        
        let trailing:NSLayoutConstraint = NSLayoutConstraint(item: subView, attribute: .trailing, relatedBy: .equal, toItem: toView, attribute: .trailing, multiplier: 1, constant: 0)
        let leading:NSLayoutConstraint = NSLayoutConstraint(item: subView, attribute: .leading, relatedBy: .equal, toItem: toView, attribute: .leading, multiplier: 1, constant: 0)
        let verticalLocation:NSLayoutConstraint = NSLayoutConstraint(item: subView, attribute: topBottomAttribute, relatedBy: .equal, toItem: toView, attribute: topBottomAttribute, multiplier: 1, constant: 0)
        let height:NSLayoutConstraint = NSLayoutConstraint(item: subView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: CGFloat(height))
        
        NSLayoutConstraint.activate([trailing, leading, verticalLocation, height])
        
    }
    
}
