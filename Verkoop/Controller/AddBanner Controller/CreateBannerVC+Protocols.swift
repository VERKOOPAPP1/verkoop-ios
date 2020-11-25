//
//  CreateBannerVC+Protocols.swift
//  Verkoop
//
//  Created by Vijay on 10/06/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

extension CreateBannerVC: AddDetailDelegate {
    
    func didCategorySelected(id: Int, categoryName: String, parent_name: String, type: Int) {
        DispatchQueue.main.async {
            self.selectCategoryButton.setTitle(categoryName, for: .normal)
        }
        categoryId = String.getString(id)
    }
}
