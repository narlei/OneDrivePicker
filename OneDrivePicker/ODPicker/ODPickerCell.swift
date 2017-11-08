//
//  ODPickerCell.swift
//  OneDrivePicker
//
//  Created by Narlei A Moreira on 06/11/17.
//  Copyright © 2017 Narlei A Moreira. All rights reserved.
//

import UIKit
import MSGraphSDK
import DateToolsSwift


class ODPickerCell: UITableViewCell {
    
    // MARK: Outlet
    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDetail: UILabel!
    @IBOutlet weak var labelCount: UILabel!
    
    // MARK: Properties
    var item:MSGraphDriveItem!
    
    func initialize(item:MSGraphDriveItem) {
        self.item = item
        self.labelName.text = item.name
        
        
        let fileSizeWithUnit = ByteCountFormatter.string(fromByteCount: item.size, countStyle: .file)
        let date = item.createdDateTime.format(with: "dd/MM/yyyy")
        self.labelDetail.text = "\(date)・\(fileSizeWithUnit)"
        
        
        self.labelCount.isHidden = true
        if let count = item.folder?.childCount {
            self.labelCount.text = "\(count)"
            self.labelCount.isHidden = false
        }
        
        
        item.printImage(to: self.imageViewIcon)
        
        
        if item.folder != nil {
            self.accessoryType = .disclosureIndicator
        }else{
            self.accessoryType = .none
        }
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
