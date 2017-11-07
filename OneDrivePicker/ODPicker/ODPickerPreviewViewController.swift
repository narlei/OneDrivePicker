//
//  ODPickerPreviewViewController.swift
//  OneDrivePicker
//
//  Created by Narlei A Moreira on 07/11/17.
//  Copyright © 2017 Narlei A Moreira. All rights reserved.
//

import UIKit
import WebKit
import OneDriveSDK

class ODPickerPreviewViewController: UIViewController {

    
    var item:ODItem!
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        self.view.addSubview(self.webView)
        self.webView.backgroundColor = .white
        
        
        
        self.title = self.item.name
        if let thumb = self.item.webUrl {
            
            let request = URLRequest(url: URL(string:thumb)!)
            self.webView.load(request)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class func create(item:ODItem) -> UIViewController? {
        if item.webUrl != nil {
            let viewController = UIStoryboard(name: "ODPickerPreview", bundle: nil).instantiateInitialViewController() as! ODPickerPreviewViewController
            viewController.item = item
            return viewController
        }else{
            return nil
        }
    }

}
