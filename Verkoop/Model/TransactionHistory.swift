//
//  TransactionHistory.swift
//  Verkoop
//
//  Created by Vijay on 28/05/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

struct TransactionHistory: Codable {
    var data: [TransactionDetail]?
    let message: String?
    let coins: Int?
    var amount: Int?
}

struct TransactionDetail: Codable {
    let id: Int?
    let day: Int?
    let name: String?
    let image: String?
    let user_id: Int?
    let token: String?
    let amount: Int?
    var status: Int?
    let type: Int?
    let profilePic: String?
    let userName: String?
    let coin: Int?
    let is_active: Int?
    let created_at: String?
    let updated_at: String?
    let advertisement_plan_id: Int?    
}
