//
//  ForgotPassword+Services.swift
//  Verkoop
//
//  Created by Vijay on 16/04/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

extension ForgotPasswordVC: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            if updatedText.isEmpty {
                emailIcon.image = UIImage(named: "email_disable")
                lineView.backgroundColor = .lightGray
            } else {
                emailIcon.image = UIImage(named: "email_enable")
                lineView.backgroundColor = kAppDefaultColor
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func resetPasswordService() {
        let endPoint = MethodName.forgotPassword
        ApiManager.request(path:endPoint, parameters: ["email":emailField.text!], methodType: .post) { [weak self](result) in
            switch result {
            case .success(let data):
                if let response: GenericResponse = self?.handleSuccess(data: data) {
                    DisplayBanner.show(message: response.message)
                    self?.navigationController?.popViewController(animated: true)
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            case .noDataFound(_):
                break
            }
        }
    }
}
