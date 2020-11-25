//
//  ChangeMobileVC.swift
//  Verkoop
//
//  Created by Vijay on 07/06/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class ChangeMobileVC: UIViewController {

    @IBOutlet weak var countryCodeButton: UIButton!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var mobileField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    weak var delegate: MobileNumberVerifiedDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

    fileprivate func initialSetup() {
        submitButton.setRadius(submitButton.frame.height / 2, .white, 1.2)
        submitButton.addTarget(self, action: #selector(submitButtonAction(_:)), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        Constants.sharedAppDelegate.setSwipe(enabled: true, navigationController: navigationController)
    }
    
    @objc func submitButtonAction(_ sender: UIButton) {
        if let number = mobileField.text, !number.isEmpty {
            if number.isContactNumberValid() {
                requestOTPService()
            } else {
                DisplayBanner.show(message: "Please enter valid mobile number")
            }
        } else {
            DisplayBanner.show(message: "Please enter mobile number.")
        }
    }
    
    @IBAction func selectCountryCodeButton(_ sender: UIButton) {
        let countryVC = CountryCodeVC.instantiate(fromAppStoryboard: .registration)
        countryVC.delegate = self
        navigationController?.present(countryVC, animated: true, completion: nil)
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
