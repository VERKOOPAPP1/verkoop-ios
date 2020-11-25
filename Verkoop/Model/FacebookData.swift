//
//  FacebookData.swift
//  GymClass
//
//  Created by Vijay's Macbook on 17/10/18.
//  Copyright © 2018 MobileCoderz5. All rights reserved.
//

import Foundation
struct FacebookData {
    var email: String?
    var firstName: String?
    var lastName: String?
    var name: String?
    var id: String?
    var profileAbsolutePath: String?
    init(result: Any) {
        if let result = result as? [String: Any] {
            email = result["email"] as? String
            firstName = result["first_name"] as? String
            id = result["id"] as? String
            lastName = result["last_name"] as? String
            name = result["name"] as? String
            if let picture = result["picture"] as? [String: Any] {
                if let data = picture["data"] as? [String: Any] {
                    profileAbsolutePath = data["url"] as? String
                }
            }
        }
    }
}
