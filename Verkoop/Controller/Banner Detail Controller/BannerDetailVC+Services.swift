//
//  BannerDetailVC+Services.swift
//  Verkoop
//
//  Created by Vijay on 10/06/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

extension BannerDetailVC {
    
    func requestBannerDetail(showLoader: Bool = true) {
        let urlString = MethodName.bannerDetails + "/" + userId + "/" + bannerId
        ApiManager.request(path:urlString, parameters: nil, methodType: .get) { [weak self](result) in
            self?.refreshControl.endRefreshing()
            switch result {
            case .success(let data):
                if let bannerData: BannerData = self?.handleSuccess(data: data)  {
                    DispatchQueue.main.async {
                        self?.bannerData = bannerData
                        self?.bannerCollectionView.delegate = self
                        self?.bannerCollectionView.dataSource = self
                    }
                }
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
                        let count = Int.getInt(self?.bannerData?.data?.items![indexPath.item].items_like_count) + 1
                        self?.bannerData?.data?.items![indexPath.item].items_like_count = count
                        self?.bannerData?.data?.items![indexPath.item].like_id = likeItems.like_id
                        self?.bannerData?.data?.items![indexPath.item].is_like = true
                        if let cell = self?.bannerCollectionView.cellForItem(at: indexPath) as? FilterDetailCollectionCell {
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
                        let count = Int.getInt(self?.bannerData?.data?.items![indexPath.item].items_like_count) - 1
                        self?.bannerData?.data?.items![indexPath.item].items_like_count = count
                        self?.bannerData?.data?.items![indexPath.item].like_id = 0
                        self?.bannerData?.data?.items![indexPath.item].is_like = false
                        if let cell = self?.bannerCollectionView.cellForItem(at: indexPath) as? FilterDetailCollectionCell {
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
