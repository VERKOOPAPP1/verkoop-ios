//
//  ChatVC+ImagePicker.swift
//  Verkoop
//
//  Created by Vijay on 09/05/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

extension ChatVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func openActionSheet() {
        openMediaActionSheet { (camera:Bool, gallery:Bool) in
            if camera {
                self.openCamera(completionHandler: { (success:Bool, error:NSError?) in
                    if let error = error {
                        OperationQueue.main.addOperation {
                            DisplayBanner.show(message: error.localizedDescription)
                        }
                        return
                    }
                    if success {
                        OperationQueue.main.addOperation {
                            self.openImagePicker(sourceType: .camera)
                        }
                    }
                })
            } else {
                self.openGallery(completionHandler: { (success:Bool, error:NSError?) in
                    if let error = error {
                        OperationQueue.main.addOperation {
                            DisplayBanner.show(message: error.localizedDescription)
                        }
                        return
                    }
                    if success {
                        OperationQueue.main.addOperation {
                            self.openImagePicker(sourceType: .photoLibrary)
                        }
                    }
                })
            }
        }
    }
    
    func openImagePicker(sourceType:UIImagePickerController.SourceType) {
        self.imagePicker.allowsEditing = false
        self.imagePicker.sourceType = sourceType
        self.imagePicker.delegate = self
        OperationQueue.main.addOperation({
            self.present(self.imagePicker, animated: true, completion: nil)
        })
    }
    
    //MARK:- ImagePickerController Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // Bug in iOS. The image auto rotates itself. So, in order to fix, image scaling + rotation is done
            userImage = pickedImage.rotateImageWithScaling()
            uploadImageToServer()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
