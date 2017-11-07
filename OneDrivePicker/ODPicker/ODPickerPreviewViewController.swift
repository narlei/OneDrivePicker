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


var myContext = 0

class ODPickerPreviewViewController: UIViewController {

    var item:ODItem!
    var progressView: UIProgressView!
    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        self.view.addSubview(self.webView)
        self.webView.backgroundColor = .white
        self.webView.navigationDelegate = self
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        progressView.frame = CGRect(x: 0, y: 0 , width: self.view.bounds.width, height: 2)
        
        self.view.addSubview(progressView)
        self.view.bringSubview(toFront: progressView)
        
        self.title = self.item.name
        if let thumb = self.item.webUrl {
            let request = URLRequest(url: URL(string:thumb)!)
            self.webView.load(request)
        }
        
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: &myContext)
    }
    
    
    
    //deinit
    deinit {
        //remove all observers
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        //remove progress bar from navigation bar
        progressView.removeFromSuperview()
    }
    
    //observer
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let change = change else { return }
        if context != &myContext {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        if keyPath == "title" {
            return
        }
        if keyPath == "estimatedProgress" {
            if let progress = (change[NSKeyValueChangeKey.newKey] as AnyObject).floatValue {
                progressView.progress = progress;
            }
            return
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

extension ODPickerPreviewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        progressView.isHidden = false
    }
}
