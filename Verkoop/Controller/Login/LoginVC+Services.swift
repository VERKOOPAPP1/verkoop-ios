//
//  LoginVC+Services.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 29/11/18.
//  Copyright © 2018 MobileCoderz. All rights reserved.
//

import Foundation
extension LoginVC {
    func requestServer(parms: [String: Any]?) {
        let endPoint = MethodName.login
        ApiManager.request(path:endPoint, parameters: parms, methodType: .post) { [weak self](result) in
            switch result {
            case .success(let data):
                self?.handleSuccess(data: data)
            case .failure(let error):
                if let error = error {
                    DisplayBanner.show(message: error.localizedDescription)
                } else {
                    DisplayBanner.show(message: ErrorMessages.unauthorizedAccess)
                }
            case .noDataFound(_):
                break
            }
        }
    }
    
    func handleSuccess(data: Any) {
        if let data = data as? [String : Any] {
            do{
                let data = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                let decoder = JSONDecoder()
                do {
                    let profile = try decoder.decode(Profile.self, from: data)
                    DisplayBanner.show(message: profile.message)
                    if let token = profile.data?.token {
                        Constants.sharedUserDefaults.set(token, forKey: ServerKeys.token)
                    }
                    
                    if let userId = profile.data?.userId {
                        Constants.sharedUserDefaults.set(userId, forKey: UserDefaultKeys.kUserId)
                    }
                    
                    Constants.sharedUserDefaults.set(currentLoginType.rawValue, forKey: UserDefaultKeys.loginType)
                    Constants.sharedUserDefaults.set(CurrentScreen.category.rawValue, forKey: UserDefaultKeys.screen)
                    Constants.sharedUserDefaults.set(textFieldPassword.text, forKey: UserDefaultKeys.kUserPassword)
                    Constants.sharedUserDefaults.set(profile.data?.username, forKey: UserDefaultKeys.kUsername)
                    Constants.sharedUserDefaults.set(profile.data?.email, forKey: UserDefaultKeys.kLoggedInEmail)
                    Constants.sharedUserDefaults.set(profile.data?.first_name, forKey: UserDefaultKeys.kFirstName)
                    Constants.sharedUserDefaults.set(profile.data?.last_name, forKey: UserDefaultKeys.kLastName)
                    Constants.sharedUserDefaults.set(profile.data?.profile_pic, forKey: UserDefaultKeys.kUserImage)
                    Constants.sharedUserDefaults.set(profile.data?.city, forKey: UserDefaultKeys.kSelectedCity)
                    Constants.sharedUserDefaults.set(profile.data?.state, forKey: UserDefaultKeys.kSelectedState)
                    Constants.sharedUserDefaults.set(profile.data?.city_id, forKey: UserDefaultKeys.kSelectedCityID)
                    Constants.sharedUserDefaults.set(profile.data?.state_id, forKey: UserDefaultKeys.kSelectedStateID)
                    Constants.sharedUserDefaults.set(profile.data?.country, forKey: UserDefaultKeys.kSelectedCountry)
                    Constants.sharedUserDefaults.set(profile.data?.DOB, forKey: UserDefaultKeys.kdateOfBirth)
                    Constants.sharedUserDefaults.set(profile.data?.bio, forKey: UserDefaultKeys.kBio)
                    Constants.sharedUserDefaults.set(profile.data?.website, forKey: UserDefaultKeys.kWebsite)
                    Constants.sharedUserDefaults.set(profile.data?.gender, forKey: UserDefaultKeys.kUserGender)
                    Constants.sharedUserDefaults.set(profile.data?.mobile_no, forKey: UserDefaultKeys.kUserMobile)
                    Constants.sharedUserDefaults.set(profile.data?.social_id, forKey: UserDefaultKeys.kSocialID)
                    Constants.sharedUserDefaults.set(profile.data?.country_id, forKey: UserDefaultKeys.kCountryID)
                    Constants.sharedUserDefaults.set(profile.data?.qrCode_image, forKey: UserDefaultKeys.kQRImage)                    
                    if let createdAt = profile.data?.created_at {
                        Constants.sharedUserDefaults.set(createdAt.date, forKey: UserDefaultKeys.date)
                        Constants.sharedUserDefaults.set(createdAt.timezone, forKey: UserDefaultKeys.timezone)
                        Constants.sharedUserDefaults.set(createdAt.timezone_type, forKey: UserDefaultKeys.ktimezoneType)
                    }
                    
                    Constants.sharedAppDelegate.registerForPushNotifications()
                    
                    if profile.data?.is_use == 0 {
                        switchToCategotyScreen()
                    } else {
                        switchToDashboard()
                    }
                } catch {
                    Console.log(error.localizedDescription)
                    DisplayBanner.show(message: error.localizedDescription)
                }
            } catch {
                Console.log(error.localizedDescription)
                DisplayBanner.show(message: error.localizedDescription)
            }
        }else{
            DisplayBanner.show(message: ErrorMessages.somethingWentWrong)
        }
    }
}

