//
//  ActivityVC+Services.swift
//  Verkoop
//
//  Created by Vijay Singh Raghav on 07/10/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

extension ActivityVC  {
    func getNotificationList() {
        let urlString = MethodName.getNotificationList + "/" + Constants.sharedUserDefaults.getUserId()
        ApiManager.request(path:urlString, parameters: nil, methodType: .get) { [weak self](result) in
            self?.refreshControl.endRefreshing()
            switch result {
            case .success(let data):
                if let dataItems: NotificationModel = self?.handleSuccess(data: data)  {
                    self?.notificationModel = dataItems
                    self?.tableView.reloadData()
                    if dataItems.data?.activities?.count == 0 {
                        DisplayBanner.show(message: dataItems.message)
                    }
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            case .noDataFound(_):
                break
            }
        }
    }
    
    func loadMorenotification() {
        let urlString = MethodName.getNotificationList + "/" + Constants.sharedUserDefaults.getUserId()
        ApiManager.request(path:urlString, parameters: nil, methodType: .get, showLoader: false) { [weak self](result) in
            switch result {
            case .success(let data):
                if let dataItems: NotificationModel = self?.handleSuccess(data: data)  {
                    let newItems = dataItems.data?.activities
                    let oldItems = self?.notificationModel?.data?.activities
                    let totalItem = (oldItems ?? [NotificationObject()]) + (newItems ?? [NotificationObject()])
                    self?.notificationModel?.data?.activities = totalItem
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            case .noDataFound(_):
                break
            }
        }
    }
}

