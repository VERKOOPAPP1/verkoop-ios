//
//  PackageVC+Services.swift
//  Verkoop
//
//  Created by Vijay on 29/05/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

protocol RenewBannerDelegate: class {
    func didBannerRenewed(bannerId: Int)
}

extension SelectPackageVC {
    
    func renewBannerRequest(planID: String) {
        let param = ["banner_id": bannerId, "advertisement_plan_id": planID]
        let endPoint = MethodName.renewAdvertisement
        ApiManager.requestMultipartApiServer(path: endPoint, parameters: param, methodType: .post, result: { [weak self](result) in
            switch result {
            case .success(let data):
                if let response: GenericResponse = self?.handleSuccess(data: data) {
                    DispatchQueue.main.async {
                        //Update the last Screen using Delegate
                        if let delegateObject = self?.delegate {
                            delegateObject.didBannerRenewed(bannerId: Int.getInt(self?.bannerId))
                            DisplayBanner.show(message: response.message)
                            self?.navigationController?.popViewController(animated: true)
                        }
                    }
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
    
    func submitBannerRequest(planID: String) {        
        let param: [String: Any] = ["user_id": Constants.sharedUserDefaults.getUserId(), "advertisement_plan_id": planID, "banner": bannerImage.jpeg(.medium) ?? Data(), "category_id": categoryId]
        let endPoint = MethodName.userPurchaseAdvertisement
        ApiManager.requestMultipartApiServer(path: endPoint, parameters: param, methodType: .post, result: { [weak self](result) in
            switch result {
            case .success(let data):
                if let dataItems: GenericResponse = self?.handleSuccess(data: data) {
                    Console.log(dataItems)
                    DispatchQueue.main.async {
                        self?.showReviewedPopup()
                    }
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
    
    func showReviewedPopup() {
        if let submittedBannerView = Bundle.main.loadNibNamed(ReuseIdentifier.SubmitBannerView, owner: self, options: nil)?.first as? SubmitBannerView {
            submittedBannerView.frame = view.frame
            submittedBannerView.delegate = self
            submittedBannerView.layoutIfNeeded()
            view.addSubview(submittedBannerView)
            submittedBannerView.animateView(isAnimate: true)
        }
    }
    
    func getAdvertisementPlan() {
        let urlString = MethodName.advertisment_plans + "?user_id=\(Constants.sharedUserDefaults.getUserId())"
        ApiManager.request(path:urlString, parameters: nil, methodType: .get) { [weak self](result) in
            switch result {
            case .success(let data):
                if let planDetail: TransactionHistory = self?.handleSuccess(data: data)  {
                    DispatchQueue.main.async {
                        self?.advertisementData = planDetail
                        self?.packageCollectionView.reloadData()
                        self?.balanceLabel.text = String.getString(planDetail.coins)
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
