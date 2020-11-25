//
//  String+Extensions.swift
//  GymClass
//
//  Created by Vijay's Macbook on 19/09/18.
//  Copyright © 2018 MobileCoderz5. All rights reserved.
//

import Foundation
extension String {
    static func getString(_ message: Any?) -> String {
        if let string = message {
            guard let strMessage = string as? String else {
                guard let doubleValue = string as? Double else {
                    guard let intValue = string as? Int else {
                        guard string is Float else {
                            guard let int64Value = string as? Int64 else {
                                guard let int32Value = string as? Int32 else {
                                    guard let int16Value = string as? Int32 else {
                                        return ""
                                    }
                                    return String(int16Value)
                                }
                                return String(int32Value)
                            }
                            return String(int64Value)
                        }
                        return String(format: "%.2f", string as! Float)
                    }
                    return String(intValue)
                }                
                let formatter = NumberFormatter()
                formatter.minimumFractionDigits = 0
                formatter.maximumFractionDigits = 2
                formatter.minimumIntegerDigits = 1
                guard let formattedNumber = formatter.string(from: NSNumber(value: doubleValue)) else {
                    return ""
                }
                return formattedNumber
            }
            return strMessage
        }
        return ""
    }
    
    func isPasswordValid() -> Bool {
        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: self)
    }
    
    func isValidEmail() -> Bool { //  "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func isValidName() -> Bool {
        let nameRegEx = "[A-Za-z]+(\\s[A-Za-z]+)?"
        //"[a-zA-Z'-. ]+"
        
        //"^[a-zA-Z\\s]*$]"
        
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return nameTest.evaluate(with: self)
    }
    
    func isContactNumberValid() -> Bool {
        if(self.count >= 8 && self.count <= 16){
            return true
        }
        else{
            return false
        }
    }
    
    
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
    
    func trailingTrim(_ characterSet : CharacterSet) -> String {
        if let range = rangeOfCharacter(from: characterSet, options: [.anchored, .backwards]) {
            return self.substring(to: range.lowerBound).trailingTrim(characterSet)
        }
        return self
    }
    
    func trimFromLeading() -> String
    {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    var boolValue: Bool {
        return NSString(string: self).boolValue
    }
    
    func isPasswordSame(_ confirmPassword : String) -> Bool {
        if confirmPassword == self{
            return true
        }else{
            return false
        }
    }
    
    func isLengthValid(_ length : Int) -> Bool {
        if self.count == length{
            return true
        }else{
            return false
        }
    }
    
    func isLengthValid(minLength: Int , maxLength: Int) -> Bool {
        return self.count >= minLength && self.count <= maxLength
    }
    
    func isNumeric() -> Bool{
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: self))
    }
    
    func isAllDigitsZero() -> Bool{
        if let validValue = Int(self){
            if validValue == 0{
                return true
            }
        }
        return false
    }
    
    func isMinimumLengthValid(minLength : Int) -> Bool {
        return self.count >= minLength
    }
    
    func isMaximumLengthValid(maxLength : Int) -> Bool  {
        return self.count <= maxLength
    }
    
    func isValidPassword() -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: self)
    }
    
    func isAlphabet() -> Bool {
        return CharacterSet.letters.isSuperset(of: CharacterSet(charactersIn: self))
    }
    
    static func basicAuth(userName : String , password : String) -> String{
        let authString = String(format: "%@:%@", userName, password)
        let authStringData = authString.data(using: String.Encoding.utf8)!
        let base64EncodedCredential = authStringData.base64EncodedString()
        let basicAuthString = "Basic \(base64EncodedCredential)"
        return basicAuthString
    }
    
    func isNameValid() -> String? {
        if self == "" {
            
            return Validation.errorNameEmpty
        }else if !self.isValidName() {
            return Validation.errorNameInvalid
        }else if !self.isLengthValid(minLength: 3, maxLength: 10) {
            return Validation.errorNameLength
        }
        return nil
    }
    
    func isPhoneNumberValid() -> String?{
        let value = self
        if value.isEmpty {
            return Validation.errorEmptyPhoneNumber
        }
        else if !value.isNumeric() {
            return Validation.errorNotNumeric
            
        }else if !value.isLengthValid(minLength: 8, maxLength: 15){
            return Validation.errorPhoneLength
        }
        return nil
        
    }
    
    func isEmailValid() -> String?{
        let value = self
        if value == "" {
            return Validation.errorEmailEmpty
        }
        else if !value.isValidEmail() {
            return  Validation.errorEmailInvalid
            
        }
        return nil
        
    }

    func isAlphanumeric() -> Bool {
        return self.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) == nil && self != ""
    }
 
    func validateEmail() {
        
    }
    
    static func getAttributedString(value: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(string: "R ", attributes: [NSAttributedString.Key.font: UIFont.kAppDefaultFontBold(ofSize: 28), NSAttributedString.Key.foregroundColor: kAppGreenColor]))
        attributedString.append(NSAttributedString(string: value.isEmpty ? "00" : value , attributes: [NSAttributedString.Key.font: UIFont.kAppDefaultFontBold(ofSize: 26), NSAttributedString.Key.foregroundColor: UIColor.black]))
        return attributedString
    }
    
    func sendEncodedString() -> String {
        if let data = data(using: String.Encoding.nonLossyASCII) {
            if let encodedString = String(data: data, encoding: String.Encoding.utf8) {
                return encodedString
            }
        }
        return self
    }
    
    func showEncodedString() -> String {
        if let data  = self.data(using: String.Encoding.utf8){
            if let encodedString = String(data: data, encoding: String.Encoding.nonLossyASCII) {
                return encodedString
            }
        }
        return self
    }

    var jsonStringRedecoded: String? {
        let string = self.replacingOccurrences(of: "\n", with: "\\n")
        let data = ("\""+string+"\"").data(using: .utf8)!
        do {
            if let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? String {
                return result
            }
        } catch let error {
            Console.log(error.localizedDescription)
        }
        return ""
    }    
}
