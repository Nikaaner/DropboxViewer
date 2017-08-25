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
    
    typealias DownloadCompletion = (_ fileURL: URL?, _ error: CallError<(Files.DownloadError)>?) -> Void
    
    // MARK: - Properties
    
    var identifier: String?
    var type: Type?
    var name: String?
    var modificationDate: Date?
    var fullPath: String?
    
    lazy var mimeType: String = {
        let defaultMimeType = "application/octet-stream"
        
        guard let fullPath = self.fullPath else { return defaultMimeType }
        guard let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, NSString(string: fullPath).pathExtension as CFString, nil)?.takeRetainedValue() else { return defaultMimeType }
        guard let mimeType = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() as String? else { return defaultMimeType }
        
        return mimeType
    }()
    
    fileprivate lazy var fileDirectory: URL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    
    fileprivate var filePathComponent: String? {
        guard let fullPath = fullPath else { return nil }
        let fileName = NSString(string: fullPath).lastPathComponent
        return "\(fullPath.hashValue)-\(fileName)"
    }
    
    // MARK: - Mappable
    
    init?(map: Map) {}
    
    func mapping(map: Map) {
        identifier <- map["id"]
        name <- map["name"]
        modificationDate <- (map["client_modified"], ISO8601DateTransform())
        fullPath <- map["path_display"]
        type <- (map[".tag", nested: false], EnumTransform<Type>())
        
        if type == nil {
            type = Type(mimeType)
        }
    }
    
}

// MARK - Public

extension FolderItem {
    
    func getFile(completion: DownloadCompletion?) {
        guard let pathComponent = filePathComponent else {
            completion?(nil, nil)
            return
        }

        let destinationURL = fileDirectory.appendingPathComponent(pathComponent)
        let searchPath = "\(NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!)/\(pathComponent)"
        if FileManager.default.fileExists(atPath: searchPath) {
            completion?(destinationURL, nil)
            return
        }
        
        download(completion: completion)
    }
    
    func download(completion: DownloadCompletion?) {
        guard let pathComponent = filePathComponent else {
            completion?(nil, nil)
            return
        }

        let destination: (URL, HTTPURLResponse) -> URL = { temporaryURL, response in
            return self.fileDirectory.appendingPathComponent(pathComponent)
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        DropboxClientsManager.authorizedClient?.files.download(path: fullPath ?? "", overwrite: true, destination: destination).response(completionHandler: { (result, error) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            completion?(result?.1, error)
        })
    }
    
}

// MARK: - Type

extension FolderItem {
    
    enum `Type`: String {
        case folder, image, text, audio, video
        
        init?(_ mimeType: String) {
            let typeString = mimeType.components(separatedBy: "/").first!
            if let type = Type(rawValue: typeString) {
                self = type
            } else {
                return nil
            }
        }
        
    }
    
}
