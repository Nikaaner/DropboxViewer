//
//  MainViewController.swift
//  DropboxViewer
//
//  Created by Andriy Herasymyuk on 23.08.17.
//  Copyright © 2017 AndriyHerasymyuk. All rights reserved.
//

import UIKit
import SwiftyDropbox

class MainViewController: UITableViewController {
    
    // MARK: - Properties
    
    var path = ""

    fileprivate var list: FolderList?
    fileprivate var logOutBarButtonItem: UIBarButtonItem?
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        FolderList.get(at: path) { [weak self] (folderList, error) in
            self?.list = folderList
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedRow = tableView.indexPathForSelectedRow?.row, let selectedItem = list?.items?[selectedRow] else { return }
        
        if let mainViewController = segue.destination as? MainViewController, let path = selectedItem.fullPath {
            mainViewController.path = path
            
        } else if let previewViewController = segue.destination as? PreviewViewController {
            previewViewController.item = selectedItem
        }
    }
    
    // MARK: - Actions
    
    func logOutAction(_ sender: Any) {
        DropboxClientsManager.unlinkClients()
        AppDelegate.shared.showStartScreen()
    }
    
}

// MARK: - Private

private extension MainViewController {
    
    func setUpNavigationItem() {
        let title = NSString(string: path).lastPathComponent
        if !title.isEmpty {
            navigationItem.title = title
        }
        
        if navigationController?.viewControllers.count == 1 {
            let logOutTitle = NSLocalizedString("Log out", comment: "")
            let logOutBarButtonItem = UIBarButtonItem(title: logOutTitle, style: .plain, target: self, action: #selector(logOutAction))
            navigationItem.setLeftBarButton(logOutBarButtonItem, animated: false)
        }
    }
    
}

// MARK: - UITableViewDataSource

extension MainViewController {
    
    private enum CellIdentifier {
        static let folderCell = "FolderCell"
        static let fileCell = "FileCell"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list?.items?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = list!.items![indexPath.row]
        let cellIdentifier = item.type == .folder ? CellIdentifier.folderCell : CellIdentifier.fileCell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.imageView?.image = image(for: item)
        cell.textLabel?.text = item.name
        
        if let date = item.modificationDate {
            cell.detailTextLabel?.text = dateFormatter.string(from: date)
        }
        
        return cell
    }
    
    private func image(for folderItem: FolderItem) -> UIImage {
        guard let type = folderItem.type else { return #imageLiteral(resourceName: "ic_file") }
        switch type {
        case .folder:
            return #imageLiteral(resourceName: "ic_folder")
        case .image:
            return #imageLiteral(resourceName: "ic_image")
        case .text:
            return #imageLiteral(resourceName: "ic_text")
        case .audio:
            return #imageLiteral(resourceName: "ic_audio")
        case .video:
            return #imageLiteral(resourceName: "ic_video")
        }
    }
    
}
