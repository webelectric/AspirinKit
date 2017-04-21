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
        
    }
    
  
}
