//
//  Video.swift
//  AspirinKit
//
//  Created by Diego Doval on 1/29/17.
//
//

import Foundation
import AVFoundation

public class Video {
    
    public let url:URL
    public var secondsForDefaultThumbnail:CFTimeInterval
    public var maxDefaultThumbnailSize:CGSize = CGSize(width: 256, height: 256)
    public var thumbnail:CGImage!
    
    public init(_ videoURL:URL, secondsForDefaultThumbnail sec:CFTimeInterval = 2) {
        url = videoURL
        secondsForDefaultThumbnail = sec
    }
    
    // TODO integrate function to generate multiple asynchronous thumbnails based on
    // generator.generateCGImagesAsynchronously(forTimes: [NSValue], completionHandler

    public func loadDefaultThumbnail() {
        let asset = AVAsset(url: self.url)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        generator.maximumSize = maxDefaultThumbnailSize
        let thumbnailTime = CMTime(seconds: Double(secondsForDefaultThumbnail),
                                   preferredTimescale: 30)
        var actualTime = kCMTimeZero
        
        do {
            thumbnail = try generator.copyCGImage(at: thumbnailTime, actualTime: &actualTime)
            
        }
        catch let error {
            print("Error generating thumbnail: \(error)")
        }
    }
    
    
   
}
