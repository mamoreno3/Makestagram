//
//  MGPhotoHelper.swift
//  Makestagram
//
//  Created by Nguyễn Lâm on 6/27/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit

class MGPhotoHelper: NSObject {
    var completionHandler: ((UIImage) -> Void)?
    
    func presentActionSheet(from viewController: UIViewController) {
        let alertController = UIAlertController(title: nil, message: "Where do you want to pick the picture from?", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let capturePhotoAction = UIAlertAction(title: "Take photo", style: .default, handler: { action in
                
            })
            
            alertController.addAction(capturePhotoAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let uploadAction = UIAlertAction(title: "Pick photo from library", style: .default, handler: { action in
                
            })
            
            alertController.addAction(uploadAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        viewController.present(alertController, animated: true)
    }
}
