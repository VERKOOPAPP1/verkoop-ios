//
//  VKProductDetail+Services.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 25/03/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

extension ProductDetailVC {
    func getItemDetailService(params: [String: Any]?) {
        let endPoint = MethodName.item_details + "/" + String.getString(itemId) + "/" + Constants.sharedUserDefaults.getUserId()
        ApiManager.request(path:endPoint, parameters: nil, methodType: .get) { [weak self](result) in
            switch result {
            case .success(let data):
                if let response: ProductModel = self?.handleSuccess(data: data) {
                    if let type = response.data?.type {
                        self?.itemType = ItemType(rawValue: type)!
                    }
                    self?.productDetail = response
                    self?.updateData()
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            case .noDataFound(_):
                break
            }
        }
    }
    
    func markSold() {
        let endPoint = MethodName.markSold + String.getString(itemId)
        ApiManager.request(path:endPoint, parameters: ["user_id": Constants.sharedUserDefaults.getUserId()], methodType: .put) { [weak self](result) in
            switch result {
            case .success(let data):
                if let response: ProductModel = self?.handleSuccess(data: data) {
                    if let delegateObject = self?.delegate {
                        delegateObject.refreshData?()
                    }
                    self?.navigationController?.popViewController(animated: true)
                    DisplayBanner.show(message: response.message)
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            case .noDataFound(_):
                break
            }
        }
    }
    
    func deleteItem() {
        let endPoint = MethodName.addItem + "/" + String.getString(itemId)
        ApiManager.request(path:endPoint, parameters: nil, methodType: .delete) { [weak self](result) in
            switch result {
            case .success(let data):
                if let response: ProductModel =  self?.handleSuccess(data: data) {
                    if let delegateObject = self?.delegate {
                        delegateObject.refreshData?()
                    }
                    self?.navigationController?.popViewController(animated: true)
                    DisplayBanner.show(message: response.message)
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            case .noDataFound(_):
                break
            }
        }
    }

    func updateData() {
        tableProductDetail.isHidden = false
        tableProductDetail.reloadData()
        bottomContainerView.isHidden = false
        if let urlString = productDetail?.data?.profile_pic {
            let urlStr = API.assetsUrl + urlString
            let str = urlStr.replacingOccurrences(of: "\\", with: "/")
            if let mergeUrl = URL(string: str) {
                profilePic.kf.setImage(with: mergeUrl, placeholder: UIImage(named: "pic_placeholder"))
            } else {
                profilePic.image = UIImage(named: "pic_placeholder")
            }
        }
        if let offerPrice = productDetail?.data?.chat_count, isMyItem {
            chatButton.setTitle("View Chats [\(offerPrice)]", for: .normal)
        } else if !isMyItem, let isItemSold = productDetail?.data?.is_sold, let offerMade = productDetail?.data?.make_offer {
            if isItemSold == 1 && offerMade {
                makeOfferWidthConstraint.constant = 0 //Item is Sold to me
            } else if isItemSold == 0 {
                if offerMade {
                    makeOfferButton.setTitle("Edit Offer", for: .normal)//Offer is Made but not sold
                } else {
                    makeOfferButton.setTitle("Make Offer", for: .normal)//No Action Performed
                }
            } else {
                makeOfferWidthConstraint.constant = 0 //Item Sold to other
            }
        }
        
        nameLabel.text = productDetail?.data?.username
        timeLabel.text = Utilities.sharedUtilities.getTimeDifference(dateString: productDetail?.data?.created_at ?? "", isFullFormat: true)
        view.layoutIfNeeded()
    }
    
    func likeCategory(params: [String: String]) {
        let endPoint = MethodName.likes
        ApiManager.request(path:endPoint, parameters: params, methodType: .post, showLoader: true) { [weak self] (result) in
            switch result {
            case .success(let data):
                if let likeItems: LikeDislikeModel = self?.handleSuccess(data: data) {
                    let count = Int.getInt(self?.productDetail?.data?.items_like_count) + 1
                    self?.productDetail?.data?.items_like_count = count
                    self?.productDetail?.data?.like_id = likeItems.like_id
                    self?.productDetail?.data?.is_like = true
                    if let cell = self?.tableProductDetail.cellForRow(at: IndexPath(row: 0, section: 1)) as? TableCellItemDetail {
                        cell.likeCountLabel.text = String.getString(count)
                        cell.likeButton.isSelected = true
                        cell.layoutIfNeeded()
                    }
                    //Do Remember to update the icon previous Screen
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            case .noDataFound(_):
                break
            }
        }
    }
 
    func dislikeCategory(params: [String: String]) {
        let endPoint = MethodName.likes + "/" + String.getString(params["like_id"])
        ApiManager.request(path:endPoint, parameters: params, methodType: .delete, showLoader: true) { [weak self](result) in
            switch result {
            case .success(let data):
                if let _: LikeDislikeModel = self?.handleSuccess(data: data)  {
                    let count = Int.getInt(self?.productDetail?.data?.items_like_count) - 1
                    self?.productDetail?.data?.items_like_count = count
                    self?.productDetail?.data?.is_like = false
                    self?.productDetail?.data?.like_id = 0
                    if let cell = self?.tableProductDetail.cellForRow(at: IndexPath(row: 0, section: 1)) as? TableCellItemDetail {
                        cell.likeCountLabel.text = String.getString(count)
                        cell.likeButton.isSelected = false
                        cell.layoutIfNeeded()
                    }
                    //Do Remember to update the icon previous Screen
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            case .noDataFound(_):
                break
            }            
        }
    }
}
