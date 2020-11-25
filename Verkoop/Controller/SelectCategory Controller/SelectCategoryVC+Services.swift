//
//  SelectCategoryVC+Services.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 14/02/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

extension SelectCategoryVC {
    func updateSelectedCategory() {
        let endPoint = MethodName.userSelectedCategory
        let idString = categoriesIdArray.joined(separator: ",")
        let param = ["user_id": Constants.sharedUserDefaults.getUserId(), "category_id": idString]
        ApiManager.request(path:endPoint, parameters: param, methodType: .post) { [weak self](result) in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    let vc = SelectOptionsVC.instantiate(fromAppStoryboard: .selection)
                    Constants.sharedUserDefaults.set(CurrentScreen.option.rawValue, forKey: UserDefaultKeys.screen)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            case .noDataFound(_):
                break
            }
        }
    }
    
    func requestServer(parms: [String: Any]?) {
        let endPoint = MethodName.getCategories
        ApiManager.request(path:endPoint, parameters: parms, methodType: .get) { [weak self](result) in
            switch result {
            case .success(let data):
                if let list: CategoryList = self?.handleSuccess(data: data) {
                    self?.categoryList = list
                    if let count = self?.categoryList?.data?.count {
                        if count % 9 == 0 {
                            self?.pageControl.numberOfPages = count / 9
                        } else {
                            let page =  (count / 9) + 1
                            self?.pageControl.numberOfPages = page
                        }
                    }
                    self?.collectionViewCategory.reloadData()
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            case .noDataFound(_):
                break
            }
        }
    }
}

//                if let list: CategoryList = self?.handleSuccess(data: data) {
//                    self?.categoryList = list
//                    if let count = self?.categoryList?.data?.count {
//                        if count % 9 == 0 {
//                            self?.pageControl.numberOfPages = count / 9
//                        } else {
//                            let page =  (count / 9) + 1
//                            self?.pageControl.numberOfPages = page
//                        }
//                    }
//                }
