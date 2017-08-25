//
//  AutorefReshable.swift
//  DropboxViewer
//
//  Created by Andriy Herasymyuk on 25.08.17.
//  Copyright © 2017 AndriyHerasymyuk. All rights reserved.
//

import UIKit
import Reachability

protocol AutoRefreshable: class {    
    func refresh()
}

extension AutoRefreshable {
    
    var reachability: Reachability? {
        return AppDelegate.shared.reachability
    }
    
    func reachabilityChanged(_ notification: Notification) {
        if let viewController = self as? UIViewController {
            if viewController.isVisible {
                refresh()
            }
        } else {
            refresh()
        }
    }
    
}
