//
//  FolderList.swift
//  DropboxViewer
//
//  Created by Andriy Herasymyuk on 23.08.17.
//  Copyright © 2017 AndriyHerasymyuk. All rights reserved.
//

import ObjectMapper
import SwiftyDropbox

final class FolderList: Mappable {
    
    typealias FolderListCompletion = (_ folderList: FolderList?, _ error: CallError<Files.ListFolderError>?) -> Void
    
    // MARK: - Properties
    
    var cursor: String?
    var items: [FolderItem]?
    var hasMore: Bool?
    
    // MARK: - Mappable
    
    init?(map: Map) {}
    
    func mapping(map: Map) {
        cursor <- map["cursor"]
        items <- map["entries"]
        hasMore <- map["has_more"]
    }
    
}

// MARK: - Public

extension FolderList {
    
    class func get(at path: String, completion: FolderListCompletion?) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        DropboxClientsManager.authorizedClient?.files.listFolder(path: path).response(completionHandler: { (result, error) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            var folderList: FolderList?
            if let result = result {
                let json = Files.ListFolderResultSerializer().serialize(result)
                let object = SerializeUtil.prepareJSONForSerialization(json)
                folderList = Mapper<FolderList>().map(JSONObject: object)
            }
            completion?(folderList, error)
        })
    }
    
}
