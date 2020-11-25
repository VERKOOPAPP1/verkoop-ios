//
//  ChatVC+TableView.swift
//  Verkoop
//
//  Created by Vijay on 08/05/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchResultController.sections, sections.count > 0 {
            let sectionInfo = sections[section]
            return  sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chat = self.fetchResultController.object(at: indexPath)
        if let chatObject = chat as? Chat {
            if chatObject.senderId == Constants.sharedUserDefaults.getUserId()  {
                //Is Mine message
                if chatObject.messageType == "2" || chatObject.messageType == "3" || chatObject.messageType == "4" || chatObject.messageType == "5" {
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.SenderOfferTableCell) as! SenderOfferTableCell
                    cell.setData(chat: chatObject)
                    return cell
                } else if chatObject.messageType == "0" {
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.SenderMessageTableCell) as! SenderMessageTableCell
                    cell.setData(chat: chatObject)
                    return cell
                } else if chatObject.messageType == "1" {
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.SenderImageTableCell) as! SenderImageTableCell
                    cell.setData(chat: chatObject)
                    return cell
                } else if chatObject.messageType == "6" {
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.SenderRateTableCell) as! SenderRateTableCell
                    cell.setData(chatObject: chatObject)
                    return cell
                }
                return UITableViewCell()
            } else {
                //Is other message
                if chatObject.messageType == "2" || chatObject.messageType == "3" || chatObject.messageType == "4" || chatObject.messageType == "5" {
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.ReceiverOfferTableCell) as! ReceiverOfferTableCell
                    cell.setData(chat: chatObject)
                    return cell
                } else if chatObject.messageType == "0" {
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.ReceiverMessageTableCell) as! ReceiverMessageTableCell
                    cell.setData(chat: chatObject)
                    return cell
                } else if chatObject.messageType == "1" {
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.ReceiverImageTableCell) as! ReceiverImageTableCell
                    cell.setData(chat: chatObject)
                    return cell
                } else if chatObject.messageType == "6" {
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.ReceiverRateTableCell) as! ReceiverRateTableCell
                    cell.setData(chatObject: chatObject, name: info["username"]!)
                    return cell
                }

            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let chat = self.fetchResultController.object(at: indexPath)
        if let chatObject = chat as? Chat {
            if chatObject.messageType == "1" {
                return kScreenHeight * 0.35 > 233.45 ? 233.45 : kScreenHeight * 0.35
            }
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chat = self.fetchResultController.object(at: indexPath)
        if let chatObject = chat as? Chat {
            if chatObject.messageType == "1" {
                
            }
        }
    }
}
