//
//  BuyCoins+Protocols.swift
//  Verkoop
//
//  Created by Vijay on 30/05/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

extension BuyCoinsVC: PageControllerDelegates {
    func didPageChanged(index: Int) {
        addBottomArrow(forIndex: index)
    }
    
    func addBottomArrow(forIndex: Int) {
        if forIndex == 1 {
            bottomTraingleSecondImage.isHidden = false
            bottomTriangleImage.isHidden = true
        } else {
            bottomTriangleImage.isHidden = false
            bottomTraingleSecondImage.isHidden = true
        }
    }
}

