//
//  ImageViewController.swift
//  DropboxViewer
//
//  Created by Andriy Herasymyuk on 25.08.17.
//  Copyright © 2017 AndriyHerasymyuk. All rights reserved.
//

import UIKit

final class ImageViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet fileprivate var scrollView: UIScrollView!
    @IBOutlet fileprivate var imageView: UIImageView!
    @IBOutlet fileprivate var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate var imageViewTrailingConstraint: NSLayoutConstraint!
    
    var fileURL: URL?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let fileURL = fileURL, let data = try? Data(contentsOf: fileURL) {
            imageView.image = UIImage(data: data)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.layoutIfNeeded()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateMinZoomScale(for: view.bounds.size)
    }

}

// MARK: - PreviewContentController

extension ImageViewController: PreviewContentController {
    
    func refresh() {
        guard let fileURL = fileURL, let data = try? Data(contentsOf: fileURL) else { return }
        imageView.image = UIImage(data: data)
        view.layoutIfNeeded()
        scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
    }
    
}

// MARK: - Private

private extension ImageViewController {
    
    func updateMinZoomScale(for size: CGSize) {
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
    }
    
    func updateConstraints(for size: CGSize) {
        let yOffset = max(0, (size.height - imageView.frame.height) / 2)
        imageViewTopConstraint.constant = yOffset
        imageViewBottomConstraint.constant = yOffset
        
        let xOffset = max(0, (size.width - imageView.frame.width) / 2)
        imageViewLeadingConstraint.constant = xOffset
        imageViewTrailingConstraint.constant = xOffset
        
        view.layoutIfNeeded()
    }
    
}

// MARK: - UIScrollViewDelegate

extension ImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraints(for: view.bounds.size)
    }
    
}
