//
//  UserRatingVC+TableView.swift
//  Verkoop
//
//  Created by Vijay on 12/06/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

extension UserRatingVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userRating?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.UserRatingTableCell, for: indexPath) as? UserRatingTableCell else {
            return UITableViewCell()
        }
        let user = userRating?.data![indexPath.row]
        cell.setData(userRating: user!)
        cell.showProfileButton.tag = indexPath.row
        cell.showItemButton.tag = indexPath.row
        cell.showProfileButton.addTarget(self, action: #selector(showProfileDetailButtonAction(_:)), for: .touchUpInside)
        cell.showItemButton.addTarget(self, action: #selector(showItemDetailButtonAction(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    @objc func showProfileDetailButtonAction(_ sender: UIButton) {
        let userDetail = userRating?.data![sender.tag]
        if String.getString(userDetail?.user_id) != Constants.sharedUserDefaults.getUserId() {
            let profileVC = OtherUserProfileVC()
            profileVC.userId = String.getString(userDetail?.user_id)
            profileVC.userName = userDetail?.userName ?? ""
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(profileVC, animated: true)
            }
        }
    }
    
    @objc func showItemDetailButtonAction(_ sender: UIButton) {
        let userDetail = userRating?.data![sender.tag]
        let productVC = ProductDetailVC.instantiate(fromAppStoryboard: .categories)
        productVC.isItemSold = true
        productVC.isMyItem = String.getString(userDetail?.user_id) == Constants.sharedUserDefaults.getUserId()
        productVC.itemId = String.getString(userDetail?.item_id)
        productVC.delegate = self
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(productVC, animated: true)
        }
    }
}
