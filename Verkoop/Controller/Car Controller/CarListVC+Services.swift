//
//  CarListVC+Services.swift
//  Verkoop
//
//  Created by Vijay on 18/04/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

extension CarListVC {
    func requestServer(params: [String: Any]?) {
        let endPoint = MethodName.getItem + Constants.sharedUserDefaults.getUserId()
        ApiManager.request(path:endPoint, parameters: params, methodType: .put) { [weak self](result) in
            switch result {
            case .success(let data):
                if let dataItems: CarModel = self?.handleSuccess(data: data) {
                    self?.carData = dataItems
                    self?.collectionView.reloadData()
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
                let index = self?.indices.firstIndex(where : { (indexPath1) -> Bool in
                    return indexPath1 == indexPath
                }) ?? 0
                self?.indices.remove(at: index)
                switch result {
                case .success(let data):
                    if let likeItems: LikeDislikeModel = self?.handleSuccess(data: data) {
                        let count = Int.getInt(self?.carData?.data?.items![indexPath.item].items_like_count) + 1
                        self?.carData?.data?.items![indexPath.item].items_like_count = count
                        self?.carData?.data?.items![indexPath.item].like_id = likeItems.like_id
                        self?.carData?.data?.items![indexPath.item].is_like = true
                        if let cell = self?.collectionView.cellForItem(at: indexPath) as? FilterDetailCollectionCell {
                            cell.likeDislikeButton.isSelected = true
                            cell.labelLikes.text = String.getString(self?.carData?.data?.items![indexPath.item].items_like_count)
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
                let index = self?.indices.firstIndex(where : { (indexPath1) -> Bool in
                    return indexPath1 == indexPath
                }) ?? 0
                self?.indices.remove(at: index)
                
                switch result {
                case .success(let data):
                    if let _: LikeDislikeModel = self?.handleSuccess(data: data) {
                        self?.carData?.data?.items![indexPath.item].like_id = 0
                        let count = Int.getInt(self?.carData?.data?.items![indexPath.item].items_like_count) - 1
                        self?.carData?.data?.items![indexPath.item].items_like_count = count
                        self?.carData?.data?.items![indexPath.item].is_like = false
                        if let cell = self?.collectionView.cellForItem(at: indexPath) as? FilterDetailCollectionCell {
                            cell.likeDislikeButton.isSelected = false
                            cell.labelLikes.text = String.getString(self?.carData?.data?.items![indexPath.item].items_like_count)
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
