//
//  WalletVC+Services.swift
//  Verkoop
//
//  Created by Vijay on 28/05/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

extension WalletVC {
    
    func requestWalletHistory(showLoader: Bool = true) {
        let urlString = MethodName.payments + "?user_id=\(Constants.sharedUserDefaults.getUserId())"
        ApiManager.request(path:urlString, parameters: nil, methodType: .get) { [weak self](result) in
            switch result {
            case .success(let data):
                if let history: TransactionHistory = self?.handleSuccess(data: data)  {
                    DispatchQueue.main.async {
                        self?.transactionHistory = history
                        self?.balanceLabel.attributedText = String.getAttributedString(value: String.getString(history.amount))
                        self?.transactionTableView.delegate = self
                        self?.transactionTableView.dataSource = self
                        self?.transactionTableView.reloadData()
                    }
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            case .noDataFound(_):
                break
            }
        }
    }

    func addMoneyToWallet(amount: String, token: String) {
        let urlString = MethodName.payments
        let param: [String:String] = ["user_id": Constants.sharedUserDefaults.getUserId(),
                                      "amount": amount,
                                      "token": token,
                                      "currency": "ZAR"]
        ApiManager.request(path:urlString, parameters: param, methodType: .post) { [weak self](result) in
            switch result {
            case .success(let data):
                if let dataItems: GenericResponse = self?.handleSuccess(data: data)  {
                    let oldAmount = Int.getInt(self?.transactionHistory?.amount)
                    let newAmount = oldAmount + Int.getInt(amount)
                    self?.transactionHistory?.amount = newAmount
                    Constants.sharedUserDefaults.set(String.getString(newAmount), forKey: UserDefaultKeys.kWalletBalance)
                    self?.balanceLabel.attributedText = String.getAttributedString(value: String.getString(newAmount))
                    self?.requestWalletHistory(showLoader: false)
                    print(dataItems)
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            case .noDataFound(_):
                break
            }
        }
    }
}
