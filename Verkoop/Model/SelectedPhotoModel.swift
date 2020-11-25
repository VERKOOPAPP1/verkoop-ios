//
//  SelectedPhotoModel.swift
//  Verkoop
//
//  Created by Vijay on 17/04/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation
import Photos

struct Photos {
    var selectedIndex:Bool?
    let assest:PHAsset?
    var count = 0
    var indexPath: IndexPath!
    let imageUrl: String?
    var imageId: Int?
}
