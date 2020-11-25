//
//  FriendInfoModel.swift
//  Verkoop
//
//  Created by Vijay on 03/06/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

struct FriendInfoModel: Codable {
    let data: FriendDetail?
    let message: String?
}

struct FriendDetail: Codable {
    let id: Int?
    let username: String?
    let first_name: String?
    let last_name: String?
    let profile_pic: String?
}

struct ChatImageModel: Codable {
    let data: ImageDetail?
    let message: String?
}

struct ImageDetail: Codable {
    let image: String?
}
