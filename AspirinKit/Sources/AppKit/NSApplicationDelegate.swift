//
//  NSApplicationDelegate.swift
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
import AppKit

extension NSApplicationDelegate {
    
    
    public func showAlert(window: NSWindow,
                   title:String, message:String,
                   buttons:[(title:String, type:CommonAlertButtonType)] = [("Ok", .ok)],
                   type alertType:CommonAlertType = .sheet,
                   style alertStyle:CommonAlertStyle = .informational,
                   completionHandler:(((title:String, type:CommonAlertButtonType)) -> Void)? = nil) {
        
        let alert = NSAlert()
        
        alert.messageText = title
        alert.informativeText = message

        let buttonSequence:[Int] = [NSAlertFirstButtonReturn, NSAlertSecondButtonReturn, NSAlertThirdButtonReturn]
        var buttonMap:[Int:(title:String, type:CommonAlertButtonType)] = [Int:(title:String, type:CommonAlertButtonType)]()
        //on macOS we ignore the button type for now
        for i in 0..<buttons.count {
            let button = buttons[i]
            buttonMap[buttonSequence[i]] = button
            alert.addButton(withTitle: button.title)
        }
        
        var aStyle:NSAlertStyle = .informational
        
        switch alertStyle {
            case .informational:
                aStyle = .informational
            case .warning:
                aStyle = .warning
            case .critical:
                aStyle = .critical
        }

        alert.alertStyle = aStyle
        
        
        Thread.dispatchAsyncOnMainQueue { () -> Void in
            if alertType == .sheet {
                alert.beginSheetModal(for: window, completionHandler: { (modalResponse) in
                    if let completion = completionHandler {
                        let button = buttonMap[modalResponse] ?? buttons[0]
                        completion(button)
                    }
                })
            }
            else if alertType == .alert {
                let modalResponse = alert.runModal()
                let button = buttonMap[modalResponse] ?? buttons[0]
                if let completion = completionHandler {
                    completion(button)
                }
            }
        }
    }

}
