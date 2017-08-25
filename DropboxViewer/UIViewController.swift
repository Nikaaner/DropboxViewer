//
//  UIViewController.swift
//  DropboxViewer
//
//  Created by Andriy Herasymyuk on 24.08.17.
//  Copyright © 2017 AndriyHerasymyuk. All rights reserved.
//

import UIKit

extension UIViewController {
    
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
    
}
