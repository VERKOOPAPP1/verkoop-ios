//
//  MediaManager.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 14/03/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation
import Photos

enum MediaType {
    case camera
    case gallery
}

protocol CustomMediaManagerDelegates {
    func accessGranted(mediaType: MediaType)
    func accessDenied(mediaType: MediaType, isFirstAttemp: Bool)
    func accessRestricted(mediaType: MediaType)
}

class MediaManager {
    
    static var sharedManager = MediaManager()
    var delegate:CustomMediaManagerDelegates?
    var isFirstAttempt = true
    
    func getCamera() {
        let status =  AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            if let delegateObject = delegate {
                delegateObject.accessGranted(mediaType: .camera)
            }
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    if let delegateObject = self.delegate {
                        delegateObject.accessGranted(mediaType: .camera)
                    }
                } else {
                    if let delegateObject = self.delegate {
                        self.isFirstAttempt = true
                        delegateObject.accessDenied(mediaType: .camera, isFirstAttemp: self.isFirstAttempt)
                    }
                }
            })
        case .denied:
            isFirstAttempt = false
            if let delegateObject = delegate {
                delegateObject.accessDenied(mediaType: .camera, isFirstAttemp: self.isFirstAttempt)
            }
        default:
            if let delegateObject = delegate {
                delegateObject.accessRestricted(mediaType: .camera)
            }
        }
    }
    
    func getPhotoGallery() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized :
            if let delegateObject = delegate {
                delegateObject.accessGranted(mediaType: .gallery)
            }
        case .denied:
            isFirstAttempt = false
            if let delegateObject = delegate {
                delegateObject.accessDenied(mediaType: .gallery, isFirstAttemp: self.isFirstAttempt)
            }
        case .notDetermined:
            isFirstAttempt = true
            PHPhotoLibrary.requestAuthorization({ status in
                if status == .authorized {
                    if let delegateObject = self.delegate {
                        delegateObject.accessGranted(mediaType: .gallery)
                    }
                } else {
                    if let delegateObject = self.delegate {
                        delegateObject.accessDenied(mediaType: .gallery, isFirstAttemp: self.isFirstAttempt)
                    }
                }
            })
            
            if let delegateObject = delegate {
                delegateObject.accessGranted(mediaType: .gallery)
            }
        case .restricted:
            if let delegateObject = delegate {
                delegateObject.accessRestricted(mediaType: .gallery)
            }
        @unknown default:
            Console.log("Do Nothing")
        }
    }
    
    //Better ways of dealing with Camera and Gallery
    
    private enum CameraError: String {
        case denied = "Camera permissions are turned off. Please turn it on in Settings"
        case restricted = "Camera permissions are restricted"
        case notDetermined = "Camera permissions are not determined yet"
        case unavailable = "Camera not available"
    }
    
    private enum GalleryError: String {
        case denied = "Photo Gallery permissions are turned off. Please turn it on in Settings"
        case restricted = "Photo Gallery permissions are restricted"
        case notDetermined = "Photo Gallery permissions are not determined yet"
    }
    
    class func checkGalleryPermission(_ completionHandler:@escaping (_ success:Bool,_ error:NSError?)->()) {
        PHPhotoLibrary.requestAuthorization({ (status:PHAuthorizationStatus) in
            
            switch status {
            case .authorized:
                completionHandler(true, nil)
            case .denied:
                completionHandler(false, NSError.cameraGalleryError(error: GalleryError.denied.rawValue))
            case .restricted:
                completionHandler(false, NSError.cameraGalleryError(error: GalleryError.restricted.rawValue))
            case .notDetermined:
                completionHandler(true, nil)
            @unknown default:
                Console.log("Do Nothing")
            }
        })
    }

    class func checkCameraPermission(_ completionHandler:@escaping (_ success:Bool, _ error:NSError?)->()) {
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized {
            completionHandler(true, nil)
        } else {
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted :Bool) -> Void in
                if granted == true {
                    completionHandler(true, nil)
                } else {
                    completionHandler(false, NSError.cameraGalleryError(error: GalleryError.denied.rawValue))
                }
            });
        }
    }
}

extension NSError {
    static func cameraGalleryError(error:String) -> NSError {
        return NSError(domain: "Media Error", code: 404, userInfo:  [
            NSLocalizedDescriptionKey :  error ,
            NSLocalizedFailureReasonErrorKey : "failed"])
    }
}
