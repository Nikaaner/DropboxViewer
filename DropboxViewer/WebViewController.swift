//
//  WebViewController.swift
//  DropboxViewer
//
//  Created by Andriy Herasymyuk on 24.08.17.
//  Copyright © 2017 AndriyHerasymyuk. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    // MARK: - Properties

    @IBOutlet fileprivate var webView: UIWebView!
    
    var fileURL: URL?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let fileURL = fileURL {
            webView.loadRequest(URLRequest(url: fileURL))
        }
    }

}

// MARK: - PreviewContentController

extension WebViewController: PreviewContentController {
    
    func refresh() {
        webView.reload()
    }
    
}

// MARK: - UIWebViewDelegate

extension WebViewController: UIWebViewDelegate {
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let allow = request.url?.scheme == "file"
        if !allow, let url = request.url, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        }
        return allow
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print(error)
        let message = NSLocalizedString("File format is not supported", comment: "")
        showAlert(with: message)
    }
    
}
