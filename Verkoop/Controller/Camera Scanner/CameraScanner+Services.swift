//
//  CameraScanner+Services.swift
//  Verkoop
//
//  Created by Vijay on 03/06/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

extension CameraScanner {
    func getFriendDetail(qrCode: String) {
        let urlString = MethodName.friendInfo + "/" + qrCode
        ApiManager.request(path:urlString, parameters: nil, methodType: .get) { [weak self](result) in
            switch result {
            case .success(let data):
                if let userInfo: FriendInfoModel = self?.handleSuccess(data: data), let detail = userInfo.data  {
                    DispatchQueue.main.async {
                        self?.foundQRCode(info: detail, qrCode: qrCode)
                        self?.navigationController?.popViewController(animated: true)
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
