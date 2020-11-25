//
//  ScannerVC+Services.swift
//  Verkoop
//
//  Created by Vijay on 30/05/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

protocol QRScannerDelegate: class {
    func didPaytoUser(friendInfo: FriendDetail, qrCode: String)
}

extension ScannerVC: TransferMoneyDelegate {
    func transferMoneyService(coin: String) {
        let urlString = MethodName.send_money
        let param = ["qrCodeId": qrCode, "user_id": Constants.sharedUserDefaults.getUserId(), "amount": coin]
        ApiManager.request(path:urlString, parameters: param, methodType: .post) { [weak self](result) in
            switch result {
            case .success(let data):
                if let message: GenericResponse = self?.handleSuccess(data: data)  {
                    DispatchQueue.main.async {
                        DisplayBanner.show(message: message.message)
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

extension ScannerVC: QRScannerDelegate {
    
    func didPaytoUser(friendInfo: FriendDetail, qrCode: String) {
        if let transferMoneyView = Bundle.main.loadNibNamed(ReuseIdentifier.TransferMoneyToFriendView, owner: self, options: nil)?.first as? TransferMoneyToFriendView {
            transferMoneyView.frame = view.frame
            transferMoneyView.setData(info: friendInfo)
            transferMoneyView.delegate = self
            transferMoneyView.layoutIfNeeded()
            view.addSubview(transferMoneyView)
            transferMoneyView.showView(animate: true)
            self.qrCode = qrCode
        }
    }

}
