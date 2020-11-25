//
//  EditProfileVC+Services.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 27/03/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation
import UIKit

extension EditProfileVC {
    func updateProfileService(params: [String: Any]?) {
        let endPoint = MethodName.updateProfile
        ApiManager.requestMultipartApiServer(path: endPoint, parameters: params, methodType: .post, result: { [weak self](result) in
            switch result {
            case .success(let data):
                if let profile: Profile = self?.handleSuccess(data: data) {
                    DisplayBanner.show(message: profile.message)
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
                    Constants.sharedUserDefaults.set(profile.data?.state_id, forKey: UserDefaultKeys.kStateID)
                    Constants.sharedUserDefaults.set(profile.data?.country_id, forKey: UserDefaultKeys.kCountryID)
                    
                    if let createdAt = profile.data?.created_at {
                        Constants.sharedUserDefaults.set(createdAt.date, forKey: UserDefaultKeys.date)
                        Constants.sharedUserDefaults.set(createdAt.timezone, forKey: UserDefaultKeys.timezone)
                        Constants.sharedUserDefaults.set(createdAt.timezone_type, forKey: UserDefaultKeys.ktimezoneType)
                    }
                    self?.navigationController?.popViewController(animated: true)
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            case .noDataFound(_):
                break
            }
        }) { (progress) in
            Console.log(progress)
        }
    }
}
