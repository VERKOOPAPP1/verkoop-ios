//
//  HomeItemDataModel.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 15/02/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

struct Item : Codable {
    var message: String?
    var data: ItemData?
    var image: String?
}

struct ItemData: Codable {
    var email: String?
    var mobile_no: String?
    var website: String?
    var city: String?
    var state: String?
    var country: String?
    var city_id: Int?
    var state_id: Int?
    var country_id: Int?
    var follow_count: Int?
    var follower_count: Int?
    var block_id: Int?
    var follower_id: Int?
    var advertisments:[Advertisments]?
    var categories:[Category]?
    var items: [DataItem]?
    var reports: [Report]?
    var daily_pic: [DataItem]?
    var totalPage: Int?
    var id: Int?
    var username: String?
    var created_at: String?
    var profile_pic: String?
    let good: Double?
    let sad: Double?
    let average: Double?
}

struct Report: Codable {
    var id: Int?
    var notes: String?
    var created_at: String?
    var description: String?
    var type: Int?
    var name: String?
    var updated_at: String?
    var isSelected: Bool?
}

struct Advertisments: Codable {
    let id: Int?
    let user_id: Int?
    let name: String?
    let image: String?
    let category_id: Int?
}

struct Items: Codable {
    let last_page_url: String?
    let prev_page_url: Int?
    var from: Int?
    var total: Int?
    var path: String?
    var first_page_url: String?
    var last_page: Int?
    var data: [DataItem]?
    var next_page_url:String?
    var current_page: Int?
    var per_page: Int?
    var to: Int?
}
    
struct DataItem : Codable {
    var id: Int?
    var description: String?
    var category_id: Int?
    var created_at: CreatedAt?
    var user_id: Int?
    var price: Float?
    var item_type: Int?
    var name: String?
    var items_like_count: Int?
    var image_url: String?
    var username: String?
    var profile_pic: String?
    var like_id : Int?
    var is_like : Bool?
    var is_sold: Int?
}


struct CreatedAt : Codable {
    var date: String?
    var timezone:String?
    var timezone_type: Int?
}

struct ItemsImages: Codable {
    var item_id: Int?
    var url: String?
}

struct LikeDislikeModel : Codable {
    var message: String?
    var like_id: Int?
    var totalCount:Int?
}

struct UserData : Codable {
    var id: Int?
    var username: String?
}

struct FollowData: Codable {
    var message : String?
    var data: FollowModel?
}

struct FollowModel: Codable {
    var follower_id: Int?
    var user_block_id: Int?
    var user_id: Int?
    var updated_at: String?
    var created_at: String?
    var id: Int?
}
