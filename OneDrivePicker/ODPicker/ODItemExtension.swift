//
//  ODPickerMimeType.swift
//  OneDrivePicker
//
//  Created by Narlei A Moreira on 07/11/17.
//  Copyright © 2017 Narlei A Moreira. All rights reserved.
//

import UIKit
import OneDriveSDK
import SDWebImage


extension ODItem {
    
    func printImage(to imageView:UIImageView){
        
        if self.folder != nil {
            imageView.image = UIImage(named: "od_folder")
            return
        }
        
        if let thumb = self.thumbnails(0) {
            if let url = URL(string:thumb.small.url) {
                imageView.sd_setImage(with: url)
            }else{
                imageView.image = UIImage(named: "od_default")
            }
            return
        }
        
        if self.file != nil {
            let imageName = self.getFileImageName()
            imageView.image = UIImage(named: imageName)
            return
        }
        
        
        imageView.image = UIImage(named: "od_default")
    }
    
    
    private func getFileImageName() -> String{
        guard let type = self.file?.mimeType else {
            return "od_default"
        }
        
        
        if type.contains("image") {
            return "od_default"
        }
        
        if type.contains("video") {
            return "od_default"
        }
        
        if type.contains("plain") {
            return "od_txt"
        }
        
        if type.contains("sheet") {
            return "od_sheet"
        }
        
        if type.contains("pdf") {
            return "od_pdf"
        }
        
        if type.contains("document") {
            return "od_document"
        }
        
        if type.contains("presentation") {
            return "od_presentation"
        }
        
        if type.contains("zip") {
            return "od_zip"
        }
        
        if type.contains("audio") {
            return "od_audio"
        }
        
        return "od_default"
    }
}
