//
//  LoginVC.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 23/11/18.
//  Copyright © 2018 MobileCoderz. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var textFieldEmail: InfoTextField!
    @IBOutlet weak var textFieldPassword: InfoTextField!
    @IBOutlet weak var buttonLogin: UIButton!
    
    var currentLoginType: LoginType = .normal
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buttonLogin.setRadius(buttonLogin.frame.height/2)
        textFieldEmail.disableImage = "username_disable"
        textFieldEmail.enableImage = "username_enable"
        textFieldEmail.setLeftView(imageName: textFieldEmail.disableImage)
        
        textFieldPassword.disableImage = "password_disable"
        textFieldPassword.enableImage = "password_enable"
        textFieldPassword.setLeftView(imageName: textFieldPassword.disableImage)
        textFieldPassword.setRightClickableView(normalImage: "password_hide", selectedImage: "password_show")
        textFieldPassword.isSecureTextEntry = true
        textFieldEmail.keyboardType = .emailAddress
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Constants.sharedAppDelegate.setSwipe(enabled: false, navigationController: navigationController)
    }
    
    @IBAction func buttonLoginTapped(sender: UIButton){
        currentLoginType = .normal
        checkForValidation()
    }
    
    func checkForValidation() {
        guard let email = textFieldEmail.text, email != "" else {
            DisplayBanner.show(message: Validation.errorEmailEmpty)
            return
        }
        
        if !email.isValidEmail() {
            DisplayBanner.show(message: Validation.errorEmailInvalid)
            return
        }
        
        guard let password = textFieldPassword.text, password != "" else {
            DisplayBanner.show(message: Validation.errorPasswordEmpty)
            return
        }
        
        if !password.isLengthValid(minLength: 6, maxLength: 50) {
            DisplayBanner.show(message: Validation.errorPasswordLengthInvalid)
            return
        }
        
        view.endEditing(true)
        requestServer(parms: [ServerKeys.email: email, ServerKeys.password: password, ServerKeys.requestType: ServerKeys.normal])
    }
    
    @IBAction func buttonFacebookTapped(sender: UIButton) {
        currentLoginType = .facebook
        Constants.sharedAppDelegate.fbHandler?.loginWithFacebook(viewController: self, responseResult: { (result) in
            switch result {
            case .success(let data):
                Console.log(data)
                self.fetchData()
            case .failure(let error):
                if let error = error {
                    Console.log(error.localizedDescription)
                    DisplayBanner.show(message: error.localizedDescription)
                } else {
                    DisplayBanner.show(message: "Something is wrong")
                }
            case .errorMessages(let message):
                DisplayBanner.show(message: message)
            }
        })
    }
    
    func fetchData() {
        Loader.show()
        Constants.sharedAppDelegate.fbHandler?.fetchUserData(responseResult: { [weak self](result) in
            Loader.hide()
            switch result {
            case .success(let data):
                self?.sendFacebookDataToServer(data: data)
                Console.log(data)
                break
            case .failure(let error):
                if let error = error {
                    Console.log(error.localizedDescription)
                    DisplayBanner.show(message: error.localizedDescription)
                }else{
                    DisplayBanner.show(message: "Something is wrong")
                }
                break
            case .errorMessages(let message):
                DisplayBanner.show(message: message)
            }
        })
    }
    
    func sendFacebookDataToServer(data: Any){
        let fbData = FacebookData(result: data)
        var data =  [String: String]()
        if let firstName = fbData.firstName {
            data[ServerKeys.firstName] = firstName
        }
        if let lastName = fbData.lastName{
            data[ServerKeys.lastName] = lastName
        }
        if let email = fbData.email {
            data[ServerKeys.email] = email
        } else {
            data[ServerKeys.email] = ""
        }
        if let id = fbData.id {
            data[ServerKeys.socialId] = id
        }
        data[ServerKeys.requestType] = ServerKeys.social
        requestServer(parms: data)
    }
    
    @IBAction func buttonGoogleTapped(sender: UIButton) {
        sender.isEnabled = false
        delay(time: 0.5) {
            sender.isEnabled = true
        }
        currentLoginType = .google
        Constants.sharedAppDelegate.googlePlusHandler?.delegate = self
        Constants.sharedAppDelegate.googlePlusHandler?.presentingVC = self
        Constants.sharedAppDelegate.googlePlusHandler?.loginWithGooglePlus()        
    }
    
    @IBAction func buttonForgotPasswordTapped(sender: UIButton){
        let vc = ForgotPasswordVC.instantiate(fromAppStoryboard: .registration)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func buttonSignupTapped(sender: UIButton){
        let vc = SignupVC.instantiate(fromAppStoryboard: .registration)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func switchToCategotyScreen() {
        let vc = SelectCategoryVC.instantiate(fromAppStoryboard: .selection)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func switchToDashboard() {
        let vc = DashboardTabBarController.instantiate(fromAppStoryboard: .home)
        navigationController?.pushViewController(vc, animated: true)
        Constants.sharedUserDefaults.set(CurrentScreen.dashboard.rawValue, forKey: UserDefaultKeys.screen)
    }
}

extension LoginVC: StateDelegate {
    func present(viewController: UIViewController) {
        Console.log("TEst")
    }
    
    func dismiss(viewController: UIViewController) {
        Console.log("TEst")
    }
    
    func error() {
        Console.log("TEst")
    }
    
    func user(data: [String : String]) {
        requestServer(parms: data)
    }
}

