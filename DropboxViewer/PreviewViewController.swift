//
//  PreviewViewController.swift
//  DropboxViewer
//
//  Created by Andriy Herasymyuk on 24.08.17.
//  Copyright © 2017 AndriyHerasymyuk. All rights reserved.
//

import UIKit

protocol PreviewContentController: class {

    var fileURL: URL? { get set }
    
    func refresh()
    
}

final class PreviewViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet fileprivate var navItem: UINavigationItem!
    @IBOutlet fileprivate var containerView: UIView!
    
    var item: FolderItem?
    
    fileprivate let baseURL = Bundle.main.bundleURL
    fileprivate var previewContentController: PreviewContentController?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navItem.title = item?.name
        loadContent()
    }
    
    // MARK: - Actions

    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func refreshAction(_ sender: Any) {
        item?.download(completion: { [weak self] (url, error) in
            self?.previewContentController?.refresh()
        })
    }
    
    @IBAction func sendAction(_ sender: Any) {
    }
    
}

// MARK: - Private

private extension PreviewViewController {
    
    func loadContent() {
        item?.getFile(completion: { [weak self] (url, error) in
            if let url = url, let strongSelf = self {
                var contentController: UIViewController?
                switch strongSelf.item?.type {
                default:
                    contentController = UIStoryboard(.Main).instantiateViewController() as WebViewController
                }
                strongSelf.previewContentController = (contentController as! PreviewContentController)
                strongSelf.previewContentController?.fileURL = url
                strongSelf.setEmbed(viewController: contentController!)
            }
        })
    }
    
    func setEmbed(viewController: UIViewController) {
        viewController.willMove(toParentViewController: self)
        containerView.addSubview(viewController.view)
        addChildViewController(viewController)
        viewController.didMove(toParentViewController: self)
    }
    
}
