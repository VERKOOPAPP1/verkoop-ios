//
//  ForgotPasswordVC.swift
//  Verkoop
//
//  Created by Vijay on 16/04/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var emailIcon: UIImageView!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    fileprivate func initialSetup() {
        sendButton.makeRoundCorner(25)
        sendButton.addTarget(self, action: #selector(sendButtonAction(_:)), for: .touchUpInside)
    }
    
    @objc func sendButtonAction(_ sender: UIButton) {
        if let text = emailField.text, !text.isEmpty {
            if text.isValidEmail() {
               resetPasswordService()
            } else {
                DisplayBanner.show(message: "Please enter valid email address")
            }
        } else {
            DisplayBanner.show(message: "Please enter email address.")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Constants.sharedAppDelegate.setSwipe(enabled: true, navigationController: navigationController)
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }    
}
