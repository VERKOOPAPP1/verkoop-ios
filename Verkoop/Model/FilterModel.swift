//
//  FilterModel.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 29/03/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

struct FilterModel: Codable {
    var data: FilterItems?
    var message: String?
}

struct FilterItems: Codable {
    var subCategoryList: [SubCategory]?
    var items: [DataItem]?
}
