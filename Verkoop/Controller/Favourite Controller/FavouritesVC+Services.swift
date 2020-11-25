//
//  FavouritesVC+Services.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 25/03/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

extension FavouritesCategoriesVC {
    func getFavouritesCategories(methodName: String = MethodName.getFavouriteCategories + Constants.sharedUserDefaults.getUserId()) {
        let param = ["name":recognizedTag, "user_id": Constants.sharedUserDefaults.getUserId()]
        ApiManager.request(path:methodName, parameters: itemType == .imageSearch ? param : nil , methodType: itemType == .imageSearch ? .post : .get) { [weak self](result) in
            self?.refreshControl.endRefreshing()
            switch result {
            case .success(let data):
                if let dataItems: FavouritesItems = self?.handleSuccess(data: data) {
                    if let count = dataItems.data?.items?.count, count == 0 {
                        DisplayBanner.show(message: "No Favourite Added")
                    } else {
                        self?.itemData = dataItems
                        self?.collectionView.isHidden = false
                        self?.collectionView.reloadData()
                    }
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            case .noDataFound(_):
                break
            }
        }
    }
    
    func getFilteredCarAndProperty(param: [String:Any]) {
        let endPoint = MethodName.carFilterData + Constants.sharedUserDefaults.getUserId()
        ApiManager.request(path:endPoint, parameters: param , methodType: .put) { [weak self](result) in
            switch result {
            case .success(let data):
                if let dataItems: FavouritesItems = self?.handleSuccess(data: data){
                    if let count = dataItems.data?.items?.count, count == 0 {
                        if self?.itemType == .car {
                            DisplayBanner.show(message: "No Cars Found")
                        } else{
                            DisplayBanner.show(message: "No Property Added")
                        }
                    } else {
                        self?.itemData = dataItems
                        self?.collectionView.isHidden = false
                        self?.collectionView.reloadData()
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
                        let count = Int.getInt(self?.itemData?.data?.items![indexPath.item].items_like_count) + 1
                        self?.itemData?.data?.items![indexPath.item].items_like_count = count
                        self?.itemData?.data?.items![indexPath.item].like_id = likeItems.like_id
                        self?.itemData?.data?.items![indexPath.item].is_like = true
                        if let cell = self?.collectionView.cellForItem(at: indexPath) as? FilterDetailCollectionCell {
                            cell.labelLikes.text = String.getString(count)
                            cell.likeDislikeButton.isSelected = true
                        }
                        if let delegateObject = self?.delegate {
                            delegateObject.refreshData?()
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
                    if let _: LikeDislikeModel = self?.handleSuccess(data: data)  {
                        let count = Int.getInt(self?.itemData?.data?.items![indexPath.item].items_like_count) - 1
                        self?.itemData?.data?.items![indexPath.item].items_like_count = count
                        self?.itemData?.data?.items![indexPath.item].like_id = 0
                        self?.itemData?.data?.items![indexPath.item].is_like = false
                        if let cell = self?.collectionView.cellForItem(at: indexPath) as? FilterDetailCollectionCell {
                            cell.labelLikes.text = String.getString(count)
                            cell.likeDislikeButton.isSelected = false
                        }
                        if let delegateObject =  self?.delegate {
                            delegateObject.refreshData?()
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

extension FavouritesCategoriesVC: RefreshScreen {
    func refreshData() {
        requestFavouriteData()
    }
}
