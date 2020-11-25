//
//  ScannerVC.swift
//  Verkoop
//
//  Created by Vijay on 30/05/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class ScannerVC: UIViewController {
    
    @IBOutlet weak var cameraContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var qrCodeImageView: UIImageView!
    var qrCode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Constants.sharedAppDelegate.setSwipe(enabled: true, navigationController: navigationController)
    }
    
    fileprivate func initialSetup() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openScannerView(_:)))
        cameraContainerView.addGestureRecognizer(tapGesture)
        if let url = URL(string: API.assetsUrl + Constants.sharedUserDefaults.getQRImage()) {
            DispatchQueue.main.async {
                self.qrCodeImageView.kf.setImage(with: url)
            }
        } else {
            qrCodeImageView.image = nil
        }

        DispatchQueue.main.async {
            self.containerView.makeRoundCorner(2)
            self.cameraContainerView.setRadius(1, .lightGray, 1.2)
            self.containerView.addShadow(offset: CGSize(width: 2, height: 2), color: .black, radius: 3, opacity: 0.2)
        }
    }
    
    @objc func openScannerView(_ recognizer: UITapGestureRecognizer) {
        let cameraVC = CameraScanner.instantiate(fromAppStoryboard: .advertisement)
        cameraVC.delegate = self
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(cameraVC, animated: true)
        }
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
