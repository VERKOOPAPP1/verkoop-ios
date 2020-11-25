//
//  Int+Extension.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 26/03/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

extension Int {
    static func getInt(_ value: Any?) -> Int {
        guard let intValue = value as? Int else {
            let strInt = String.getString(value)
            guard let intValueOfString = Int(strInt) else {
                return 0
            }
            return intValueOfString
        }
        return intValue
    }
}
