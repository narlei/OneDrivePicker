//
//  ODPickerCell.swift
//  OneDrivePicker
//
//  Created by Narlei A Moreira on 06/11/17.
//  Copyright © 2017 Narlei A Moreira. All rights reserved.
//

import UIKit
import OneDriveSDK
import DateToolsSwift


class ODPickerCell: UITableViewCell {
    
    // MARK: Outlet
    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDetail: UILabel!
    
    // MARK: Properties
    var item:ODItem!
    
    
    func initialize(item:ODItem) {
        self.item = item
        self.labelName.text = item.name
        self.labelDetail.text = item.createdDateTime.format(with: "dd/MM/yyyy")
        item.printImage(to: self.imageViewIcon)
        
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
