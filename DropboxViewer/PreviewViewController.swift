//
//  PreviewViewController.swift
//  DropboxViewer
//
//  Created by Andriy Herasymyuk on 24.08.17.
//  Copyright © 2017 AndriyHerasymyuk. All rights reserved.
//

import UIKit
import MessageUI

protocol PreviewContentController: class {

    var fileURL: URL? { get set }
    
    func refresh()
    
}

final class PreviewViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet fileprivate var navItem: UINavigationItem!
    @IBOutlet fileprivate var containerView: UIView!
    
    var item: FolderItem?
    
    fileprivate weak var previewContentController: PreviewContentController?
    
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
        guard let item = item else { return }
        sendByEmail(item)
    }
    
}

// MARK: - Private

private extension PreviewViewController {
    
    func loadContent() {
        item?.getFile(completion: { [weak self] (url, error) in
            if let url = url, let strongSelf = self {
                var contentController: UIViewController?
                switch strongSelf.item?.type {
                case .audio?, .video?:
                    contentController = PlayerViewController()
                default:
                    contentController = UIStoryboard(.Main).instantiateViewController() as WebViewController
                }
                strongSelf.previewContentController = (contentController as! PreviewContentController)
                strongSelf.previewContentController?.fileURL = url
                strongSelf.setEmbed(viewController: contentController!, in: strongSelf.containerView)
            }
        })
    }
    
    func sendByEmail(_ item: FolderItem) {
        guard MFMailComposeViewController.canSendMail() else {
            let message = NSLocalizedString("Mail services are not available", comment: "")
            showAlert(with: message)
            return
        }
        
        guard let fileURL = previewContentController?.fileURL, let data = try? Data(contentsOf: fileURL) else { return }
        
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        var fileName = NSLocalizedString("File", comment: "")
        
        if let fullPath = item.fullPath {
            fileName = NSString(string: fullPath).lastPathComponent
        }
        
        mailComposer.addAttachmentData(data, mimeType: item.mimeType, fileName: fileName )
        present(mailComposer, animated: true, completion: nil)
    }
    
}

// MARK: - MFMailComposeViewControllerDelegate

extension PreviewViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
