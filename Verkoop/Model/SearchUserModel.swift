//
//  SearchUserModel.swift
//  Verkoop
//
//  Created by Vijay on 10/04/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

struct GenericResponse: Codable {
    let message: String?
}

struct SearchUserData: Codable {
    let message: String?
    var data:[SearchUserModel]?
}

struct SearchUserModel: Codable {
    let id: Int?
    let username: String?
    let profile_pic: String?
    var follower_id: Int?
}

struct SearchItemData: Codable {
    let message: String?
    let data:[SearchItemModel]?
}

struct SearchedImageModel: Codable {
    let message: String?
    let data: SearchedData?
}

struct SearchedData: Codable {
    var item: [DataItem]?
    let totalPage: String?
}

struct SearchItemModel: Codable {
    let id: Int?
    let category_id: Int?
    let name: String?
    let category_name: String?
    let category: MainCategory?
}

struct MainCategory: Codable {
    let id: Int?
    let name: String?
    let parent_id: Int?

}
