//
//  ODPickerViewController.swift
//  OneDrivePicker
//
//  Created by Narlei A Moreira on 06/11/17.
//  Copyright © 2017 Narlei A Moreira. All rights reserved.
//

import UIKit
import OneDriveSDK


class ODPickerViewController: UIViewController {
   
    // MARK: Outlets
    
    @IBOutlet weak var buttonDone: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    var odPicker:ODPicker!
    var currentItem:ODItem!
    var arrayItems:NSMutableArray = NSMutableArray()
    
    
    // MARK: Actions
    
    @IBAction func actionButtonDone(_ sender: Any) {
        
    }
    
    
    
    // MARK: Constructors
    
    func initialize(odPicker:ODPicker, currentItem:ODItem?) {
        self.odPicker = odPicker
        if currentItem != nil {
            self.currentItem = currentItem
        }
    }
    
    // MARK: Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !self.odPicker.isValid() {
            ODClient.client { (odClient, error) in
                if let client = odClient {
                    self.odPicker.odClient = client
                    self.loadData()
                }else{
                    // Error
                }
            }
        }else{
           self.loadData()
        }
   
    }
    
    func loadData(){
        var itemId = "root"
        if let id = self.currentItem?.id {
            itemId = id
        }
        
        if let request = self.odPicker.odClient.drive().items(itemId).children().request() {
            self.loadItems(request: request)
        }
    }
    
    func loadItems(request:ODChildrenCollectionRequest) {
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
        let item = self.arrayItems.object(at: indexPath.row) as! ODItem
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
        let item = self.arrayItems.object(at: indexPath.row) as! ODItem
        cell.initialize(item: item)
        return cell
    }
    
    
}
