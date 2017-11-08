//
//  ViewController.swift
//  OneDrivePicker
//
//  Created by Narlei A Moreira on 06/11/17.
//  Copyright © 2017 Narlei A Moreira. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var odPicker:ODPicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let key = "3628c8e1-8754-4e65-8b81-d018eb500921"
        
        
        if self.odPicker == nil {
            self.odPicker = ODPicker(applicationId: key)
            self.odPicker.delegate = self
            
            let viewController = self.odPicker.viewController()
            self.present(viewController, animated: true) {
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension ViewController: ODPickerDelegate {
    func onClose(selectedFiles: [ODPickerItem]) {
        print(selectedFiles)
    }
}
