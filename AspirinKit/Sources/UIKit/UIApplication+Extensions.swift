//
//  Thread.swift
//  AspirinKit
//
//  Copyright © 2014 - 2017 The Web Electric Corp.
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

public extension UIApplication {
    
    public class func findTopViewController(_ baseVC: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let navController = baseVC as? UINavigationController {
            return self.findTopViewController(navController.visibleViewController)
        }
        
        if let tabBarVC = baseVC as? UITabBarController {
            
            let moreNavigationController = tabBarVC.moreNavigationController
            
            if let topVC = moreNavigationController.topViewController, topVC.view.window != nil {
                return self.findTopViewController(topVC)
            }
            else if let selectedViewController = tabBarVC.selectedViewController {
                return self.findTopViewController(selectedViewController)
            }
        }
        
        if let splitVC = baseVC as? UISplitViewController, splitVC.viewControllers.count == 1 {
            return self.findTopViewController(splitVC.viewControllers[0])
        }
        
        if let presentedVC = baseVC?.presentedViewController {
            return self.findTopViewController(presentedVC)
        }
        
        return baseVC
    }
}


