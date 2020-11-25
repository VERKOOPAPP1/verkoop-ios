//
//  SelectCityVC+Services.swift
//  Verkoop
//
//  Created by Vijay on 25/04/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

extension SelectCityVC {
    func getBrandService() {
        let endPoint = MethodName.brands
        ApiManager.request(path:endPoint, parameters:nil, methodType: .get) { [weak self](result) in
            switch result {
            case .success(let data):
                if let response: CategoryList = self?.handleSuccess(data: data) {
                    self?.categoryList = response
                    self?.searchedCategoryList = response
                    OperationQueue.main.addOperation {
                        self?.tableView.reloadData()
                    }
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            case .noDataFound(_):
                break
            }
        }
    }
}
