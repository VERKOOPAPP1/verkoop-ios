//
//  HomeVC+Services.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 15/02/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

extension HomeVC {
    func requestServer(showLoader: Bool = true) {
        let endPoint = MethodName.getItem + Constants.sharedUserDefaults.getUserId() + "?page=\(pageIndex)"
        ApiManager.request(path:endPoint, parameters: nil, methodType: .put, showLoader: showLoader) { [weak self](result) in
            switch result {
            case .success(let data):
                if let dataItems:Item = self?.handleSuccess(data: data) {
                    self?.itemData = dataItems
                    self?.collectionViewBrowse.isHidden = false
                    self?.collectionViewBrowse.reloadData()
                }
                self?.refreshControl.endRefreshing()
            case .failure(let error):
                self?.handleFailure(error: error)
            case .noDataFound(_):
                break
            }
        }
    }
    
    func loadMoreData(params: [String: Any]?) {
        let endPoint = MethodName.getItem + Constants.sharedUserDefaults.getUserId() + "?page=\(pageIndex + 1)"
        ApiManager.request(path:endPoint, parameters: params, methodType: .put, showLoader: false) { [weak self](result) in
            switch result {
            case .success(let data):
                if let dataItems: Item = self?.handleSuccess(data: data), let array = dataItems.data?.items, let arrayOld = self?.itemData?.data?.items {
                    self?.itemData?.data?.items = arrayOld + array
                    self?.collectionViewBrowse.reloadData()
                    self?.pageIndex += 1
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            case .noDataFound(_):
                break
            }
        }
    }
    
    func likeCategory(params: [String: String], indexPath: IndexPath, identifier: String = "0") {
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
                        var newIndexPath: IndexPath!
                        if identifier == "0" {
                            let count = Int.getInt(self?.itemData?.data?.daily_pic![indexPath.item].items_like_count) + 1
                            self?.itemData?.data?.daily_pic![indexPath.item].items_like_count = count
                            self?.itemData?.data?.daily_pic![indexPath.item].like_id = likeItems.like_id
                            self?.itemData?.data?.daily_pic![indexPath.item].is_like = true
                            if let cell = self?.pickCollectionView.cellForItem(at: indexPath) as? FilterDetailCollectionCell {
                                cell.likeDislikeButton.isSelected = true
                                cell.labelLikes.text = String.getString(self?.itemData?.data?.daily_pic![indexPath.item].items_like_count)
                                cell.layoutIfNeeded()
                            }
                        } else {
                            let count = Int.getInt(self?.itemData?.data?.items![indexPath.item].items_like_count) + 1
                            self?.itemData?.data?.items![indexPath.item].items_like_count = count
                            self?.itemData?.data?.items![indexPath.item].like_id = likeItems.like_id
                            self?.itemData?.data?.items![indexPath.item].is_like = true
                            newIndexPath = IndexPath(row: indexPath.item + 4, section: indexPath.section)
                            if let cell = self?.collectionViewBrowse.cellForItem(at: newIndexPath) as? FilterDetailCollectionCell {
                                cell.likeDislikeButton.isSelected = true
                                cell.labelLikes.text = String.getString(self?.itemData?.data?.items![indexPath.item].items_like_count)
                                cell.layoutIfNeeded()
                            }
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
    
    func dislikeCategory(params: [String: String], indexPath: IndexPath, identifier: String = "0") {
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
                        var newIndexPath: IndexPath!
                        if identifier == "0" {
                            self?.itemData?.data?.daily_pic![indexPath.item].like_id = 0
                            let count = Int.getInt(self?.itemData?.data?.daily_pic![indexPath.item].items_like_count) - 1
                            self?.itemData?.data?.daily_pic![indexPath.item].items_like_count = count
                            self?.itemData?.data?.daily_pic![indexPath.item].is_like = false
                            newIndexPath = IndexPath(row: indexPath.item, section: indexPath.section)
                            if let cell = self?.pickCollectionView.cellForItem(at: newIndexPath) as? FilterDetailCollectionCell {
                                cell.likeDislikeButton.isSelected = false
                                cell.labelLikes.text = String.getString(self?.itemData?.data?.daily_pic![indexPath.item].items_like_count)
                                cell.layoutIfNeeded()
                            }
                        } else {
                            self?.itemData?.data?.items![indexPath.item].like_id = 0
                            let count = Int.getInt(self?.itemData?.data?.items![indexPath.item].items_like_count) - 1
                            self?.itemData?.data?.items![indexPath.item].items_like_count = count
                            self?.itemData?.data?.items![indexPath.item].is_like = false
                            newIndexPath = IndexPath(row: indexPath.item + 4, section: indexPath.section)
                            if let cell = self?.collectionViewBrowse.cellForItem(at: newIndexPath) as? FilterDetailCollectionCell {
                                cell.likeDislikeButton.isSelected = false
                                cell.labelLikes.text = String.getString(self?.itemData?.data?.items![indexPath.item].items_like_count)
                                cell.layoutIfNeeded()
                            }
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
    
    func imageRecognizeService(with imageBase64: String) {
        let methodName = API.googleURL
        let params = [
            "requests": [
                "image": [
                    "content": imageBase64
                ],
                "features": [
                    [
                        "type": "LABEL_DETECTION",
                        "maxResults": 2
                    ],
                    [
                        "type": "WEB_DETECTION",
                        "maxResults": 2
                    ]
                ]
            ]
        ]
        
        ApiManager.request(isGoogleAPI: true ,path:methodName, parameters: params, methodType: .post, showLoader: true) { [weak self](result) in
            switch result {
            case .success(let data):
                if let response: ImageRecognizationModel = self?.handleSuccess(data: data) {
                    if let dataItems = response.responses.first {
                        if let bestText = dataItems?.webDetection?.bestGuessLabels?.first {
                            self?.recognizedTag = bestText.label ?? ""
                        }
                        if let webEntities = dataItems?.webDetection?.webEntities {
                            for entities in webEntities {
                                if let textString = entities.description {
                                    self?.recognizedTag = (self?.recognizedTag ?? "") + "," + textString
                                }
                            }
                        }
                        
                        if let labelAnotations = dataItems?.labelAnnotations {
                            for anotation in labelAnotations {
                                self?.recognizedTag = (self?.recognizedTag ?? "") + "," + (anotation.description ?? "")
                            }
                        }
                        
                        DispatchQueue.main.async {
                            let favoriteVC = FavouritesCategoriesVC()
                            favoriteVC.itemType = .imageSearch
                            favoriteVC.recognizedTag = self?.recognizedTag ?? ""
                            self?.navigationController?.pushViewController(favoriteVC, animated: true)
                        }
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

extension HomeVC: RefreshScreen {
    func refreshData() {
        requestServer( showLoader: false)
    }
}
