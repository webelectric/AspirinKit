//
//  FileManager.swift
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

enum FileError : Error {
    case URLNotFile(String)
}

extension FileManager {
    
    static let documentsFolder:URL = {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }()
    
    
    static var documentsFolderContents:[URL] {
        
        do {
            return try FileManager.default.contentsOfDirectory(at: FileManager.documentsFolder, includingPropertiesForKeys: nil, options: [])
        }
        catch let error {
            print(error)
        }
        
        return [URL]()
    }
    
    func fileModificationDate(url: URL) -> Date? {
        if !url.isFileURL {
            return nil
        }
        
        do {
            let attr = try FileManager.default.attributesOfItem(atPath: url.path)
            return attr[FileAttributeKey.modificationDate] as? Date
        }
        catch FileError.URLNotFile(let errorMessage) {
            print(errorMessage)
        }
        catch {
            return nil
        }
        return nil
    }

    func fileAttributes(url: URL) throws -> [FileAttributeKey : Any] {
        if !url.isFileURL {
            throw FileError.URLNotFile("url not a file: \(url)")
        }
        
        do {
            return try FileManager.default.attributesOfItem(atPath: url.path)
        }
        catch let error {
            throw error
        }
    }
    
    
    class func filenamesOf(_ fileURLs:[URL]) -> [String] {
        return fileURLs.map{ $0.deletingPathExtension().lastPathComponent }
    }
    
    class func documentsFolderContents(withExtension fileExtension:String) -> [URL] {
        
        return FileManager.documentsFolderContents.filter{ $0.pathExtension ==  fileExtension }
        
    }
    
    class func fileExists(at url:URL) -> Bool {
        
        return url.isFileURL && FileManager.default.fileExists(atPath: url.path)
    }
    
    class func deleteFileAt(_ url:URL) {
        do {
            return try FileManager.default.removeItem(at: url)
        }
        catch let error {
            print(error)
        }
        
    }
    
    class func createFileURLInDocuments(withExtension fileExtension:String) -> URL {
        return FileManager.documentsFolder.appendingPathComponent(UUID().uuidString).appendingPathExtension(fileExtension)
    }
    
    class func createTemporaryFileURL(withExtension fileExtension:String = "",
                                      prefix:String = "", suffix:String = "") -> URL {
        let fileName = "\(prefix)\(UUID().uuidString)\(suffix)"
        var fileURL:URL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        if !fileExtension.isEmpty {
            fileURL = fileURL.appendingPathComponent(fileExtension)
        }
        return fileURL
    }
    
}
