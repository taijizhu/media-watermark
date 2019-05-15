//
//  MediaItem.swift
//  MediaWatermark
//
//  Created by Sergei on 03/05/2017.
//  Copyright © 2017 rubygarage. All rights reserved.
//

import UIKit
import AVFoundation

@objc enum MediaItemType : Int {
    case image
    case video
}

@objc public class MediaProcessResult : NSObject {
    @objc public var processedUrl: URL?
    @objc public var image: UIImage?
    init(processedUrl: URL?, image: UIImage?) {
        super.init()
        self.processedUrl = processedUrl
        self.image = image
    }
}

public typealias ProcessCompletionHandler = ((_ result: MediaProcessResult, _ error: Error?) -> ())

@objc public class MediaItem : NSObject {
    @objc var type: MediaItemType {
        return sourceAsset != nil ? .video : .image
    }
    
    @objc public var size: CGSize {
        get {
            if sourceAsset != nil {
                if let track = AVAsset(url: sourceAsset.url).tracks(withMediaType: AVMediaType.video).first {
                    let size = track.naturalSize.applying(track.preferredTransform)
                    return CGSize(width: fabs(size.width), height: fabs(size.height))
                } else {
                    return CGSize.zero
                }
            } else if sourceImage != nil {
                return sourceImage.size
            }
            
            return CGSize.zero
        }
    }
    
    public private(set) var sourceAsset: AVURLAsset! = nil
    public private(set) var sourceImage: UIImage! = nil
    public private(set) var mediaElements = [MediaElement]()
    public private(set) var filter: MediaFilter! = nil

    // MARK: - init
    @objc public init(asset: AVURLAsset) {
        super.init()
        sourceAsset = asset
    }
    
    @objc public init(image: UIImage) {
        super.init()
        sourceImage = image
    }
    
    @objc public init?(url: URL) {
        super.init()
        if urlHasImageExtension(url: url) {
            do {
                let data = try Data(contentsOf: url)
                sourceImage = UIImage(data: data)
            } catch {
                return nil
            }
        } else {
            sourceAsset = AVURLAsset(url: url)
        }
    }
    
    // MARK: - elements
    @objc public func add(element: MediaElement) {
        mediaElements.append(element)
    }
    
    @objc public func add(elements: [MediaElement]) {
        mediaElements.append(contentsOf: elements)
    }
    
    @objc public func removeAllElements() {
        mediaElements.removeAll()
    }
    
    // MARK: - filters
    @objc public func applyFilter(mediaFilter: MediaFilter) {
        filter = mediaFilter
    }
    
    // MARK: - private
    private func urlHasImageExtension(url: URL) -> Bool {
        let imageExtensions = ["png", "jpg", "gif"]
        return imageExtensions.contains(url.pathExtension)
    }
}
