//
//  FolderItem.swift
//  DropboxViewer
//
//  Created by Andriy Herasymyuk on 23.08.17.
//  Copyright © 2017 AndriyHerasymyuk. All rights reserved.
//

import Foundation
import ObjectMapper

final class FolderItem: Mappable {
    
    // MARK: - Properties
    
    var identifier: String?
    var type: Type?
    var name: String?
    var modificationDate: Date?
    var fullPath: String?
    
    // MARK: - Mappable
    
    init?(map: Map) {}
    
    func mapping(map: Map) {
        identifier <- map["id"]
        name <- map["name"]
        modificationDate <- (map["server_modified"], ISO8601DateTransform())
        fullPath <- map["path_display"]
        type <- (map[".tag", nested: false], EnumTransform<Type>())
        
        if type == nil, let name = name {
            type = Type.by(name)
        }
    }
    
}

// MARK: - Type

extension FolderItem {
    
    enum `Type`: String {
        case folder = "folder"
        case image, text, audio
        
        static func by(_ name: String) -> Type? {
            let fileExtension = NSString(string: name).pathExtension
            
            switch fileExtension {
            case _ where ImageType(rawValue: fileExtension) != nil:
                return .image
                
            default: return nil
            }
        }
        
        private enum ImageType: String {
            case jpg, jpeg, png, tiff, tif, gif, bmp
        }
        
    }
    
}
