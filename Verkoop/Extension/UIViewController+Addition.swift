//
//  UIViewController+Extension.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 15/11/18.
//  Copyright © 2018 MobileCoderz. All rights reserved.
//

import FBSDKCoreKit
import FBSDKLoginKit
import FacebookShare
import FBSDKShareKit

extension UIViewController {
    
    class var storyboardID : String {
        return "\(self)"
    }
    
    static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
        return appStoryboard.viewController(viewControllerClass: self)
    }
    
    func showAlert(title: String, message: String)  {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "ok", style: .default) { (_) in
        }
        alertController.addAction(confirmAction)
        self.present(alertController, animated: true, completion: nil)
    }

    func delay(time:TimeInterval,completionHandler: @escaping ()->()) {
        let when = DispatchTime.now() + time
        DispatchQueue.main.asyncAfter(deadline: when) {
            completionHandler()
        }
    }
    
    func setLeftBarButtonItem(imageName: String){
        let image =  UIImage.init(named: imageName)?.withRenderingMode(.alwaysOriginal)
        let barButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: nil)
        navigationItem.leftBarButtonItem = barButtonItem
    }
    
    func setRightBarButtonItem(imageName: String){
        let image =  UIImage.init(named: imageName)?.withRenderingMode(.alwaysOriginal)
        let barButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = barButtonItem
        //navigationItem.setRightBarButton(barButtonItem, animated: true)
    }

    func openMediaActionSheet(completionHandler:@escaping (_ camera:Bool,_ gallery:Bool)->()) {
        
        let alertController = UIAlertController(title:"Select Media", message: "Please select media source", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: Titles.camera, style: .default) { (action) in
            completionHandler(true, false)
        }
        let galleryAction = UIAlertAction(title: Titles.gallery, style: .default) { (action) in
            completionHandler(false, true)
        }
        
        let cancelAction = UIAlertAction(title: Titles.cancel, style: .cancel, handler: nil)
        alertController.addAction(cameraAction)
        alertController.addAction(galleryAction)
        alertController.addAction(cancelAction)
        alertController.view.tintColor = .darkGray
        self.present(alertController, animated: true, completion: nil)
    }
    
    func openCamera(completionHandler:@escaping (_ status:Bool, _ error:NSError?)->()) {
        MediaManager.checkCameraPermission { (status:Bool, error:NSError?) in
            if let error = error {
                completionHandler(status,error)
                return
            }
            if !status {
                completionHandler(status,NSError.cameraGalleryError(error: "Permission not enabled"))
                return
            }
            if !UIImagePickerController.isSourceTypeAvailable(.camera) {
                completionHandler(false,NSError.cameraGalleryError(error: "Camera not available in simulator"))
                return
            }
            completionHandler(status,nil)
        }
    }
    
    func openGallery(completionHandler:@escaping (_ status:Bool, _ error:NSError?)->()) {
        MediaManager.checkGalleryPermission { (status:Bool, error:NSError?) in
            if let error = error {
                completionHandler(status,error)
                return
            }
            if !status {
                completionHandler(status,NSError.cameraGalleryError(error: "Permission not enabled"))
                return
            }
            completionHandler(status,nil)
        }
    }
    
    func handleSuccess<T: Decodable>(data: Any) -> T? {
        if let data = data as? [String : Any] {
            do {
                let data = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                let decoder = JSONDecoder()
                do {
                    let data = try decoder.decode(T.self, from: data)
                    return data
                } catch {
                    DisplayBanner.show(message: error.localizedDescription)
                }
            } catch {
                DisplayBanner.show(message: error.localizedDescription)
            }
        } else {
            DisplayBanner.show(message: ErrorMessages.somethingWentWrong)
        }
        return nil
    }
    
    func handleFailure(error: Error?){
        if let error = error {
            DisplayBanner.show(message: error.localizedDescription)
        } else {
            DisplayBanner.show(message: ErrorMessages.somethingWentWrong)
        }
    }
    
    func showShareDialog(shareString: String) {
        guard let url = URL(string: shareString) else { return }
        let content = ShareLinkContent()
        content.contentURL = url
        let share = ShareDialog()
        share.fromViewController = self
        share.shareContent = content
//        let dialog = ShareDialog (
//            fromViewController: self,
//            content: content,
//            delegate: self
//        )
        share.mode = .web
        share.show()
    }
}

extension UIViewController {
    public func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
        Console.log(results)
    }

    public func sharer(_ sharer: Sharing, didFailWithError error: Error) {
        Console.log(error)
    }

    public func sharerDidCancel(_ sharer: Sharing) {
        Console.log("Sharing Cancel")
    }
}
