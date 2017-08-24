//
//  FolderItem.swift
//  DropboxViewer
//
//  Created by Andriy Herasymyuk on 23.08.17.
//  Copyright © 2017 AndriyHerasymyuk. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftyDropbox
import MobileCoreServices

final class FolderItem: Mappable {
    
    typealias DownloadCompletion = (_ data: Data?, _ error: CallError<(Files.DownloadError)>?) -> Void
    
    // MARK: - Properties
    
    var identifier: String?
    var type: Type?
    var name: String?
    var modificationDate: Date?
    var fullPath: String?
    
    var mimeType: String {
        let defaultMimeType = "application/octet-stream"
        
        guard let fullPath = fullPath else { return defaultMimeType }
        guard let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, NSString(string: fullPath).pathExtension as CFString, nil)?.takeRetainedValue() else { return defaultMimeType }
        guard let mimeType = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() as String? else { return defaultMimeType }
        
        return mimeType
    }

    // MARK: - Mappable
    
    init?(map: Map) {}
    
    func mapping(map: Map) {
        identifier <- map["id"]
        name <- map["name"]
        modificationDate <- (map["client_modified"], ISO8601DateTransform())
        fullPath <- map["path_display"]
        type <- (map[".tag", nested: false], EnumTransform<Type>())
        
        if type == nil, let name = name {
            type = Type(name)
        }
    }
    
}

// MARK - Public

extension FolderItem {
    
    func download(completion: DownloadCompletion?) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        DropboxClientsManager.authorizedClient?.files.download(path: fullPath ?? "").response(completionHandler: { (result, error) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            completion?(result?.1, error)
        })
    }
    
}

// MARK: - Type

extension FolderItem {
    
    enum `Type`: String {
        case folder = "folder"
        case image, text, audio
        
        init?(_ name: String) {
            let fileExtension = NSString(string: name).pathExtension
            
            switch fileExtension {
            case _ where ImageType(rawValue: fileExtension) != nil:
                self = .image
                
            default: return nil
            }
        }
        
        private enum ImageType: String {
            case jpg, jpeg, png, tiff, tif, gif, bmp
        }
        
    }
    
}
