//
//  BannerListVC+Services.swift
//  Verkoop
//
//  Created by Vijay on 31/05/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//


extension BannerListVC {

    func requestBannerList(showLoader: Bool = true) {
        let urlString = MethodName.userPurchaseAdvertisement + "?user_id=\(Constants.sharedUserDefaults.getUserId())"
        ApiManager.request(path:urlString, parameters: nil, methodType: .get) { [weak self](result) in
            self?.refreshControl.endRefreshing()
            switch result {
            case .success(let data):
                if let history: TransactionHistory = self?.handleSuccess(data: data)  {
                    DispatchQueue.main.async {
                        self?.transactionHistory = history
                        self?.bannerListTableView.reloadData()
                    }
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            case .noDataFound(_):
                break
            }
        }
    }
    
    func deleteBannerService(bannerId: String, indexPath: IndexPath) {
        let urlString = MethodName.userPurchaseAdvertisement + "/" + bannerId
        ApiManager.request(path:urlString, parameters: nil, methodType: .delete) { [weak self](result) in
            switch result {
            case .success(let data):
                if let genericResponse: GenericResponse = self?.handleSuccess(data: data)  {
                    self?.transactionHistory?.data!.remove(at: indexPath.row)
                    self?.bannerListTableView.beginUpdates()
                    self?.bannerListTableView.deleteRows(at: [indexPath], with: .automatic)
                    self?.bannerListTableView.endUpdates()
                    DisplayBanner.show(message: genericResponse.message)
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            case .noDataFound(_):
                break
            }
        }
    }
}


