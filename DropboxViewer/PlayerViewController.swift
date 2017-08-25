//
//  PlayerViewController.swift
//  DropboxViewer
//
//  Created by Andriy Herasymyuk on 25.08.17.
//  Copyright © 2017 AndriyHerasymyuk. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

final class PlayerViewController: UIViewController {

    // MARK: - Properties
        
    var fileURL: URL?
    
    fileprivate weak var avPlayerViewController: AVPlayerViewController?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let fileURL = fileURL {
            setUpPlayer(with: fileURL)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        avPlayerViewController?.player?.pause()
    }
    
}

// MARK: - PreviewContentController

extension PlayerViewController: PreviewContentController {
    
    func refresh() {
        guard let fileURL = fileURL else { return }
        avPlayerViewController?.player?.pause()
        avPlayerViewController?.player = AVPlayer(url: fileURL)
    }
    
}

// MARK: - Private

private extension PlayerViewController {
    
    func setUpPlayer(with fileURL: URL) {
        let avPlayerViewController = AVPlayerViewController()
        avPlayerViewController.player = AVPlayer(url: fileURL)
        setEmbed(viewController: avPlayerViewController, in: view)
        self.avPlayerViewController = avPlayerViewController
    }
    
}
