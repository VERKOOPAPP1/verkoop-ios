//
//  CategoriesVC+Services.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 23/02/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

extension CategoriesVC {
    
    func requestServer() {
        let endPoint = MethodName.getCategories
        ApiManager.request(path:endPoint, parameters: nil, methodType: .get) { [weak self](result) in
            switch result {
            case .success(let data):
                if let list: CategoryList = self?.handleSuccess(data: data) {
                    self?.categoryList = list
                    self?.setupUI()
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            case .noDataFound(_):
                break
            }
        }
    }
}
