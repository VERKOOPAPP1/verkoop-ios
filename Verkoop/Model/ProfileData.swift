//
//  ProfileData.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 05/12/18.
//  Copyright © 2018 MobileCoderz. All rights reserved.
//

import Foundation

struct Profile : Codable {
    let data : Info?
    let message : String?
}

struct Info : Codable {
    let api_token: String?
    let token : String?
    let social_id : String?
    let login_type : String?
    let userId : Int?
    let id : Int?
    let is_active : Int?
    let country : String?
    let email : String?
    let username : String?
    var city_id: Int?
    var state_id: Int?
    var mobile_verified: Int?
    var city : String?
    var last_name : String?
    var bio : String?
    var state : String?
    var mobile_no : String?
    var country_id: Int?
    var website : String?
    var gender : String?
    var is_use: Int?
    var created_at: CreatedAt?
    var profile_pic : String?
    var first_name : String?
    var DOB : String?
    var qrCode_image: String?
}

