//
//  NSLayoutConstraint+Extensions.swift
//  AspirinKit
//
//  Created by Diego Doval on 1/26/17.
//
//

//
//  NSLayoutConstraint+Programmatic.swift
//  Common NSLayoutConstraint programmatic constraints
//
//  Created by Diego Doval
//  Copyright © 2016 The Web Electric Corp. All rights reserved.
//

import Foundation
import UIKit

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
