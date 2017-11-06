//
//  ODPickerCell.swift
//  OneDrivePicker
//
//  Created by Narlei A Moreira on 06/11/17.
//  Copyright © 2017 Narlei A Moreira. All rights reserved.
//

import UIKit
import OneDriveSDK

class ODPickerCell: UITableViewCell {
    
    
    // MARK: Properties
    var item:ODItem!
    
    
    func initialize(item:ODItem) {
        self.item = item
        self.textLabel?.text = item.name
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
