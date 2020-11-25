//
//  ActivityVC+TableView.swift
//  Verkoop
//
//  Created by Vijay Singh Raghav on 07/10/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

extension ActivityVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationModel?.data?.activities?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:  ReuseIdentifier.NotificationCell, for: indexPath) as? NotificationCell else {
            return UITableViewCell()
        }
        cell.notificationObject = notificationModel?.data?.activities![indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let count = notificationModel?.data?.activities?.count, count > 10 {
            if  count == indexPath.row - 1 {
//                loadMorenotification()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = notificationModel?.data?.activities![indexPath.row]
        if let type = object?.type {
            if type == 1 || type == 3 || type == 4 || type == 6 { //Item Detail
                let productVC = ProductDetailVC.instantiate(fromAppStoryboard: .categories)
                if type == 3 || type == 6 { //Like and Comment
                   productVC.isMyItem = true
                } else {
                    productVC.isMyItem = false
                }
//                productVC.isItemSold = true
//                productVC.isMyItem = String.getString(object?.user_id) == Constants.sharedUserDefaults.getUserId()
                productVC.itemId = String.getString(object?.item_id)
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(productVC, animated: true)
                }
            } else if type == 2 {// Others User Profile
                let profileVC = OtherUserProfileVC()
                profileVC.userId = String.getString(object?.user_id)
                profileVC.userName = ""
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(profileVC, animated: true)
                }
            } else  if type == 5 {//Wallet Screen
                let walletVC = WalletVC.instantiate(fromAppStoryboard: .advertisement)
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(walletVC, animated: true)
                }
            }
        }
    }
}
