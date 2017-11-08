//
//  ODPickerViewController.swift
//  OneDrivePicker
//
//  Created by Narlei A Moreira on 06/11/17.
//  Copyright © 2017 Narlei A Moreira. All rights reserved.
//

import UIKit
import MSGraphSDK


class ODPickerViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var buttonDone: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    var odPicker:ODPicker!
    var currentItem:MSGraphDriveItem!
    var arrayItems:NSMutableArray = NSMutableArray()
    var searchBar:UISearchBar!
    let authentication: Authentication = Authentication()
    
    // MARK: Actions
    
    @IBAction func actionButtonDone(_ sender: Any) {
        self.odPicker.makeItemsShared { (finished) in
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    @objc func actionButtonClose() {
        self.odPicker.selectedFiles = [MSGraphDriveItem]()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: Constructors
    
    func initialize(odPicker:ODPicker, currentItem:MSGraphDriveItem?) {
        self.odPicker = odPicker
        if currentItem != nil {
            self.currentItem = currentItem
        }
    }
    
    // MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 50))
        self.searchBar.placeholder = "Buscar"
        self.searchBar.delegate = self
        self.searchBar.showsCancelButton = true
        self.searchBar.backgroundColor = .white
        self.searchBar.barTintColor = .lightGray
        self.searchBar.backgroundImage = UIImage()
        self.searchBar.searchBarStyle = .minimal
        self.tableView.tableHeaderView = self.searchBar
        
        if !self.odPicker.isValid() {
            self.authentication.connectToGraph(withClientId: self.odPicker.applicationId, scopes: [self.odPicker.scopes], completion: { (error) in
                
            })
        }else{
            self.loadData()
        }
        
        if self.navigationController?.viewControllers.count == 1 {
            let buttonClose = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.actionButtonClose))
            self.navigationItem.leftBarButtonItem = buttonClose
        }
        
        self.registerForPreviewing(with: self, sourceView: self.tableView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateButtonOK()
    }
    
    func updateButtonOK(){
        if self.odPicker.selectedFiles.count > 0 {
            self.buttonDone.title = "OK (\(self.odPicker.selectedFiles.count))"
        }else{
            self.buttonDone.title = "OK"
        }
    }
    
    // MARK: Load Data
    
    func reloadData(){
        self.arrayItems = NSMutableArray()
        self.loadData()
    }
    
    func loadData(){
        var itemId = "root"
        if let id = self.currentItem?.entityId {
            itemId = id
        }
        if let request = self.odPicker.odClient.drive().items(itemId).children().request() {
            request.expand("thumbnails")
            self.loadItems(request: request)
        }
    }
    
    func searchData(term:String) {
        var itemId = "root"
        if let id = self.currentItem?.entityId {
            itemId = id
        }
        self.arrayItems = NSMutableArray()
        if let request = self.odPicker.odClient.drive().items(itemId).search(withQ: term).request() {
            self.loadSearchItems(request: request)
        }
    }
    
    func loadSearchItems(request:MSGraphDriveItemSearchRequest) {
        request.execute(completion: { (collection, nextRequest, error) in
            if let collectionReturn = collection, let items = collectionReturn.value as NSArray?{
                self.reloadItems(array: items)
            }
            if let requestComplement = nextRequest {
                self.loadSearchItems(request: requestComplement)
            }
        })
    }
    
    func loadItems(request:MSGraphDriveItemChildrenCollectionRequest) {
        request.getWithCompletion { (collection, nextRequest, error) in
            if let collectionReturn = collection, let items = collectionReturn.value as NSArray?{
                self.reloadItems(array: items)
            }
            if let requestComplement = nextRequest {
                self.loadItems(request: requestComplement)
            }
            
        }
    }
    
    func reloadItems(array:NSArray) {
        self.arrayItems.addObjects(from: array as! [Any])
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ODPickerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = self.arrayItems.object(at: indexPath.row) as! MSGraphDriveItem
        if let cell = tableView.cellForRow(at: indexPath) {
            // File
            if item.folder == nil {
                if self.odPicker.isSelected(item: item) {
                    cell.accessoryType =  .none
                    self.odPicker.removeSelected(item: item)
                }else{
                    cell.accessoryType = .checkmark
                    self.odPicker.addSelected(item: item)
                }
                self.updateButtonOK()
                return
            }
        }
        // Folder
        let navigationController = UIStoryboard(name: "ODPicker", bundle: nil).instantiateInitialViewController() as! UINavigationController
        let viewController = navigationController.viewControllers.first as! ODPickerViewController
        viewController.initialize(odPicker: self.odPicker, currentItem: item)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension ODPickerViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ODPickerCell", for: indexPath) as! ODPickerCell
        let item = self.arrayItems.object(at: indexPath.row) as! MSGraphDriveItem
        cell.initialize(item: item)
        
        if self.odPicker.isSelected(item: item) {
            cell.accessoryType =  .checkmark
        }
        
        return cell
    }
    
    
}

extension ODPickerViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchData(term: searchBar.text!)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.reloadData()
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.tableView.setContentOffset(CGPoint(x: 0, y: 50), animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.reloadData()
        }
    }
}

extension ODPickerViewController: UIViewControllerPreviewingDelegate {
    // MARK: 3D Touch
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if let indexPath = self.tableView.indexPathForRow(at: location) {
            let item = self.arrayItems.object(at: indexPath.row) as! MSGraphDriveItem
            let viewController = ODPickerPreviewViewController.create(item: item)
            previewingContext.sourceRect = tableView.rectForRow(at: indexPath)
            return viewController
        }
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
}
