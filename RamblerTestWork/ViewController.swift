//
//  ViewController.swift
//  RamblerTestWork
//
//  Created by Влад Калаев on 27/06/2019.
//  Copyright © 2019 Влад Калаев. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchField: UISearchBar!
    
    @IBAction func updateContent(_ sender: Any) {
        getDataAndReloadTable()
    }
    
    
    var tableData = [Comment]()
    var filterComments: [Comment] = []
    private var comment: Comment!
    
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)),for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.black
        
        return refreshControl
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDataAndReloadTable()
        tableConfig()
        searchField.delegate = self
    }
    
    // MARK: search
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let filtrData = self.tableData.filter {
            return $0.title.range(of: searchText, options: .caseInsensitive) != nil
        }
        if filtrData.isEmpty {
            filterComments = self.tableData
        } else {
            filterComments = filtrData
        }
        
        self.tableView.reloadData()
        
    }
    
    // MARK: Table
    
    func tableConfig()  {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        tableView.addSubview(self.refreshControl)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if filterComments.count > 0 {
            return filterComments.count
        } else {
            return self.tableData.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if filterComments.count > 0 {
            comment = self.filterComments[indexPath.row]
        } else {
            comment = self.tableData[indexPath.row]
        }
        
        cell.textLabel?.text = comment.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "seg", sender: self)
        
    }
    
    // MARK: Helpers
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seg"  {
            
            let nextVC = segue.destination as? DetailViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            var selectedRow = comment
            
            if filterComments.count > 0 {
                  selectedRow = self.filterComments[indexPath!.row]
            } else {
                  selectedRow = self.tableData[indexPath!.row]
            }
            
            nextVC?.detailComment = selectedRow
            nextVC?.detailContent = self.tableData

        }
    }
    
    func getDataAndReloadTable()  {
        Network.network.getData { (comments) in
            self.tableData = comments
            self.tableView.reloadSections(IndexSet(integersIn: 0...0), with: UITableView.RowAnimation.right)
        }
    }
    
    
    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        getDataAndReloadTable()
        refreshControl.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectionIndexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: selectionIndexPath, animated: animated)
        }
    }
    
    
}

