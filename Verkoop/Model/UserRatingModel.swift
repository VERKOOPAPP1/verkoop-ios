//
//  RatingModel.swift
//  Verkoop
//
//  Created by Vijay on 12/06/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

struct UserRating: Codable {
    let data: [UserRatingDetail]?
}

struct UserRatingDetail: Codable {
    let userName: String?
    let profile_pic: String?
    let rating: Double?
    let name: String?
    let url: String?
    let user_id: Int?
    let item_id: Int?
    let created_at: String?
}
