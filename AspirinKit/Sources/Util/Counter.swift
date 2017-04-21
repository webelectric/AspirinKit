//
//  Counter.swift
//  AspirinKit
//
//  Copyright © 2015-2017 The Web Electric Corp. All rights reserved.
//
//

import Foundation


public class Global {
    public static let intCounter:Counter<Int> = Counter<Int>(start: 0, increment: 1)
    public static let floatCounter:Counter<Int> = Counter<Int>(start: 0, increment: 1)
}

public class Counter<ValueType: Strideable> {
    private var queue:DispatchQueue
    private var currentValue:ValueType
    private var increment:ValueType.Stride
    
    
    public init(start:ValueType, increment:ValueType.Stride) {
        self.currentValue = start
        self.increment = increment
        self.queue = DispatchQueue(label: "com.webelectric.Counter-\(type(of: start))")
    }
    
    public var current:ValueType {
        return self.currentValue
    }
    
    public var next:ValueType {
        get {
            return queue.sync {
                self.currentValue = self.currentValue.advanced(by: increment)
                return self.currentValue
            }
        }
    }
}
