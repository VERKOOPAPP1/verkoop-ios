//
//  ChatVC+Delegates.swift
//  Verkoop
//
//  Created by Vijay on 09/05/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

extension ChatVC: ReportUserDelegate {
    
    func didReportUser(reportId: String) {
        let endPoint = MethodName.reportsUser
        let params = ["user_id": info["otherUserId"]!, "item_id": info["item_id"]!, "report_id": reportId, "type": "1"]
        ApiManager.request(path:endPoint, parameters: params, methodType: .post, showLoader: true) { [weak self](result) in
            switch result {
            case .success(let data):
                if let dataItems: FollowData = self?.handleSuccess(data: data) {
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

extension ChatVC: MakeOfferDelegate {
    func didClickMakeOfferButton(price: String) {
        isPopupPresent = false
        if SocketHelper.shared.socketStatus() == .connected {
            sendButton.isEnabled = false
            sendButton.alpha = 0.8
            SocketHelper.shared.offerEvent(params: ["chat_user_id": chatUserId,
                                                    "sender_id":senderId,
                                                    "receiver_id": receiverId,
                                                    "item_id": info["item_id"]!,
                                                    "message": price,
                                                    "type": "2",
                                                    "price": price],
                                           socketEvent: SocketEvent.makeOffer)
            messageTextView.text = ""
        } else {
            DisplayBanner.show(message: "There is some connection problem")
        }
    }
    
    func removeFromSuperView() {
         isPopupPresent = false
    }
}

extension ChatVC: RateUserDelegate {
    func didRateUser(rating: String) {
        if SocketHelper.shared.socketStatus() == .connected {
            sendButton.isEnabled = false
            sendButton.alpha = 0.8
            SocketHelper.shared.offerEvent(params: ["chat_user_id": chatUserId,
                                                    "sender_id":senderId,
                                                    "receiver_id": receiverId,
                                                    "item_id": info["item_id"]!,
                                                    "message": rating ,
                                                    "type": "6",
                                                    "price": rating],
                                           socketEvent: SocketEvent.rateUser)
        } else {
            DisplayBanner.show(message: "There is some connection problem")
        }
        
//        let urlString = MethodName.ratings
//        let param = ["item_id": info["item_id"]!, "user_id": Constants.sharedUserDefaults.getUserId(), "rating": rating, "rated_user_id": info["otherUserId"]!]
//        ApiManager.request(path:urlString, parameters: param, methodType: .post) { [weak self](result) in
//            switch result {
//            case .success(let data):
//                if let message: GenericResponse = self?.handleSuccess(data: data) {
//                    DispatchQueue.main.async {
//                        self?.offerStatusType = .itemSoldToOther
//                        DisplayBanner.show(message: message.message)
//                    }
//                }
//            case .failure(let error):
//                self?.handleFailure(error: error)
//            case .noDataFound(_):
//                break
//            }
//        }
    }
}
