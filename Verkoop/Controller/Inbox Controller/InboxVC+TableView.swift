//
//  InboxVC+TableView.swift
//  Verkoop
//
//  Created by Vijay on 10/05/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

extension InboxVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchResultController.sections, sections.count > 0 {
            let sectionInfo = sections[section]
            return  sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let lastChat = self.fetchResultController.object(at: indexPath) as! LastChat
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.ChatListTableCell) as! ChatListTableCell
        cell.setData(lastChat: lastChat)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatVC = ChatVC.instantiate(fromAppStoryboard: .chat)
        if let lastChat = fetchResultController.object(at: indexPath) as? LastChat , let senderId = lastChat.senderId, let receiverId = lastChat.receiverId {
            let receiverId = senderId == Constants.sharedUserDefaults.getUserId() ? receiverId : senderId
            let doubleTime = Double(lastChat.timeStamp)
            let date = Date(timeIntervalSince1970: doubleTime/1000)
            let formatter = DateFormatter()
            formatter.locale = .current
            formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
            formatter.timeZone = TimeZone(abbreviation: "UTC")
            let dateString = Utilities.sharedUtilities.getTimeDifference(dateString: formatter.string(from: date))
            let info = ["item_id": String.getString(lastChat.itemId),
                        "otherUserId": receiverId ,
                        "username":lastChat.username ?? "",
                        "profile_pic":lastChat.profilePhoto ?? "",
                        "product_name":lastChat.item_name ?? "",
                        "product_pic":lastChat.productImage ?? "",
                        "price":String.getString(lastChat.item_price),
                        "created_at":dateString,
                        "offer_price": String.getString(lastChat.offer_price),
                        "min_price": String.getString(lastChat.min_price),
                        "max_price": String.getString(lastChat.max_price)]
            chatVC.info = info
            if String.getString(lastChat.userId) == Constants.sharedUserDefaults.getUserId() {
                chatVC.isMyItem = true
                if lastChat.is_sold == 1 {
                    if lastChat.offer_status == 1 {
                        //Sold to this user [user id in this object]
                        if lastChat.is_rate == 1 {
                            //Using this case but it means that user has already rate other user
                            chatVC.offerStatusType = .itemSoldToOther
                        } else {
                            chatVC.offerStatusType = .offerAccepted
                        }
                    } else {
                        //Sold To other user
                        chatVC.offerStatusType = .itemSoldToOther
                    }
                } else {
                    if lastChat.offer_status == 0 {
                        //Offer Made by this user
                        chatVC.offerStatusType = .offerMade
                    } else {
                        //No Action or offer Declined
                        chatVC.offerStatusType = .noActionPerform
                    }
                }
            } else {
                if lastChat.is_sold == 1 {
                    if lastChat.offer_status == 1 {
                        //Sold to me
                        if lastChat.is_rate == 1 {
                            //Using this case but it means that user has already rate other user
                            chatVC.offerStatusType = .itemSoldToOther
                        } else {
                            chatVC.offerStatusType = .itemSoldToMe
                        }
                    } else {
                        //Sold To other user
                        chatVC.offerStatusType = .itemSoldToOther
                    }
                } else {
                    if lastChat.offer_status == 0 {
                        //Offer Made by me
                        chatVC.offerStatusType = .offerMade
                    } else {
                        //No Action performed or offer Declined by Seller
                        chatVC.offerStatusType = .noActionPerform
                    }
                    //One Condition maybe missing from web end Check why status is 5
                    //Because User has already made the offer, but not yet accepted
                }
            }
            if lastChat.category_id == 85 {
                chatVC.itemType = .car
            } else if lastChat.category_id == 24 {
                chatVC.itemType = .property
            } else {
                chatVC.itemType = .generic
            }
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(chatVC, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let lastChat = self.fetchResultController.object(at: indexPath) as! LastChat
        if lastChat.offer_status == 5 {
            return 90
        }
        return 130
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            let alertController = UIAlertController(title:"Delete Chat", message: "Are you sure you want to delete this chat?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: Titles.ok, style: .default, handler: { (action) in
                self.deleteChat(lastChat: self.fetchResultController.object(at: editActionsForRowAt) as! LastChat)
            })
            let cancelAction = UIAlertAction(title: Titles.cancel, style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            alertController.view.tintColor = .darkGray
            OperationQueue.main.addOperation {
                self.present(alertController, animated: true, completion: nil)
            }
        }
        delete.backgroundColor = kAppDefaultColor
        
        let archive = UITableViewRowAction(style: .normal, title: "Archive") { action, index in
            let alertController = UIAlertController(title:"Archive Chat", message: "Are you sure you want to archive this chat?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: Titles.ok, style: .default, handler: { (action) in
                self.archiveChat(lastChat: self.fetchResultController.object(at: editActionsForRowAt) as! LastChat)
            })
            let cancelAction = UIAlertAction(title: Titles.cancel, style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            alertController.view.tintColor = .darkGray
            OperationQueue.main.addOperation {
                self.present(alertController, animated: true, completion: nil)
            }
        }
        archive.backgroundColor = .lightGray
        return [archive, delete]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

