//
//  UserDefaults+Additions.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 27/03/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

struct UserDefaultKeys {
    static let screen = "screen"
    static let loginType = "loginType"
    static let kWalletBalance = "total_amount"
    static let kQRImage = "qrCode_image"
    static let kUserId = "user_id"
    static let kLatitude = "latitude"
    static let kLongitude = "longitude"
    static let kDeviceToken = "deviceToken"
    static let kLoggedInEmail = "email"
    static let kSocialID = "social_id"
    static let kFirstName = "first_name"
    static let kLastName = "last_name"
    static let kUserImage = "profile_pic"
    static let kUserMobile = "mobile_no"
    static let kSelectedCity = "city"
    static let kSelectedState = "state"
    static let kSelectedCityID = "city_id"
    static let kSelectedStateID = "state_id"
    static let kSelectedCountry = "country"
    static let kWebsite = "website"
    static let kBio = "bio"
    static let kSellItem = "sellItem"
    static let kUserGender = "gender"
    static let kdateOfBirth = "DOB"
    static let kUsername = "username"
    static let kUserPassword = "password"
    static let kCityID = "city_id"
    static let kStateID = "state_id"
    static let kMobileVerified = "mobile_verified"
    static let kIsActive = "is_active"
    static let kCountryID = "country_id"
    static let kIsUse = "is_use"
    static let date = "date"
    static let timezone = "timezone"
    static let ktimezoneType = "timezone_type"    
}

extension UserDefaults {
    
    func getQRImage() -> String {
        return String.getString(self.string(forKey: UserDefaultKeys.kQRImage))
    }
    
    func getUserId() -> String {
        return String.getString(self.string(forKey: UserDefaultKeys.kUserId))
    }
    
    func getWalletBalance() -> String {
        return String.getString(self.string(forKey: UserDefaultKeys.kWalletBalance))
    }

    func getCurrentPassword() -> String {
        return String.getString(self.string(forKey: UserDefaultKeys.kUserPassword))
    }
    
    func setLoggedInUserId(loggedInUserId: String) {
        self.set(loggedInUserId, forKey: UserDefaultKeys.kUserId)
        self.synchronize()
    }
    
    func setUserSelectedLocation(_ latitude: Double, _ longitude: Double) {
        self.set(latitude, forKey: UserDefaultKeys.kLatitude)
        self.set(longitude, forKey: UserDefaultKeys.kLongitude)
        self.synchronize()
    }
    
    func getSelectedLatitudeAndLongitude() -> (latitude: Double, longitude: Double) {
        return (Double.getDouble(self.double(forKey: UserDefaultKeys.kLatitude)),
                Double.getDouble(self.double(forKey: UserDefaultKeys.kLongitude)))
    }
    
    func setDeviceToken(deviceToken: String) {
        self.set(deviceToken, forKey: UserDefaultKeys.kDeviceToken)
        self.synchronize()
    }
    
    func getDeviceToken() -> String {
        return String.getString(self.string(forKey: UserDefaultKeys.kDeviceToken))
    }
    
    func getUserName() -> String {
        return String.getString(self.string(forKey: UserDefaultKeys.kUsername))
    }
    
    func getFirstName() -> String {
        return String.getString(self.string(forKey: UserDefaultKeys.kFirstName))
    }
    
    func getLastName() -> String {
        return String.getString(self.string(forKey: UserDefaultKeys.kLastName))
    }

    func getUserGender() -> String {
        return String.getString(self.string(forKey: UserDefaultKeys.kUserGender))
    }
    
    func getUserDOB() -> String {
        return String.getString(self.string(forKey: UserDefaultKeys.kdateOfBirth))
    }
    
    func getBio() -> String {
        return String.getString(self.string(forKey: UserDefaultKeys.kBio))
    }
    
    func getWebsite() -> String {
        return String.getString(self.string(forKey: UserDefaultKeys.kWebsite))
    }

    func getUserImage() -> String {
        return String.getString(self.string(forKey: UserDefaultKeys.kUserImage))
    }
    
    func getUserEmail() -> String {
        return String.getString(self.string(forKey: UserDefaultKeys.kLoggedInEmail))
    }
    
    func getUserCity() -> String {
        return String.getString(self.string(forKey: UserDefaultKeys.kSelectedCity))
    }

    func getUserState() -> String {
        return String.getString(self.string(forKey: UserDefaultKeys.kSelectedState))
    }

    func getUserCityID() -> String {
        return String.getString(self.string(forKey: UserDefaultKeys.kSelectedCityID))
    }
    
    func getUserStateID() -> String {
        return String.getString(self.string(forKey: UserDefaultKeys.kSelectedStateID))
    }

    
    func getUserMobile() -> String {        
        return String.getString(self.string(forKey: UserDefaultKeys.kUserMobile))
    }
    
    func syncDefaults() {
        UserDefaults.standard.synchronize()
    }
}
