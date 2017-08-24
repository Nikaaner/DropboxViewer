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
    
    var list: FolderList?
    var path = ""
    
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let title = NSString(string: path).lastPathComponent
        navigationItem.title = title.isEmpty ? NSLocalizedString("My Dropbox", comment: "Main screen title") : title
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
        if let mainViewController = segue.destination as? MainViewController, let selectedRow = tableView.indexPathForSelectedRow?.row, let selectedItem = list?.items?[selectedRow], let path = selectedItem.fullPath {
            mainViewController.path = path
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
        let item = list?.items?[indexPath.row]
        let cellIdentifier = item?.type == .folder ? CellIdentifier.folderCell : CellIdentifier.fileCell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = item?.name
        
        if let date = item?.modificationDate {
            cell.detailTextLabel?.text = dateFormatter.string(from: date)
        }
        
        return cell
    }
    
}
