
//
//  AddSelectCategoryVC+TableView.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 05/02/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation
import UIKit

extension AddSelectCategoryVC : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categoryList?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedSection == section {
            return categoryList?.data?[section].sub_category?.count ?? 0
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = categoryList?.data?[indexPath.section].sub_category?[indexPath.row]
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel!.text = data?.name
        cell.indentationLevel = 1
        cell.backgroundColor = UIColor.getRGBColor(240, g: 240, b: 240)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerData = categoryList?.data?[section].name
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: ReuseIdentifier.addDetailHeaderView) as? AddDetailHeaderView
        view?.buttonHeader.setTitle(headerData, for: .normal)
        view?.buttonHeader.backgroundColor = UIColor.white
        view?.buttonHeader.tag = section
        view?.buttonHeader.addTarget(self, action: #selector(buttonHeaderAction), for: .touchUpInside)
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = categoryList?.data?[indexPath.section].sub_category?[indexPath.row]
        let parent = categoryList?.data?[indexPath.section]
        let subCategory = parent?.sub_category![indexPath.row]
        tableView.beginUpdates()
        if let delegateObject = delegate {
            if let categoryID = parent?.id , let subCategoryId = subCategory?.id {
                if categoryID == 85 {
                    delegateObject.didCategorySelected?(id: (data?.id)!, categoryName: (data?.name)!, parent_name: (parent?.name)!, type: 1)
                    delay(time: 0.1) {
                        self.dismiss(animated: false, completion: nil)
                    }
                } else if categoryID == 24 {
                    if subCategoryId == 103 {
                        delegateObject.didCategorySelected?(id: (data?.id)!, categoryName: (data?.name)!, parent_name: (parent?.name)!, type: 3)
                    } else {
                        delegateObject.didCategorySelected?(id: (data?.id)!, categoryName: (data?.name)!, parent_name: (parent?.name)!, type: 2)
                    }
                    delay(time: 0.1) {
                        self.dismiss(animated: false, completion: nil)
                    }
                } else {
                    delegateObject.didCategorySelected?(id: (data?.id)!, categoryName: (data?.name)!, parent_name: (parent?.name)!, type: 0)
                    delay(time: 0.1) {
                        self.dismiss(animated: false, completion: nil)
                    }
                }
            }
        }
    }
    
    @objc func buttonHeaderAction(sender: UIButton!) {
        if selectedSection == sender.tag {
            let index = selectedSection
            selectedSection = -1
            tableAddSelectCategory.reloadSections(IndexSet(arrayLiteral: index), with: .automatic)
        } else {
            if selectedSection == -1 {
                selectedSection = sender.tag
                tableAddSelectCategory.reloadSections(IndexSet(arrayLiteral: selectedSection), with: .automatic)
            } else {
                let previousIndex = selectedSection
                selectedSection = sender.tag
                tableAddSelectCategory.reloadSections(IndexSet(arrayLiteral: selectedSection, previousIndex), with: .automatic)
            }
        }
    }
}
