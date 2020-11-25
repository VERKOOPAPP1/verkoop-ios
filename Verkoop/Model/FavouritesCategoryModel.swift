//
//  FavouritesCategoryModel.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 25/03/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

struct FavouritesItems : Codable {
    var message: String?
    var data: FavoriteData?
}

struct FavoriteData: Codable {
    var items: [DataItem]?
}
