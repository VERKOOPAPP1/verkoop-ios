//
//  BuyCoinsVC+Services.swift
//  Verkoop
//
//  Created by Vijay on 29/05/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

extension PurchaseCoinsVC {
    
    func getPlan() {
        let urlString = MethodName.coin_plans + "?user_id=\(Constants.sharedUserDefaults.getUserId())"
        ApiManager.request(path:urlString, parameters: nil, methodType: .get) { [weak self](result) in
            switch result {
            case .success(let data):
                if let planDetail: TransactionHistory = self?.handleSuccess(data: data)  {
                    DispatchQueue.main.async {
                        self?.initialSetup()
                        self?.planData = planDetail
                        self?.planCollectionView.reloadData()
                    }
                    if let coin = planDetail.coins {
                        NotificationCenter.default.post(name: NSNotification.Name(NotificationName.CoinPurchased),
                                                        object: nil,
                                                        userInfo: ["coins": String.getString(coin)])
                    }
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            case .noDataFound(_):
                break
            }
        }
    }

    func purchaseCoinRequest(planDetail: TransactionDetail) {
        let param = ["user_id": Constants.sharedUserDefaults.getUserId(), "coin_plan_id": String.getString(planDetail.id)]
        let urlString = MethodName.user_coin
        ApiManager.request(path:urlString, parameters: param, methodType: .post) { [weak self](result) in
            switch result {
            case .success(let data):
                if let _: GenericResponse = self?.handleSuccess(data: data)  {
                    DispatchQueue.main.async {
                        DisplayBanner.show(message: "\(planDetail.coin ?? 0) coins has been added to your account")
                    }
                    NotificationCenter.default.post(name: NSNotification.Name(NotificationName.CoinPurchased),
                                                    object: nil,
                                                    userInfo: ["coins": String.getString(planDetail.coin)])
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            case .noDataFound(_):
                break
            }
        }
    }
}


