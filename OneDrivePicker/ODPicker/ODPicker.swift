//
//  ODPicker.swift
//  OneDrivePicker
//
//  Created by Narlei A Moreira on 06/11/17.
//  Copyright © 2017 Narlei A Moreira. All rights reserved.
//

import UIKit
import OneDriveSDK

///
/// Read: https://github.com/OneDrive/onedrive-sdk-ios
///

protocol ODPickerDelegate {
    func onClose(selectedFiles:[ODPickerItem])
}

open class ODPicker {
    
    // MARK: Properties
    
    /// The app ID created in https://dev.onedrive.com/app-registration.htm
    private var applicationId:String!
    
    /// The scodes required to access and share files https://dev.onedrive.com/auth/msa_oauth.htm#authentication-scopes
    public var scopes = ["onedrive.readwrite"]
    
    /// Class delegate to access files selecteds
    var delegate:ODPickerDelegate! = nil
    
    /// Object of OneDriveSDK
    var odClient:ODClient!
    
    /// Files Selected
    var selectedFiles:[ODItem] = [ODItem]()
    
    /// Items shared
    var sharedFiles:[ODPickerItem] = [ODPickerItem]()
    
    // Mark: Constructor
    init(applicationId:String!) {
        self.applicationId = applicationId
    }
    
    // MARK: Methods
    
    /// Set all values to OneDriveSDK
    private func initialize() {
        ODClient.setMicrosoftAccountAppId(self.applicationId, scopes: self.scopes)        
    }
    
    /// Return if object was correctly configured
    func isValid() -> Bool {
        if self.odClient != nil {
            return true
        }
        
        return false
    }
    
    /// Return view controller to open
    func viewController() -> UIViewController {
        self.initialize()
        
        let navigationController = UIStoryboard(name: "ODPicker", bundle: nil).instantiateInitialViewController() as! UINavigationController
        let viewController = navigationController.viewControllers.first as! ODPickerViewController
        viewController.initialize(odPicker: self, currentItem: nil)
        
        return navigationController
    }
    
    func addSelected(item:ODItem) {
        self.selectedFiles.append(item)
    }
    
    func removeSelected(item:ODItem) {
        let index = self.selectedFiles.index(where: { (listItem) -> Bool in
            return listItem.id == item.id
        })
        
        if index != nil {
            self.selectedFiles.remove(at: index!)
        }
    }
    
    func isSelected(item:ODItem) -> Bool {
        
        let index = self.selectedFiles.index(where: { (listItem) -> Bool in
            return listItem.id == item.id
        })
        
        if index != nil {
            return true
        }
        return false
    }
    
    func makeItemsShared(onComplete:@escaping (_ finish:Bool) -> Void) {
        if let nextItem = self.selectedFiles.first {
            self.makeShared(item: nextItem,onComplete: onComplete)
        }else {
            self.delegate.onClose(selectedFiles: self.sharedFiles)
        }
    }
    
    private func makeShared(item:ODItem, onComplete:@escaping (_ finish:Bool) -> Void){
        self.odClient.drive().items(item.id).createLink(withType: "edit").request().execute { (response, error) in
            if let url = response?.link.webUrl {
            let pickerItem = ODPickerItem(odItem: item, link: url)
                self.sharedFiles.append(pickerItem)
                self.removeSelected(item: item)
                if let nextItem = self.selectedFiles.first {
                    self.makeShared(item: nextItem, onComplete: onComplete)
                }else {
                    onComplete(true)
                    self.delegate.onClose(selectedFiles: self.sharedFiles)
                }
            }
        }
    }
    
    
    
}




