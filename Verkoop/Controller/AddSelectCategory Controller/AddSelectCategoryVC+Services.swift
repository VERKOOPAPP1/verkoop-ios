//
//  AddSelectCategoryVC+Services.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 14/02/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

extension AddSelectCategoryVC {
    
    func requestServer() {
        let endPoint = MethodName.getCategories
        ApiManager.request(path:endPoint, parameters: nil, methodType: .get) { [weak self](result) in
            switch result {
            case .success(let data):
                self?.handleSuccess(data: data)
            case .failure(let error):
                self?.handleFailure(error: error)
                self?.viewAddCategoryCard.isHidden = false
            case .noDataFound(_):
                break
            }
        }
    }
    
    func handleSuccess(data: Any) {
        if let data = data as? [String : Any] {
            do {
                let data = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                let decoder = JSONDecoder()
                do {
                    categoryList = try decoder.decode(CategoryList.self, from: data)
                    viewAddCategoryCard.isHidden = false
                    tableAddSelectCategory.reloadData()
                } catch {
                    Console.log(error.localizedDescription)
                    dismiss(animated: true, completion: nil)
                    DisplayBanner.show(message: ErrorMessages.somethingWentWrong)
                }
            } catch {
                Console.log(error.localizedDescription)
                dismiss(animated: true, completion: nil)
                DisplayBanner.show(message: ErrorMessages.somethingWentWrong)
            }
        } else {
            dismiss(animated: true, completion: nil)
            DisplayBanner.show(message: ErrorMessages.somethingWentWrong)
        }
    }
}


