//
//  StartViewController.swift
//  DropboxViewer
//
//  Created by Andriy Herasymyuk on 23.08.17.
//  Copyright © 2017 AndriyHerasymyuk. All rights reserved.
//

import UIKit
import SwiftyDropbox

class StartViewController: UIViewController {
    
    // MARK: - Actions
    
    @IBAction func signInAction(_ sender: Any) {
        DropboxClientsManager.authorizeFromController(UIApplication.shared, controller: self) { (url) in
            UIApplication.shared.openURL(url)
        }
    }
    
}
