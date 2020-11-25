//
//  CoinsHistoryVC+Services.swift
//  Verkoop
//
//  Created by Vijay on 30/05/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation
extension CoinsHistoryVC {
    func requestCoinHistory(showLoader: Bool = true) {
        let urlString = MethodName.user_coin + "?user_id=\(Constants.sharedUserDefaults.getUserId())"
        ApiManager.request(path:urlString, parameters: nil, methodType: .get, showLoader: showLoader) { [weak self](result) in
            self?.refreshControl.endRefreshing()
            switch result {
            case .success(let data):
                if let history: TransactionHistory = self?.handleSuccess(data: data)  {
                    DispatchQueue.main.async {                        
                        self?.transactionHistory = history
                        self?.historyTableView.delegate = self
                        self?.historyTableView.dataSource = self
                        self?.historyTableView.reloadData()
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
