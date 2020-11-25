//
//  OthersProfileVC+Services.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 03/04/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

extension OtherUserProfileVC {
    
    func getUserProfile() {
        let param = ["follower_id":userId, "user_id": Constants.sharedUserDefaults.getUserId()]
        let endPoint = MethodName.otherUserProfile
        ApiManager.requestMultipartApiServer(path: endPoint, parameters: param, methodType: .post, result: { [weak self](result) in
            switch result {
            case .success(let data):
                if let dataItems: Item = self?.handleSuccess(data: data) {
                    self?.itemData = dataItems                    
                    DispatchQueue.main.async {
                        self?.collectionView.isHidden = false
                        self?.collectionView.reloadData()
                        self?.userName = dataItems.data?.username ?? "User Profile"
                        self?.headerTitleLabel.text = dataItems.data?.username
                    }
                    self?.isUserBlocked = Int.getInt(self?.itemData?.data?.block_id) != 0
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
                        if let cell = self?.collectionView.cellForItem(at: indexPath) as? FilterDetailCollectionCell {
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
            let endPoint = MethodName.likes + "/" + String.getString(params["like_id"])
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
                        if let cell = self?.collectionView.cellForItem(at: indexPath) as? FilterDetailCollectionCell {
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
    
    func followUser() {
        let param = ["user_id" : Constants.sharedUserDefaults.getUserId(), "follower_id":userId]
        let endPoint = MethodName.followUser
        ApiManager.request(path:endPoint, parameters: param, methodType: .post, showLoader: true) { [weak self](result) in
            self?.isFollowAPIDataLoading = false
            switch result {
            case .success(let data):
                if let dataItems: FollowData = self?.handleSuccess(data: data) {
                    DisplayBanner.show(message: dataItems.message)
                    self?.itemData?.data?.follower_id = dataItems.data?.id
                    let count = Int.getInt(self?.itemData?.data?.follower_count) + 1
                    self?.itemData?.data?.follower_count = count
                    guard let header = self?.collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 0)) as? OthersProfileHeaderView else {
                        return
                    }
                    header.followButton.isSelected = true
                    header.followButton.backgroundColor = .darkGray
                    header.followerCountLabel.text = String.getString(self?.itemData?.data?.follower_count)
                    header.layoutIfNeeded()
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            case .noDataFound(_):
                break
            }
        }
    }
    
    func unfollowUser(id: String) {
        let endPoint = MethodName.followUser + "/\(id)"
        ApiManager.request(path:endPoint, parameters: nil, methodType: .delete, showLoader: true) { [weak self](result) in
            self?.isFollowAPIDataLoading = false
            switch result {
            case .success(let data):
                if let dataItems: FollowData = self?.handleSuccess(data: data) {
                    DisplayBanner.show(message: dataItems.message)
                    self?.itemData?.data?.follower_id = nil
                    let count = Int.getInt(self?.itemData?.data?.follower_count) - 1
                    self?.itemData?.data?.follower_count = count
                    guard let header = self?.collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 0)) as? OthersProfileHeaderView else {
                        return
                    }
                    header.followButton.backgroundColor = kAppDefaultColor
                    header.followButton.isSelected = false
                    header.followerCountLabel.text = String.getString(self?.itemData?.data?.follower_count)
                    header.layoutIfNeeded()
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            case .noDataFound(_):
                break
            }
        }
    }

    func blockUser() {
        let param = ["user_block_id": userId,  "user_id": Constants.sharedUserDefaults.getUserId()]
        let endPoint = MethodName.blockUser
        ApiManager.request(path:endPoint, parameters: param, methodType: .post, showLoader: false) { [weak self](result) in
            self?.isBlockAPIDataLoading = false
            switch result {
            case .success(let data):
                if let dataItems: FollowData = self?.handleSuccess(data: data) {
                    self?.itemData?.data?.block_id = dataItems.data?.id
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
                    self?.itemData?.data?.block_id = nil
                    self?.headerTitleLabel.text = self?.itemData?.data?.username
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

