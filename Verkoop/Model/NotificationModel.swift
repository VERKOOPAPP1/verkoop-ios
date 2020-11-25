//
//  NotificationModel.swift
//  Verkoop
//
//  Created by Vijay Singh Raghav on 10/10/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

struct NotificationModel: Codable {
    var data: objectArray?
    var message: String?
}

struct objectArray: Codable {
    var activities: [NotificationObject]?
}

struct NotificationObject: Codable {
    var comment_id: Int?
    var created_at: CreatedAt?
    var description: String?
    var image: String?
    var item_id: Int?
    var user_id: Int?
    var message: String?
    var type: Int?
}
