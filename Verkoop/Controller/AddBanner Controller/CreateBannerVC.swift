//
//  CreateBannerVC.swift
//  Verkoop
//
//  Created by Vijay on 27/05/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class CreateBannerVC: UIViewController {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var uploadImageButton: UIButton!
    @IBOutlet weak var selectCategoryButton: UIButton!
    
    var imagePicker = UIImagePickerController()
    var selectedImage: UIImage?
    var categoryId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    fileprivate func initialSetup() {
        selectCategoryButton.addTarget(self, action: #selector(selectCategoryButtonAction(_:)), for: .touchUpInside)
        DispatchQueue.main.async {
            let dashBorder = CAShapeLayer()
            dashBorder.strokeColor = UIColor.gray.cgColor
            dashBorder.lineDashPattern = [5, 5]
            dashBorder.frame = self.bannerImageView.bounds
            dashBorder.fillColor = nil
            dashBorder.path = UIBezierPath(rect: self.bannerImageView.bounds).cgPath
            self.bannerImageView.layer.addSublayer(dashBorder)
            self.uploadImageButton.setRadius(25, kAppDefaultColor, 1.0)
            self.selectCategoryButton.setRadius(25, kAppDefaultColor, 1.0)
            self.saveButton.setRadius(25, UIColor(hexString: "#F5F5F5"), 1.0)
            self.saveButton.addTarget(self, action: #selector(self.saveButtonAction(_:)), for: .touchUpInside)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Constants.sharedAppDelegate.setSwipe(enabled: true, navigationController: navigationController)
    }
    
    @IBAction func selectPackageButtonAction(_ sender: UIButton) {
        let packageVC = SelectPackageVC.instantiate(fromAppStoryboard: .advertisement)
        packageVC.bannerImage = selectedImage!
        packageVC.categoryId = categoryId
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(packageVC, animated: true)
        }
    }
    
    @objc func saveButtonAction(_ sender: UIButton) {
        if sender.titleLabel?.text == "NEXT", let _ = selectedImage {
            if categoryId != "" {
                selectPackageButtonAction(sender)
            } else {
                DisplayBanner.show(message: "Please select category")
            }
        } else {
            DisplayBanner.show(message: "Please upload Banner Image")
        }
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func selectCategoryButtonAction(_ sender: UIButton) {
        let vc = AddSelectCategoryVC.instantiate(fromAppStoryboard: .categories)
        vc.delegate = self
        DispatchQueue.main.async {
            self.navigationController?.present(vc, animated: false, completion: nil)
        }
    }
    
    @IBAction func openGalleryButtonAction(_ sender: UIButton) {
        openActionSheet()
    }
}
