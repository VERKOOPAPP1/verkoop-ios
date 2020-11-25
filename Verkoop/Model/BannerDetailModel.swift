//
//  BannerDetailModel.swift
//  Verkoop
//
//  Created by Vijay on 10/06/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

struct BannerData: Codable {
    var data: BannerDetail?
    let message: String?
}

struct BannerDetail: Codable {
    let banner: [Advertisments]?
    var items: [DataItem]?
    let totalPage: Int?
}

