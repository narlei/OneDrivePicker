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
        let key = "1ba6e306-1a77-452d-a556-bb9e8fb143a8"
        self.odPicker = ODPicker(applicationId: key)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let viewController = self.odPicker.viewController()
        
        self.present(viewController, animated: true) {
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: ODPickerDelegate {
    func onClose(selectedFiles: [Any]) {
        
    }
    
    
}
