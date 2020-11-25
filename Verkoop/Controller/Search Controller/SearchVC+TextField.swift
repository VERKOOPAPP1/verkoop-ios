//
//  SearchVC+TextField.swift
//  Verkoop
//
//  Created by Vijay on 10/04/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

extension SearchVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            if searchType == .item {
                //Pending as we do not get any ID
            } else if searchType == .user {
                getUserList(username: text)
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if searchType == .item {
            if let text = textField.text, let textRange = Range(range, in: text) {
                let updatedText = text.replacingCharacters(in: textRange, with: string)
                if !updatedText.isEmpty {
                    getItemList(searchString: updatedText)
                }
            }
        } else if searchType == .follower || searchType == .following {
            if let text = textField.text, let textRange = Range(range, in: text) {
                let updatedText = text.replacingCharacters(in: textRange, with: string)
                if !updatedText.isEmpty {
                    filteredUserData?.data = searchUserData?.data!.filter {
                        $0.username!.range(of: updatedText, options: [.diacriticInsensitive, .caseInsensitive]) != nil
                    }
                } else {
                    filteredUserData?.data = searchUserData?.data
                }
                OperationQueue.main.addOperation {
                    self.tableView.reloadData()
                }
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if searchType == .item, let item = searchItemData?.data?.first {
            DispatchQueue.main.async {
                let filterVC = CategoriesFilterVC.instantiate(fromAppStoryboard: .categories)
                filterVC.catgoryId = String.getString(item.category_id)
                filterVC.categoryName = item.category?.name ?? ""
                filterVC.type = Int.getInt(item.category?.id) == 0 ? "0" : "1"
                filterVC.item_id = String.getString(item.id)
                self.navigationController?.pushViewController(filterVC, animated: true)
            }
        }
        return true
    }
}
