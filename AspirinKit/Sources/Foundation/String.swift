//
//  String.swift
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

public extension String {
    
    var length:Int { return self.characters.count }
    
    var NSStr:NSString { return (self as NSString) }
    
    var float:Float? {
        return Float(self)
    }

    var double:Double? {
        return Double(self)
    }
    
    var int:Int? {
        return Int(self)
    }
    
    var fourCharCode:FourCharCode {
        assert(self.characters.count == 4, "String length must be 4")
        var result : FourCharCode = 0
        for char in self.utf16 {
            result = (result << 8) + FourCharCode(char)
        }
        return result
    }

    static func createUUID() -> String {
        return UUID().uuidString
    }
    
    public init(base64Value: String) {
        let data = Data(base64Encoded: base64Value, options: Data.Base64DecodingOptions(rawValue: 0))
        self = String(data: data!, encoding: String.Encoding.utf8)!
    }
    
    var base64Value: String {
        let data = self.data(using: String.Encoding.utf8)
        return data!.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
    }
    
    public func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    ///a String qualifies as 'blank' if it's either nil or only made up of spaces
    public static func isBlank(_ val:String!) -> Bool {
        if val == nil {
            return true
        }
        
        return val.trim().isEmpty
    }

    mutating public func removed(prefix: String) {
        
        let prefixStartIndex = self.index(self.startIndex, offsetBy: prefix.characters.count)
        let range = self.startIndex..<prefixStartIndex
        self.removeSubrange(range)
    }
    
    public func removing(prefix: String) -> String {
        if !self.hasPrefix(prefix) {
            return self
        }
        let prefixStartIndex = self.characters.index(self.startIndex, offsetBy: prefix.characters.count)
        return self.substring(from: prefixStartIndex)
    }
    
    public func removing(suffix: String) -> String {
        let position = self.position(of: suffix)
        if position == -1 {
            return self
        }
        let toIdx = self.index(self.startIndex, offsetBy: position)
        
        
        return self.substring(to: toIdx)
    }
    
    public func substring(from startIndex: Int, length: Int) -> String
    {
        let start = self.characters.index(self.startIndex, offsetBy: startIndex)
        let end = self.characters.index(self.startIndex, offsetBy: startIndex + length)
        return self.substring(with: start ..< end)
    }
    
    public func position(of substring: String) -> Int
    {
        if let range = self.range(of: substring) {
            return self.characters.distance(from: self.startIndex, to: range.lowerBound)
        }
        else {
            return -1
        }
    }
    
    public func position(of substring: String, from startIndex: Int) -> Int {
        let startRange = self.characters.index(self.startIndex, offsetBy: startIndex)
        
        let range = self.range(of: substring, options: NSString.CompareOptions.literal, range: Range<String.Index>(startRange ..< self.endIndex))
        
        if let rangeResult = range {
            return self.characters.distance(from: self.startIndex, to: rangeResult.lowerBound)
        } else {
            return -1
        }
    }
    
    public func lastPosition(of substring: String) -> Int
    {
        var index = -1
        var stepIndex = self.position(of: substring)
        
        while stepIndex > -1 {
            index = stepIndex
            
            if (stepIndex + substring.length) < self.length {
                stepIndex = self.position(of: substring, from: (stepIndex + substring.length))
            }
            else {
                stepIndex = -1
            }
        }
        
        return index
    }
    
    
    public subscript(i: Int) -> Character  {
        get {
            let index = characters.index(startIndex, offsetBy: i)
            return self[index]
        }
    }
    
    fileprivate var vowels: [String]  {
        return ["a", "e", "i", "o", "u"]
    }
    
    fileprivate var consonants: [String] {
        return ["b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p", "q", "r", "s", "t", "v", "w", "x", "z"]
    }
    
    public func pluralized(by count: Int, with locale: Locale = Locale(identifier: "en_US")) -> String
    {
        let localeLanguage = locale.languageCode ?? "en"
        if localeLanguage != "en" {
            print("Error plularizing, only languageCode = 'en' is supported at this time, returning unmodified string.")
            return self
        }
        if count == 1 {
            return self
        }
        else {
            let len = self.length
            let lastChar = self.substring(from: len - 1, length: 1)
            let secondToLastChar = self.substring(from: len - 2, length: 1)
            var prefix = "", suffix = ""
            
            if lastChar.lowercased() == "y" && vowels.filter({x in x == secondToLastChar}).count == 0 {
                let toIdx = self.index(self.startIndex, offsetBy: (len - 1))
                prefix = self.substring(to: toIdx)// self[0..<(self.length - 1)]
                suffix = "ies"
            }
            else if lastChar.lowercased() == "s" || (lastChar.lowercased() == "o" && consonants.filter({x in x == secondToLastChar}).count > 0) {
                let toIdx = self.index(self.startIndex, offsetBy: (len))
                prefix = self.substring(to: toIdx)// self[0..<(self.length - 1)]
                //                prefix = self[0..<self.length]
                suffix = "es"
            }
            else {
                let toIdx = self.index(self.startIndex, offsetBy: (len))
                prefix = self.substring(to: toIdx)// self[0..<(self.length - 1)]
                //                prefix = self[0..<self.length]
                suffix = "s"
            }
            
            return prefix + (lastChar != lastChar.uppercased() ? suffix : suffix.uppercased())
        }
    }

}
