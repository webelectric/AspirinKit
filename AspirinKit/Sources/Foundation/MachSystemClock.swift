//
//  MachSystemClock.swift
//  AspirinKit
//
//  Copyright (c) 2014-2017 The Web Electric Corp. All rights reserved.
//
//

import Foundation

/**
 
 Example usage:
 
 let startTime = MachSystemClock.absoluteTime
 
 let endTime = MachSystemClock.absoluteTime
 
 let totalTime = endTime - startTime
 
 For internal measurements during runtime, this class is intended to replace things like NSDate.timeSinceReferenceDate, CFAbsoluteTimeGetCurrent(), etc. These are methods that are dependent on the system clock, which can change at any time for many reasons: NTP updating the clock (happens often to adjust for drift), DST adjustments, leap seconds, and so on.
 
 If you're measuring something that either takes a long time or is measured at intervals, using those methods can frequently result in sudden spikes or drops in your numbers that don't correlate with what actually happened; performance tests will have weird incorrect outliers; and your manual timers will trigger after incorrect durations. Time might even go backwards, and you end up with negative deltas, and you can end up with infinite recursion or dead code.
 
 mach_absolute_time measures real seconds since the kernel was booted. It is monotonically increasing, and is unaffected by date and time settings.
 */
public class MachSystemClock {
    public static let sharedInstance:MachSystemClock = MachSystemClock()
    private var _clock_timebase:mach_timebase_info
    
    private init() {
        self._clock_timebase = mach_timebase_info(numer: 0, denom: 0)
        mach_timebase_info(&self._clock_timebase)
    }
    
    public static func machAbsoluteTimeToTimeInterval(_ macAbsoluteTime:UInt64) -> TimeInterval {
        
        let nanoseconds:Double = (Double)((macAbsoluteTime * ((UInt64)(self.sharedInstance._clock_timebase.numer))) / ((UInt64)(self.sharedInstance._clock_timebase.denom)))
        
        return nanoseconds/1.0e9
        
    }
    
    ///Recommended main var (MacSystemClock.absoluteTime) - using instances, even the shared instance, should be reserved for tests and such
    public static var absoluteTime: TimeInterval {
        return MachSystemClock.machAbsoluteTimeToTimeInterval(mach_absolute_time())
    }
}
