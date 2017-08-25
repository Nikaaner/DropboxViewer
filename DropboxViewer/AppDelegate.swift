//
//  AppDelegate.swift
//  DropboxViewer
//
//  Created by Andriy Herasymyuk on 23.08.17.
//  Copyright © 2017 AndriyHerasymyuk. All rights reserved.
//

import UIKit
import SwiftyDropbox

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    private enum Defaults {
        static let dropboxAppKey = "v0p5dzdk0t8nkfc"
    }
    
    // MARK: - Properties
    
    static let shared: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var window: UIWindow?
    
    // MARK: - Lifecycle
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        DropboxClientsManager.setupWithAppKey(Defaults.dropboxAppKey)
        logInIfNeeded()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        handleAuthResult(url)
        return true
    }
}

// MARK: - Public

extension AppDelegate {
    
    func showStartScreen(animated: Bool = true) {
        let viewController = UIStoryboard(.Auth).instantiateInitialViewController()!
        setRootViewController(viewController, animated: animated, options: .transitionFlipFromLeft)
    }
    
    func showMainScreen(animated: Bool = true) {
        let viewController = UIStoryboard(.Main).instantiateInitialViewController()!
        setRootViewController(viewController, animated: animated, options: .transitionFlipFromRight)
    }
    
}

// MARK: - Private

private extension AppDelegate {
    
    func logInIfNeeded() {
        guard DropboxClientsManager.authorizedClient == nil else { return }
        showStartScreen()
    }
    
    func setRootViewController(_ viewController: UIViewController, animated: Bool, options: UIViewAnimationOptions = []) {
        if animated {
            window?.rootViewController?.transitionTo(viewController: viewController, options: options, completion: { (bool) in
                self.window?.rootViewController = viewController
            })
        } else {
            window?.rootViewController = viewController
        }
    }
    
    func handleAuthResult(_ url: URL) {
        if let authResult = DropboxClientsManager.handleRedirectURL(url) {
            switch authResult {
            case .success:
                print("Success! User is logged into Dropbox.")
            case .cancel:
                print("Authorization flow was manually canceled by user!")
            case .error(_, let description):
                print("Error: \(description)")
            }
        }
        
    }
    
}
