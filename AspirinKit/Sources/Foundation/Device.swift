//
//  Device.swift
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

#if os(OSX)
    import AppKit
    import SystemConfiguration
#else
    import UIKit
    import MobileCoreServices
#endif

public class Device {
    
    public enum OSType {
        case mac
        case iOS
        case tvOS
        case unknown
        
        public init(autoset:Bool) {
            if autoset {
                #if os(OSX)
                    self = Device.OSType.mac
                #else
                    #if os(tvOS)
                        self = Device.OSType.tvOS
                    #else
                        #if os(iOS)
                            self = Device.OSType.iOS
                        #endif
                    #endif
                #endif
                
            }
            else {
                self = Device.OSType.unknown
            }
        }
    }
    
    public static let type:OSType = OSType(autoset: true)
    
    public static var systemName:String {
        #if os(OSX)
            return ProcessInfo.processInfo.operatingSystemVersionString
        #else
            return UIDevice.current.systemName
        #endif
        
    }
    
    public static var systemVersion:String {
        #if os(OSX)
            return "\(ProcessInfo.processInfo.operatingSystemVersion)"
        #else
            return UIDevice.current.systemVersion
        #endif
        
    }
    
    public static var name:String {
        #if os(OSX)
            return (SCDynamicStoreCopyComputerName(nil, nil) as String? ?? "unknown") as String
        #else
            return UIDevice.current.name
        #endif
        
        //        let x = TARGET_OS_SIMULATOR
    }
    
    public static var isSimulator:Bool {
        return TARGET_OS_SIMULATOR != 0
    }
    
    public static var screenScale:CGFloat {
        #if os(OSX)
            return NSScreen.main()?.backingScaleFactor ?? 1
        #else
            return UIScreen.main.scale
        #endif
        
        //        let x = TARGET_OS_SIMULATOR
    }
    
    ///a return value of 0 probably means an error ocurred
    public static var appMemoryUsageMBytes:UInt {
        return Device.appMemoryUsageBytes / (1024 * 1024)
    }
    
    public static var appMemoryUsageBytes:UInt {
        //TODO FIXME see below for code that must be upgraded to swift 3
        return 0
    }
    
    //TODO FIXME see below for code that must be upgraded to swift 3
    ///a return value of 0 probably means an error ocurred
    //    public static var appMemoryUsageBytes:UInt {
    //
    //        var info = task_basic_info()
    //        var count = mach_msg_type_number_t(sizeofValue(info))/4
    //
    //        let kerr: kern_return_t = withUnsafeMutablePointer(&info) {
    //
    //            task_info(mach_task_self_,
    //                      task_flavor_t(TASK_BASIC_INFO),
    //                      task_info_t($0),
    //                      &count)
    //
    //        }
    //
    //        var memSz:UInt = 0
    //        if kerr == KERN_SUCCESS {
    //            memSz = info.resident_size
    ////                println("Memory in use (in bytes): \(info.resident_size)")
    //        }
    //        else {
    //            print("NXDevice.appMemoryUsageBytes Error with task_info(): " +
    //                (String(cString: mach_error_string(kerr)) ?? "unknown error\n"))
    //        }
    //        return memSz
    //    
    //    }
}
