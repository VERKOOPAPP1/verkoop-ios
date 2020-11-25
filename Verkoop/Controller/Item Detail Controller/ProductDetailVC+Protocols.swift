//
//  ProductDetailVC+Delegates.swift
//  Verkoop
//
//  Created by Vijay on 08/04/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

@objc protocol RefreshScreen {
    @objc optional func refreshData()
}

extension ProductDetailVC: PostCommentDelegates, ReportUserDelegate {
    func requestPostComment(comment: String) {
        Constants.sharedAppDelegate.setSwipe(enabled: true, navigationController: navigationController)
        let param = ["user_id": Constants.sharedUserDefaults.getUserId(), "item_id": itemId , "comment": comment]
        let endPoint = MethodName.comments
        ApiManager.request(path:endPoint, parameters: param, methodType: .post) { [weak self](result) in
            switch result {
            case .success(let data):
                if let response: CommentData = self?.handleSuccess(data: data) {
                    if var commentModel = response.data {
                        commentModel.user_id = Int.getInt(Constants.sharedUserDefaults.getUserId())
                        self?.productDetail?.data?.comments?.append(commentModel)
                        if let count = self?.productDetail?.data?.comments?.count {
                            self?.tableProductDetail.insertRows(at: [IndexPath(row: count - 1, section: 4)], with: .none)
                            self?.tableProductDetail.scrollToRow(at: IndexPath(row: count - 1, section: 4), at: .bottom, animated: true)
                        }
                    }
                    DisplayBanner.show(message: response.message)
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            case .noDataFound(_):
                break
            }
        }
    }

    func requestDeleteComment(commentId: String, indexPath: IndexPath) {
        let endPoint = MethodName.comments + "/" + commentId
        ApiManager.request(path:endPoint, parameters: nil, methodType: .delete) { [weak self](result) in
            switch result {
            case .success(let data):
                if let response: CommentData = self?.handleSuccess(data: data) {
                    if let commentsArray = self?.productDetail?.data?.comments {
                        for i in indexPath.row..<commentsArray.count {
                            let index = Int.getInt(commentsArray[i].index) - 1
                            self?.productDetail?.data?.comments![i].index = index
                        }
                    }
                    self?.productDetail?.data?.comments?.remove(at: indexPath.row)
                    self?.tableProductDetail.deleteRows(at: [indexPath], with: .fade)
                    DisplayBanner.show(message: response.message)
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            case .noDataFound(_):
                break
            }
        }
    }
    
    func didReportUser(reportId: String) {
        let endPoint = MethodName.reportsUser
        let params = ["user_id": Constants.sharedUserDefaults.getUserId(), "item_id": itemId, "report_id": reportId, "type": "0"]
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

extension ProductDetailVC: MakeOfferDelegate {
    func didClickMakeOfferButton(price: String) {
        goToChatVC(offerPrice: price)
    }
}
