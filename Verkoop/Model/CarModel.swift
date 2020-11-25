//
//  CarModel.swift
//  Verkoop
//
//  Created by Vijay on 26/04/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

struct CarModel : Codable {
    var message: String?
    var data: CarListItem?
}

struct CarListItem: Codable {
    var brands: [Category]?
    var car_types: [Category]?
    var items: [DataItem]?
    var totalPage: Int?
}
