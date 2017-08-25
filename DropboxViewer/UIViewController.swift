//
//  UIViewController.swift
//  DropboxViewer
//
//  Created by Andriy Herasymyuk on 24.08.17.
//  Copyright © 2017 AndriyHerasymyuk. All rights reserved.
//

import UIKit
import Reachability

extension UIViewController {
    
    var isVisible: Bool {
        return isViewLoaded && view.window != nil
    }
    
    func showAlert(with message: String) {
        let title = NSLocalizedString("Sorry", comment: "")
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default))
        show(alert, sender: self)
    }
    
    func setEmbed(viewController: UIViewController, in containerView: UIView) {
        viewController.view.frame = containerView.bounds
        containerView.addSubview(viewController.view)
        addChildViewController(viewController)
        viewController.didMove(toParentViewController: self)
    }
    
    func transitionTo(viewController: UIViewController?, options: UIViewAnimationOptions = [], completion: ((Bool) -> Swift.Void)? = nil) {
        guard let viewController = viewController else { return }
        let areAnimationsEnabled = UIView.areAnimationsEnabled
        let view = presentedViewController?.view ?? self.view
        UIView.setAnimationsEnabled(false)
        UIView.transition(from: view!, to: viewController.view, duration: 0.3, options: options) { (bool) in
            UIView.setAnimationsEnabled(areAnimationsEnabled)
            completion!(bool)
        }
    }
    
}

// MARK: - Swizzling

extension UIViewController {
    
    @objc func swizzled_viewDidLoad() {
        self.swizzled_viewDidLoad()
        
        if let autoRefreshable = self as? AutoRefreshable {
            NotificationCenter.default.addObserver(forName: ReachabilityChangedNotification, object: autoRefreshable.reachability, queue: OperationQueue.main, using: { [weak autoRefreshable] (notification) in
                autoRefreshable?.reachabilityChanged(notification)
            })
        }

    }
    
}
