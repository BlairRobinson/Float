//
//  signUpImageExtension.swift
//  Float
//
//  Created by Blair Robinson on 21/07/2018.
//  Copyright © 2018 Blair Robinson. All rights reserved.
//

import Foundation
import UIKit

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.profileImage.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}
