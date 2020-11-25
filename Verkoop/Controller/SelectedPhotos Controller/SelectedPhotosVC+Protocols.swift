//
//  SelectedPhotosVC+Protocols.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 13/03/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation
import Photos

@objc protocol DidDeselectPhotos {
    @objc optional func didDeselectPhoto(indexPath: IndexPath)
}

protocol DidSelectPhotosDelegate {
    func didPhotosSelected(photos: [Photos])
}

extension SelectedPhotosVC : DidDeselectPhotos {
    func didDeselectPhoto(indexPath: IndexPath) {
        collectionViewPhotos.delegate?.collectionView!(collectionViewPhotos, didSelectItemAt: indexPath)
    }
}

extension SelectedPhotosVC : CustomMediaManagerDelegates {
    
    func accessDenied(mediaType: MediaType, isFirstAttemp: Bool) {
        if isFirstAttemp {
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            var title = ""
            if mediaType == .camera {
                title = "You have denied the permission to access Camera."
            } else {
                title = "You have denied the permission to access Gallery."
            }
            
            let actionSheet = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                actionSheet.dismiss(animated: true)
                self.navigationController?.popViewController(animated: true)
            }))
            actionSheet.addAction(UIAlertAction(title: "Go to Settings", style: .default, handler: { action in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }))
            present(actionSheet, animated: true)
        }
    }
    
    func accessGranted(mediaType: MediaType) {
        if mediaType == .camera {
            DispatchQueue.main.async {
                self.openCamera()
            }
        } else {
            DispatchQueue.main.async {
                self.getImages()
            }
        }
    }
    
    func accessRestricted(mediaType: MediaType) {
        var title = ""
        if mediaType == .camera {
            title = "Camera usage is restricted by other app."
        } else {
            title = "Gallery usage is restricted by other app."
        }
        
        let actionSheet = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        actionSheet.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
            actionSheet.dismiss(animated: true)
            self.navigationController?.popViewController(animated: true)
        }))
        present(actionSheet, animated: true)
    }
}
