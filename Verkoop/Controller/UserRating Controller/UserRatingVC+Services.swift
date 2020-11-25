//
//  UserRatingVC+Services.swift
//  Verkoop
//
//  Created by Vijay on 12/06/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

extension UserRatingVC {

    func requestUserRating() {
        var urlString = ""
        switch ratingType {
        case .good:
            urlString = MethodName.goodRating
        case .average:
            urlString = MethodName.averageRating
        case .poor:
            urlString = MethodName.badRating
        }
        urlString = urlString + "/" + Constants.sharedUserDefaults.getUserId()
        ApiManager.request(path:urlString, parameters: nil, methodType: .get) { [weak self](result) in
            switch result {
            case .success(let data):
                if let userRatingData: UserRating = self?.handleSuccess(data: data)  {
                    DispatchQueue.main.async {
                        self?.userRating = userRatingData
                        self?.ratingTableView.delegate = self
                        self?.ratingTableView.dataSource = self
                        self?.ratingTableView.reloadData()
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

extension UserRatingVC: RefreshScreen  {
    func refreshData() {
        
    }
}
