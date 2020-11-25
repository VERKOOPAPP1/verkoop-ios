//
//  ResponseModel.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 15/11/18.
//  Copyright © 2018 MobileCoderz. All rights reserved.
//

import Foundation
struct ResponseModel {
    var message: String?
    init(response: [String: Any]) {
        if let data = response[ServerKeys.data] as? [String: Any] { 
            message = response[ServerKeys.message] as? String
            var messageArray  = [String]()
            let keys = data.keys
            for key in keys {
                if let errorArray = data[key] as? [String] , let errorMessage = errorArray.first {
                    messageArray.append(errorMessage)
                }
            }
            if messageArray.count > 0 {
                message = messageArray.joined(separator: "\n")
            }
        } else if let errorObject = response["errors"] as? [String: Any], let errorArray = errorObject["less_amount"] as? [String], let errorMessage = errorArray.first {
            message = errorMessage
        } else {
            message = response[ServerKeys.message] as? String
        }
    }
}
