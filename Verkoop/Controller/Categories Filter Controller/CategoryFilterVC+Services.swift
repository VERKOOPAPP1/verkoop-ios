//
//  CategoryFilterVC+Services.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 29/03/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

extension CategoriesFilterVC {
    func requestServer(params: [String: Any]?) {
        let endPoint = MethodName.filterCategories + Constants.sharedUserDefaults.getUserId()
        ApiManager.request(path:endPoint, parameters: params, methodType: .put) { [weak self](result) in
            switch result {
            case .success(let data):
                if let filterItem: FilterModel = self?.handleSuccess(data: data) {
                    self?.filterData = filterItem
                    self?.updateData(data: params!)
                    DispatchQueue.main.async {
                        self?.collectionViewFilter.reloadData()
                        self?.collectionViewFilterDetail.reloadData()
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
                let index = self?.indices.firstIndex(where : { (indexPath1) -> Bool in
                    return indexPath1 == indexPath
                }) ?? 0
                self?.indices.remove(at: index)
                switch result {
                case .success(let data):
                    if let likeItems: LikeDislikeModel = self?.handleSuccess(data: data) {
                        let count = Int.getInt(self?.filterData?.data?.items![indexPath.item].items_like_count) + 1
                        self?.filterData?.data?.items![indexPath.item].items_like_count = count
                        self?.filterData?.data?.items![indexPath.item].like_id = likeItems.like_id
                        self?.filterData?.data?.items![indexPath.item].is_like = true
                        if let cell = self?.collectionViewFilterDetail.cellForItem(at: indexPath) as? FilterDetailCollectionCell {
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
                let index = self?.indices.firstIndex(where : { (indexPath1) -> Bool in
                    return indexPath1 == indexPath
                }) ?? 0
                self?.indices.remove(at: index)
                
                switch result {
                case .success(let data):
                    if let _: LikeDislikeModel = self?.handleSuccess(data: data) {
                        let count = Int.getInt(self?.filterData?.data?.items![indexPath.item].items_like_count) - 1 
                        self?.filterData?.data?.items![indexPath.item].items_like_count = count
                        self?.filterData?.data?.items![indexPath.item].like_id = 0
                        self?.filterData?.data?.items![indexPath.item].is_like = false
                        if let cell = self?.collectionViewFilterDetail.cellForItem(at: indexPath) as? FilterDetailCollectionCell {
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

    func updateData(data: Dictionary<String, Any>) {
        
        categoriesFilterArray.removeAll()
        if let sortNo = data[FilterKeys.sort_no.rawValue] as? String, !sortNo.isEmpty {
            categoriesFilterArray.append(AppliedFilter(filterName: sortFilter[Int.getInt(sortNo)], filterType: .sort))
        }
        
        if let itemType = data[FilterKeys.item_type.rawValue] as? String, !itemType.isEmpty {
            categoriesFilterArray.append(AppliedFilter(filterName: "Condition: " + (Int.getInt(itemType) == 0 ? "Used" : "New"), filterType: .itemType))
        }
        
        if let meetup = data[FilterKeys.meet_up.rawValue] as? String, !meetup.isEmpty {
            categoriesFilterArray.append(AppliedFilter(filterName: "Deal Option: Meet-up", filterType: .meetUp))
        }
        
        if let minPrice = data[FilterKeys.min_price.rawValue] as? String, let maxPrice = data[FilterKeys.max_price.rawValue] as? String {
            if !minPrice.isEmpty {
                if !maxPrice.isEmpty {
                    categoriesFilterArray.append(AppliedFilter(filterName: "Price: $\(minPrice) - $\(maxPrice)", filterType: .price))
                } else {
                    categoriesFilterArray.append(AppliedFilter(filterName: "Price: From $\(minPrice)", filterType: .price))
                }
            } else if !maxPrice.isEmpty {
                if !minPrice.isEmpty {
                    categoriesFilterArray.append(AppliedFilter(filterName: "Price: $\(minPrice) - $\(maxPrice)", filterType: .price))
                } else {
                    categoriesFilterArray.append(AppliedFilter(filterName: "Price: Upto $\(maxPrice)", filterType: .price))
                }
            }
        }
    }
}
