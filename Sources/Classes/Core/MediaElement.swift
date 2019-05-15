//
//  MediaElement.swift
//  MediaWatermark
//
//  Created by Sergei on 03/05/2017.
//  Copyright © 2017 rubygarage. All rights reserved.
//

import UIKit

@objc public enum MediaElementType : Int {
    case image
    case view
    case text
}

@objc public class MediaElement : NSObject {
    @objc public var frame: CGRect = .zero
    @objc public var type: MediaElementType = .image
    
    public private(set) var contentImage: UIImage! = nil
    public private(set) var contentView: UIView! = nil
    public private(set) var contentText: NSAttributedString! = nil
    
    @objc public init(image: UIImage) {
        super.init()
        contentImage = image
        type = .image
    }
    
    @objc public init(view: UIView) {
        super.init()
        contentView = view
        type = .view
    }
    
    @objc public init(text: NSAttributedString) {
        super.init()
        contentText = text
        type = .text
    }
}
