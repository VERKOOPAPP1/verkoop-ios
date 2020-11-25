//
//  OthersProfileVC+Delegates.swift
//  Verkoop
//
//  Created by Vijay on 08/04/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

@objc protocol ReportUserDelegate {
    @objc optional func didReportUser(reportId: String)
}

extension OtherUserProfileVC: ReportUserDelegate {

    func didReportUser(reportId: String) {
        let endPoint = MethodName.reportsUser
        let params = ["user_id": userId, "item_id": String.getString(itemData?.data?.id), "report_id": reportId, "type": "1"]
        ApiManager.request(path:endPoint, parameters: params, methodType: .post, showLoader: true) { [weak self](result) in
            switch result {
            case .success(let data):
                if let dataItems: GenericResponse = self?.handleSuccess(data: data) {
                    DisplayBanner.show(message: dataItems.message)
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            case .noDataFound(_):
                break
            }
        }
    }
}

extension OtherUserProfileVC: RefreshScreen {
    func refreshData() {
        getUserProfile()
    }
}
