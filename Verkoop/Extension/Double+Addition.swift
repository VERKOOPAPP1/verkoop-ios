//
//  Double+Addition.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 28/03/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

extension Double {
    static func getDouble(_ value: Any?) -> Double{
        guard let doubleValue = value as? Double else {
            let strDouble = String.getString(value)
            guard let doubleValueOfString = Double(strDouble) else {
                return 0.0
            }
            return doubleValueOfString
        }
        return doubleValue
    }
}
