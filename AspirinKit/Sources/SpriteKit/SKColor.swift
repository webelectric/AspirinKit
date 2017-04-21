//
//  SKColor.swift
//  AspirinKit
//
//  Copyright © 2015 - 2017 The Web Electric Corp.
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
import SpriteKit
import CoreGraphics

public extension SKColor {
    
    
    public var rgba:(r:Float, g:Float, b:Float, a:Float) {
        
        var red:CGFloat = 0
        var green:CGFloat = 0
        var blue:CGFloat = 0
        var alpha:CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return (r: Float(red), g: Float(green), b: Float(blue), a: Float(alpha))
    }
    
    // A hex must be either 6 ("RRGGBB"), 7 ("#RRGGBB") or 8/9 characters ("#RRGGBBAA")
    public convenience init(hexString: String) {
        var hex = hexString.uppercased()
        let hexLength = hex.characters.count
        
        //remove # if present
        if hex.hasPrefix("#") {
            hex.removed(prefix: "#")
        }
        
        if hexLength == 3 || hexLength == 4 {
            //format is 'rgb' or 'rgba', duplicate chars to convert to valid
            hex = hex.characters.map( { "\($0)\($0)" } ).joined()
            
        }
        else if !(hexLength == 6 || hexLength == 8) {
            // A hex must be either 6 (#RRGGBB), 8 characters (#RRGGBBAA)
            print("improper call to create color from hex string, string length 6 ('RRGGBB'), 7 ('#RRGGBB') or 8/9 characters ('#RRGGBBAA')\n")
            self.init(white: 0, alpha: 1)
            return
        }
        

        var alpha:Float = 100
        
        var rgbOnlyHex = hex
        
        if hexLength == 8 {
            alpha = hex.substring(from: hex.index(hex.endIndex, offsetBy: -2)).float ?? 1
            rgbOnlyHex = hex.substring(to: hex.index(hex.startIndex, offsetBy: 5))
        }
        
        var rgb:UInt32 = 0
        let s:Scanner = Scanner(string: rgbOnlyHex)

        s.scanHexInt32(&rgb)
        
        let redValue = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let greenValue = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blueValue = CGFloat(rgb & 0x0000FF) / 255.0
        let alphaValue = CGFloat(alpha / 100)
        
        self.init(
            red: redValue,
            green: greenValue,
            blue: blueValue,
            alpha: alphaValue
        )
    }
    
    public var hexString: String?  {
      
        let rgba = self.rgba
            
        let hexString = String(format: "%02X%02X%02X%02X",  Int(rgba.r * 255.0), Int(rgba.g * 255.0), Int(rgba.b * 255.0), Int(rgba.a * 255.0))
      
        return hexString
    }
    
    
    public var inverse:SKColor? {
        let cgColor = self.cgColor
        let numberOfComponents = cgColor.numberOfComponents
        // can't invert - the only component is the alpha value
        if numberOfComponents == 1 {
            return self
        }
        let oldComponents = cgColor.components
        var newComponents:[CGFloat] = [CGFloat]()
        
        for i in 0...(numberOfComponents-2) {
            let oldValue:CGFloat = oldComponents![i]
            newComponents.append(1 - oldValue)
        }
        //alpha value shouldn't be inverted
        newComponents.append((oldComponents?[numberOfComponents-1])!)
        
        if let newCGColor = CGColor(colorSpace: cgColor.colorSpace!, components: &newComponents) {
            return SKColor(cgColor: newCGColor)
        }
        
        return nil
    }
    
    //see https://www.w3.org/WAI/ER/WD-AERT/#color-contrast
    ///range returned is 0-1 Float. Values of > 0.875 are probably not readable in a white background
    ///while a value of < 0.125 is probably not readable in a black background
    public var brightness: CGFloat {
        let rgba = self.rgba
        let rVal = CGFloat(rgba.r * 255 * 299)
        let gVal = CGFloat(rgba.g * 255 * 587)
        let bVal = CGFloat(rgba.b * 255 * 114)
        return (rVal + gVal + bVal) / CGFloat(255000);
    }
    
    public var isBright:Bool {
        return self.brightness >= 0.5
    }
    
    public var isDark:Bool {
        return !self.isBright
    }
    
    public func lighter() -> SKColor {
        let colorChangeDif:CGFloat = 0.1
        let components = self.cgColor.components
        if components != nil {
            return SKColor(red: min(components![0] + colorChangeDif, 1.0), green: min(components![1] + colorChangeDif, 1.0), blue: min(components![2] +     colorChangeDif, 1.0), alpha: components![3])
        }
        return self
    }
}
