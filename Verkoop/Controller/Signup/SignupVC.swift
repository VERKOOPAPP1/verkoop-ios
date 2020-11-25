//
//  SignupVC.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 22/11/18.
//  Copyright © 2018 MobileCoderz. All rights reserved.
//

import CountryPickerView

class SignupVC: UIViewController {
    
    @IBOutlet weak var textFieldName: InfoTextField!
    @IBOutlet weak var textFieldCountry: InfoTextField!
    @IBOutlet weak var textFieldEmail: InfoTextField!
    @IBOutlet weak var textFieldPassword: InfoTextField!
    @IBOutlet weak var textFieldConfirmPassword: InfoTextField!
    @IBOutlet weak var buttonSignup: UIButton!
    weak public var dataSource: CountryPickerViewDataSource?
    weak public var delegate: CountryPickerViewDelegate?
    let countryPickerView = CountryPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textFieldName.disableImage = "username_disable"
        textFieldName.enableImage = "username_enable"
        textFieldName.setLeftView(imageName: textFieldName.disableImage)
        // country textfield
        let country = countryPickerView.selectedCountry
        let countryCode = "\(country.name) ( \(country.code) )"
        textFieldCountry.text = countryCode
        textFieldCountry.shouldChangeIconState = false
        textFieldCountry.setLeft(image: country.flag)
        textFieldCountry.setRightView(imageName: "dropdown")
        textFieldCountry.delegate = self
        // email textfield
        textFieldEmail.disableImage = "email_disable"
        textFieldEmail.enableImage = "email_enable"
        textFieldEmail.setLeftView(imageName: textFieldEmail.disableImage)
        // password textfield
        textFieldPassword.disableImage = "password_disable"
        textFieldPassword.enableImage = "password_enable"
        textFieldPassword.setLeftView(imageName: textFieldPassword.disableImage)
        textFieldPassword.setRightClickableView(normalImage: "password_hide", selectedImage: "password_show")
        textFieldPassword.isSecureTextEntry = true
        // confirm password textfield
        textFieldConfirmPassword.disableImage = "password_disable"
        textFieldConfirmPassword.enableImage = "password_enable"
        textFieldConfirmPassword.setLeftView(imageName: textFieldConfirmPassword.disableImage)
        textFieldConfirmPassword.setRightClickableView(normalImage: "password_hide", selectedImage: "password_show")
        textFieldConfirmPassword.isSecureTextEntry = true
        buttonSignup.setRadius(buttonSignup.frame.height/2)
        textFieldEmail.keyboardType = .emailAddress

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Constants.sharedAppDelegate.setSwipe(enabled: true, navigationController: navigationController)
        textFieldCountry.setBottomBorderColor(color: .red)

    }
    
    @IBAction func buttonSignupTapped(sender: UIButton){
        checkForValidation()
    }
    
    func checkForValidation(){
        guard let name = textFieldName.text, name != "" else {
            DisplayBanner.show(message: Validation.errorNameEmpty)
            return
        }
        
        guard let checkSpace = textFieldName.text, !checkSpace.contains(" ") else {
            DisplayBanner.show(message: Validation.invalidUserName)
            return
        }
        
        if !name.isValidName(){
            DisplayBanner.show(message: Validation.errorNameInvalid)
            return
        }
        
        guard let country = textFieldCountry.text, country != "" else {
            DisplayBanner.show(message: Validation.errorEmptyCountry)
            return
        }
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
        if !password.isLengthValid(minLength: 6, maxLength: 50){
            DisplayBanner.show(message: Validation.errorPasswordLengthInvalid)
            return
        }
        
        guard let confirmPassword = textFieldConfirmPassword.text, confirmPassword != "" else {
            DisplayBanner.show(message: Validation.errorEnterConfirmPassword)
            return
        }
        if !confirmPassword.isLengthValid(minLength: 6, maxLength: 50){
            DisplayBanner.show(message: Validation.errorConfirmPasswordLengthInvalid)
            return
        }
        if password != confirmPassword {
            DisplayBanner.show(message: Validation.errorPasswordMismatch)
            return
        }
        guard let countryName = country.components(separatedBy: " ").first, countryName.count > 0 else {
            DisplayBanner.show(message: Validation.errorInvalidCountry)
            return
        }
        view.endEditing(true)
        //{"email":"Raju@mobile.com","Username":"Raju","password":"1234567","City":"ludhiyana","Country":"India","request_type":"normal"}
        let params =  [ServerKeys.userName: name, ServerKeys.country: countryName, ServerKeys.email: email, ServerKeys.password: password, ServerKeys.requestType: ServerKeys.normal]
        requestServer(parms: params)
    }
    @IBAction func buttonLoginTapped(sender: UIButton){
        navigationController?.popViewController(animated: true)
    }
    func showCountryPicker(){
        countryPickerView.delegate = self
        countryPickerView.showCountriesList(from: self)
    }
    func switchToCategotyScreen(){
        let vc = SelectCategoryVC.instantiate(fromAppStoryboard: .selection)
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension SignupVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textFieldCountry == textField {
            showCountryPicker()
            return false
        }
        return true
    }
}
