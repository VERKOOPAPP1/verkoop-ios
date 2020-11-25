//
//  ProfileVC+Services.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 19/03/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

extension ProfileVC {
    
    func getUserProfile(isshowLoader: Bool = true) {
        let endPoint = MethodName.userProfile + Constants.sharedUserDefaults.getUserId()
        ApiManager.request(path:endPoint, parameters: nil, methodType: .get, showLoader: isshowLoader) { [weak self](result) in
            switch result {
            case .success(let data):
                if let dataItems: Item = self?.handleSuccess(data: data) {
                    self?.itemData = dataItems
                    self?.collectionCellProfile.isHidden = false
                    self?.collectionCellProfile.reloadData()
                }
                self?.refreshControl.endRefreshing()
            case .failure(let error):
                self?.handleFailure(error: error)
            case .noDataFound(_):
                break
            }
        }
    }
    
    func likeCategory(params: [String: String], indexPath: IndexPath) {
        if !indices.contains(indexPath) {
            indices.append(indexPath)
            let endPoint = MethodName.likes
            ApiManager.request(path:endPoint, parameters: params, methodType: .post, showLoader: true) { [weak self] (result) in
                let index = self?.indices.firstIndex(where : { (searchIndex) -> Bool in
                    return searchIndex == indexPath
                }) ?? 0
                self?.indices.remove(at: index)
                switch result {
                case .success(let data):
                    if let likeItems: LikeDislikeModel = self?.handleSuccess(data: data) {
                        let count = Int.getInt(self?.itemData?.data?.items![indexPath.item].items_like_count) + 1
                        self?.itemData?.data?.items![indexPath.item].items_like_count = count
                        self?.itemData?.data?.items![indexPath.item].like_id = likeItems.like_id
                        self?.itemData?.data?.items![indexPath.item].is_like = true
                        if let cell = self?.collectionCellProfile.cellForItem(at: indexPath) as? FilterDetailCollectionCell {
                            cell.labelLikes.text = String.getString(count)
                            cell.likeDislikeButton.isSelected = true
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
    
    func dislikeCategory(params: [String: String], indexPath: IndexPath) {
        if !indices.contains(indexPath) {
            indices.append(indexPath)
            let endPoint = MethodName.likes + "/" +  String.getString(params["like_id"])
            ApiManager.request(path:endPoint, parameters: params, methodType: .delete, showLoader: true) { [weak self](result) in
                let index = self?.indices.firstIndex(where : { (searchIndex) -> Bool in
                    return searchIndex == indexPath
                }) ?? 0
                self?.indices.remove(at: index)
                
                switch result {
                case .success(let data):
                    if let _: LikeDislikeModel = self?.handleSuccess(data: data) {
                        let count = Int.getInt(self?.itemData?.data?.items![indexPath.item].items_like_count) - 1
                        self?.itemData?.data?.items![indexPath.item].items_like_count = count
                        self?.itemData?.data?.items![indexPath.item].like_id = 0
                        self?.itemData?.data?.items![indexPath.item].is_like = false
                        if let cell = self?.collectionCellProfile.cellForItem(at: indexPath) as? FilterDetailCollectionCell {
                            cell.labelLikes.text = String.getString(count)
                            cell.likeDislikeButton.isSelected = false
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
}

extension ProfileVC: RefreshScreen {
    func refreshData() {
        getUserProfile(isshowLoader: false)
    }
}
