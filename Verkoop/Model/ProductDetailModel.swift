//
//  ProductDetailModel.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 25/03/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

struct ProductModel: Codable {
    var message: String?
    var data: ProductDetailModel?
}

struct ProductDetailModel: Codable {
    var id: Int?
    var user_id: Int?
    var category_id: Int?
    var name: String?
    var price: Float?
    var type: Int?
    var address: String?
    var latitude: Double?
    var longitude: Double?
    var meet_up: Int?
    var item_type: Int?
    var description: String?
    var view_count: Int?
    var created_at: String?
    var updated_at: String?
    var items_like_count: Int?
    var is_like: Bool?
    var like_id: Int?
    var username: String?
    var profile_pic: String?
    var category_name: String?
    var items_image: [ItemImage]?
    var comments: [CommentModel]?
    var reports: [Report]?
    var additional_info: AdditionalInfo?
    var model_id: Int?
    var model_name: String?
    var brand_id: Int?
    var zone_id: Int?
    var chat_count: Int?
    var chat_user_id: Int?
    var offer_price: Int?
    var make_offer: Bool?
    var is_sold: Int?
}

struct AdditionalInfo: Codable {
    var transmission_type: String?
    var direct_owner: String?
    var registration_year: String?
    var model_name: String?
    var brand_name: String?
    var location: String?
    var min_price: String?
    var max_price: String?
    var from_year: String?
    var to_year: String?
    var property_type: String?
    var parking_type: String?
    var furnished: String?
    var street_name: String?
    var postal_code: String?
    var city: String?
    var bedroom: String?
    var bathroom: String?
}

struct ItemImage : Codable {
    var item_id: Int?
    var url: String?
}

struct CommentData : Codable {
    var message: String?
    var data: CommentModel?
}

struct CommentModel : Codable {
    var id: Int?
    var user_id: Int?
    var comment: String?
    var created_at: String?
    var username: String?
    var profile_pic: String?
    var index: Int?
}
