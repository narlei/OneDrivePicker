//
//  ODPicker.swift
//  OneDrivePicker
//
//  Created by Narlei A Moreira on 06/11/17.
//  Copyright © 2017 Narlei A Moreira. All rights reserved.
//

import UIKit
import MSGraphSDK

///
/// Read: https://github.com/OneDrive/onedrive-sdk-ios
///

protocol ODPickerDelegate {
    func onClose(selectedFiles:[ODPickerItem])
}

open class ODPicker {
    
    // MARK: Properties
    
    /// The app ID created in https://dev.onedrive.com/app-registration.htm
    public var applicationId:String!
    
    /// The scodes required to access and share files https://dev.onedrive.com/auth/msa_oauth.htm#authentication-scopes
    public var scopes = "Files.ReadWrite"
    
    /// Class delegate to access files selecteds
    var delegate:ODPickerDelegate! = nil
    
    lazy var odClient: MSGraphClient = {
        let client = MSGraphClient.defaultClient()
        return client!
    }()
    
    /// Files Selected
    var selectedFiles:[MSGraphDriveItem] = [MSGraphDriveItem]()
    
    /// Items shared
    var sharedFiles:[ODPickerItem] = [ODPickerItem]()
    
    // Mark: Constructor
    init(applicationId:String!) {
        self.applicationId = applicationId
    }
    
    // MARK: Methods
    
    /// Set all values to OneDriveSDK
    private func initialize() {
        
    }
    
    /// Return if object was correctly configured
    func isValid() -> Bool {
        if NXOAuth2AuthenticationProvider.sharedAuth().clientId != nil {
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
    
    func addSelected(item:MSGraphDriveItem) {
        self.selectedFiles.append(item)
    }
    
    func removeSelected(item:MSGraphDriveItem) {
        let index = self.selectedFiles.index(where: { (listItem) -> Bool in
            return listItem.entityId == item.entityId
        })
        
        if index != nil {
            self.selectedFiles.remove(at: index!)
        }
    }
    
    func isSelected(item:MSGraphDriveItem) -> Bool {
        
        let index = self.selectedFiles.index(where: { (listItem) -> Bool in
            return listItem.entityId == item.entityId
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
    
    private func makeShared(item:MSGraphDriveItem, onComplete:@escaping (_ finish:Bool) -> Void){
        self.odClient.drive().items(item.entityId).createLink(withType: "edit", scope: self.scopes).request().execute { (response, error) in
            if let url = response?.link.webUrl {
            let pickerItem = ODPickerItem(MSGraphDriveItem: item, link: url)
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




