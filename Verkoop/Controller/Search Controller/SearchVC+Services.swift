//
//  SearchVC+Services.swift
//  Verkoop
//
//  Created by Vijay on 09/04/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

extension SearchVC {
    func getUserList(username: String) {
        var param : [String: String] = [:]
        var endPoint = ""
        if searchType == .user {
            endPoint = MethodName.searchByUserName + "/" + Constants.sharedUserDefaults.getUserId()
            param = ["username": username]
        } else if searchType == .follower {
            endPoint = MethodName.getUserListFollow + "/" + userId
            param = ["type": "0"]
        } else if searchType == .following {
            endPoint = MethodName.getUserListFollow + "/" + userId
            param = ["type": "1"]
        }
        
        ApiManager.request(path:endPoint, parameters: param, methodType: (searchType == .user ? .put : .put)) { [weak self](result) in
            switch result {
            case .success(let data):
                if let responseData: SearchUserData = self?.handleSuccess(data: data) {
                    self?.searchUserData = responseData
                    self?.filteredUserData = responseData
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            case .noDataFound(_):
                break
            }
        }
    }
    
    func getItemList(searchString: String) {
        let endPoint = MethodName.searchByKeyword
        ApiManager.request(path:endPoint, parameters: ["name":searchString, "user_id": Constants.sharedUserDefaults.getUserId()], methodType: .post, showLoader: false) { [weak self](result) in
            switch result {
            case .success(let data):
                if let responseData: SearchItemData = self?.handleSuccess(data: data) {
                    self?.searchItemData = responseData
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            case .noDataFound(_):
                break
            }
        }
    }
    
    func getRecognizedService(searchString: String) {
        let endPoint = MethodName.searchByRecognizedTag
        ApiManager.request(path:endPoint, parameters: ["name":searchString, "user_id": Constants.sharedUserDefaults.getUserId()], methodType: .post, showLoader: false) { [weak self](result) in
            switch result {
            case .success(let data):
                if let responseData: SearchedImageModel = self?.handleSuccess(data: data) {
                    self?.searchedImageData = responseData
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            case .noDataFound(_):
                break
            }
        }
    }
    
    func followUser(param: [String:String], indexPath: IndexPath) {
        if !indices.contains(indexPath) {
            indices.append(indexPath)
            let endPoint = MethodName.followUser
            ApiManager.request(path:endPoint, parameters: param, methodType: .post, showLoader: true) {  [weak self](result) in
                
                let index = self?.indices.firstIndex(where : { (searchIndex) -> Bool in
                    return searchIndex == indexPath
                }) ?? 0
                self?.indices.remove(at: index)
                
                switch result {
                case .success(let data):
                    if let dataItems:FollowData = self?.handleSuccess(data: data) {
                        DisplayBanner.show(message: dataItems.message)
                        let id = self?.filteredUserData?.data![indexPath.row].id ?? -1
                        let index = self?.searchUserData?.data!.firstIndex(where: {(userdata) -> Bool in
                            return userdata.id == id
                        }) ?? -1
                        
                        if index != -1 {
                            self?.searchUserData?.data![index].follower_id = dataItems.data?.id
                        }
                        self?.filteredUserData?.data![indexPath.row].follower_id = dataItems.data?.id
                        guard let cell = self?.tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.SearchedUserCell, for: indexPath) as? SearchedUserCell else {
                            return
                        }
                        cell.followButton.isSelected = true
                        cell.layoutIfNeeded()
                        self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                case .failure(let error):
                    self?.handleFailure(error: error)
                case .noDataFound(_):
                    break
                }
            }
        }
    }

    func unfollowUser(id: String, indexPath: IndexPath) {
        if !indices.contains(indexPath) {
            indices.append(indexPath)
            let endPoint = MethodName.followUser + "/\(id)"
            ApiManager.request(path:endPoint, parameters: nil, methodType: .delete, showLoader: true) {  [weak self](result) in
                
                let index = self?.indices.firstIndex(where : { (searchIndex) -> Bool in
                    return searchIndex == indexPath
                }) ?? 0
                
                self?.indices.remove(at: index)
                switch result {
                case .success(let data):
                    if let dataItems: FollowData = self?.handleSuccess(data: data) {
                        DisplayBanner.show(message: dataItems.message)
                        let id = self?.filteredUserData?.data![indexPath.row].id ?? -1
                        let index = self?.searchUserData?.data!.firstIndex(where: {(userdata) -> Bool in
                            return userdata.id == id
                        }) ?? -1
                        
                        if index != -1 {
                          self?.searchUserData?.data![index].follower_id = 0
                        }
                        self?.filteredUserData?.data![indexPath.row].follower_id = 0
                        guard let cell = self?.tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.SearchedUserCell, for: indexPath) as? SearchedUserCell else {
                            return
                        }
                        cell.followButton.isSelected = false
                        cell.layoutIfNeeded()
                        self?.tableView.reloadRows(at: [indexPath], with: .automatic)
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
