//
//  Copyright © 2015-2017 The Web Electric Corp. All rights reserved.
//

import Foundation

public class Measurement : CustomStringConvertible {
    public let name:String
    //TODO consider using         var startTime = CFAbsoluteTimeGetCurrent() instead of NSDate.timeIntervalSinceReferenceDate
    private(set) public var startTime:TimeInterval = 0
    private(set) public var endTime:TimeInterval = 0
    public var elapsedTime:TimeInterval { return endTime-startTime }
    public var timePerRun:TimeInterval { return self.elapsedTime / TimeInterval(self.runCount) }
    private(set) public var runCount:Int = 1
    
    public init(named name: String) {
        self.name = name
        self.startTime = MachSystemClock.absoluteTime
    }
    
    public func done(runCount count: Int = 1) {
        self.endTime = MachSystemClock.absoluteTime
        self.runCount = count
    }
    
    public var description:String {
        
        return "[\(name) time elapsed = \(self.elapsedTime) / # of runs = \(self.runCount) / time per run = \(self.timePerRun)"
    }
}

public class Benchmarks {
    static var measurements:[String:Measurement] = [String:Measurement]()
    
    public class func measureTimeForBlock(_ block: (()->())) -> TimeInterval {
        let startTime = MachSystemClock.absoluteTime
        Thread.dispatchSyncOnMainQueue(block)
        let endTime = MachSystemClock.absoluteTime
        return endTime - startTime
    }
    
    public class func clearMeasurements(named name: String) {
        Benchmarks.measurements.removeValue(forKey: name)
    }
    
    public class func beginMeasurement(named name: String) {
        let measure = Measurement(named: name)
        Benchmarks.measurements[name] = measure
    }
    
    public class func endMeasurement(named name: String, runCount count: Int = 1) -> Measurement? {
        if let measure = Benchmarks.measurements[name] {
            measure.done(runCount: count)
            return measure
        }
        return nil
    }
    
    public class func getMeasurement(named name:String) -> Measurement? {
        return measurements[name]
    }
}
