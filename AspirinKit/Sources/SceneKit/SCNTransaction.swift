//
//  SCNTransaction.swift
//  AspirinKit
//
//  Copyright © 2015-2017 The Web Electric Corp. All rights reserved.
//
//

import Foundation
import SceneKit
import CoreGraphics

public extension SCNTransaction {

    
    public class func runBlockInTransaction(duration aDuration:TimeInterval? = nil, delay aDelay:TimeInterval = 0, timingFunctionName:String? = nil, completion completionBlock: NoParamBlock? = nil, scnBlock: @escaping NoParamBlock) {
        Thread.dispatchAsyncOnMainQueue(afterDelay: aDelay) {
            SCNTransaction.begin()
            
            if let duration = aDuration {
                SCNTransaction.animationDuration = duration
            }
            
            if let completion = completionBlock {
                SCNTransaction.completionBlock = completion
            }
            
            //watchOS does not include QuartzCore which includes CAMediaTimingFunction
            #if !os(watchOS)
            if let tfName = timingFunctionName {
                SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: tfName)
            }
            #endif

            scnBlock()
            
            SCNTransaction.commit()
        }
    }
}
