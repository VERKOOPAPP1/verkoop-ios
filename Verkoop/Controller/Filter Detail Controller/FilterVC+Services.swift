//
//  FilterVC+Services.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 30/03/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

extension FilterVC {
    func applyFilterService(params: [String: Any]?, completion: @escaping (FilterModel?)->()) {
        let endPoint = MethodName.filterCategories + Constants.sharedUserDefaults.getUserId()
        ApiManager.request(path:endPoint, parameters: params, methodType: .put) { [weak self](result) in
            switch result {
            case .success(let data):
                if let filterItem: FilterModel = self?.handleSuccess(data: data) {
                    print(filterItem)
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            case .noDataFound(_):
                break
            }
        }
    }
}
