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

public typealias NXNoParamBlock = () -> Void

public class Weak<T: AnyObject> {
    public weak var value : T?
    public init (value: T) {
        self.value = value
    }
}

public func randomSign() -> Float {
    return (arc4random() % 2 == 0) ? 1 : -1
}

public func randomFloat(baseValue base:Float, maxVariance variance:Float) -> Float {
    return base + variance * (Float(arc4random()) / Float(UINT32_MAX))
}

public class ClosureHolder  {
    public var block:NXNoParamBlock
    
    public init(block: @escaping NXNoParamBlock) {
        self.block = block
    }
}

public extension Array {
    func randomElement() -> Element {
        let randomIndex = Int(arc4random_uniform(UInt32(self.count)))
        return self[randomIndex]
    }
}

//see http://stackoverflow.com/questions/24034544/dispatch-after-gcd-in-swift
/**
 Use: delay(0.4) {
 // do stuff
 }
 */
public func delay(_ delay:Double, closure:@escaping NXNoParamBlock) {
    
    let dispatchTime = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    
    DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: closure)
    
}

///J58 synchronized - used objc_sync_enter and objc_sync_exit
public func synchronized<T>(_ lock: AnyObject, block: () -> T) -> T {
    var result: Any? = nil
    objc_sync_enter(lock)
    defer {
        objc_sync_exit(lock)
    }
    
    result = block()
    
    return result as! T
}

///J58 synchronized - used objc_sync_enter and objc_sync_exit, update for swift 2.0 uses defer to handle proper unlock even with errors
public func synchronized(_ lock:AnyObject, block:() -> Void ) {
    
    objc_sync_enter(lock)
    
    defer {
        objc_sync_exit(lock)
    }
    
    block()
}

public extension Thread {
    
    public class func printCallStackSymbols() {
        dump(Thread.callStackSymbols, name: "[\(Date())]: Call Stack Symbols")
    }
    
    //necessary to run synchronously on the main queue, but checking if not already in the main queue, to avoid deadlocks
    class func dispatchSyncOnMainQueue(_ block: NXNoParamBlock) {
        /*
         Do not use this
         if (dispatch_get_current_queue() == dispatch_get_main_queue()) {
         since Apple says
         "The result of dispatch_get_main_queue() may or may not equal the result of dispatch_get_current_queue()
         when called on the main thread. Comparing the two is not a valid way to test whether code is executing
         on the main thread. Foundation/AppKit programs should use [NSThread isMainThread]. POSIX programs may
         use pthread_main_np(3)."
         as described here https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man3/dispatch_get_current_queue.3.html
         */
        
        if Thread.isMainThread {
            block()
        }
        else {
            DispatchQueue.main.sync(execute: block)
        }
    }
    
    ///utility function that dispatches an optional block on current thread if not nil
    class func dispatchAsyncInBackground(_ possibleBlock:NXNoParamBlock?) {
        if let block = possibleBlock {
            DispatchQueue.global(qos: .background).async(execute: block)
        }
    }
    
    class func dispatchAsyncOnMainQueue(_ possibleBlock:NXNoParamBlock?) {
        if let block = possibleBlock {
            DispatchQueue.main.async(execute: block)
        }
    }
    
    class func dispatchAsyncOnBackgroundQueue(_ block:@escaping NXNoParamBlock) {
        DispatchQueue.global(qos: .background).async(execute: block)
    }
    
    class func dispatchAsyncOnHighPriorityQueue(_ block:@escaping NXNoParamBlock, afterDelay delay:TimeInterval) {
        let dispatchTime = DispatchTime.now() + Double(Int64(UInt64(delay) * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: dispatchTime, execute: block)
    }
    
    class func dispatchAsyncOnMainQueue(afterDelay delay:TimeInterval, block possibleBlock:NXNoParamBlock?) {
        if let block = possibleBlock {
            if delay == 0 {
                DispatchQueue.main.async(execute: block)
            }
            else {
                let dispatchTime = DispatchTime.now() + Double(Int64(UInt64(delay) * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: block)
            }
        }
    }
    
}

