//
//  ChatVC+Services.swift
//  Verkoop
//
//  Created by Vijay on 09/05/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

extension ChatVC {
    
    func blockUser() {
        let param = ["user_block_id": info["otherUserId"]!,  "user_id": Constants.sharedUserDefaults.getUserId()]
        let endPoint = MethodName.blockUser
        ApiManager.request(path:endPoint, parameters: param, methodType: .post, showLoader: false) { [weak self](result) in
            self?.isBlockAPIDataLoading = false
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
    
    func unblockUser(id: String) {
        let endPoint = MethodName.blockUser + "/\(id)"
        ApiManager.request(path:endPoint, parameters: nil, methodType: .delete, showLoader: false) { [weak self](result) in
            self?.isBlockAPIDataLoading = false
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

    func uploadImageToServer() {
        if let pickedImage = userImage {
            let param: [String: Any] = ["chat_image": pickedImage.jpeg(.medium) ?? Data()]
            let endPoint = MethodName.chatImageUpload
            ApiManager.requestMultipartApiServer(path: endPoint, parameters: param, methodType: .post, result: { [weak self](result) in
                switch result {
                case .success(let data):
                    if let dataItems: ChatImageModel = self?.handleSuccess(data: data), let urlString = dataItems.data?.image {
                        self?.sendImageURLForChat(urlString: urlString)
                    }
                case .failure(let error):
                    self?.handleFailure(error: error)
                case .noDataFound(_):
                    break
                }
            }) { (progress) in
                Console.log(progress)
            }
        }
    }
}
