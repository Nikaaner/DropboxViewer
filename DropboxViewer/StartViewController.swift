//
//  StartViewController.swift
//  DropboxViewer
//
//  Created by Andriy Herasymyuk on 23.08.17.
//  Copyright © 2017 AndriyHerasymyuk. All rights reserved.
//

import UIKit
import SwiftyDropbox

final class StartViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if DropboxClientsManager.authorizedClient != nil {
            AppDelegate.shared.showMainScreen()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func signInAction(_ sender: Any) {
        DropboxClientsManager.authorizeFromController(UIApplication.shared, controller: self) { (url) in
            UIApplication.shared.openURL(url)
        }
    }
    
}
