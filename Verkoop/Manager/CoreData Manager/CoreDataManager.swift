//
//  DatabaseManager.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 08/05/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager: NSObject {
    class func insertChats(objects:[[String:Any]]) {
        if objects.count == 0 { return }
        Console.log(objects)
        for object in objects {
            let chat = NSEntityDescription.insertNewObject(forEntityName: "Chat", into: CoreDataStack.shared.persistentContainer.viewContext) as! Chat
            chat.messageId = (object["message_id"] as AnyObject).int64Value
            chat.message = String.getString(object["message"])
            chat.senderId = String.getString(object["sender_id"])
            chat.receiverId = String.getString(object["receiver_id"])
            chat.isRead = (object["is_read"] as AnyObject).int64Value == 1 ? false : true
            chat.messageType = String.getString(object["type"])
            chat.timeStamp = (object["timestamp"] as AnyObject).int64Value
            chat.chat_user_id = (object["chat_user_id"] as AnyObject).int64Value
            chat.itemId = (object["item_id"] as AnyObject).int64Value
        }        
        CoreDataStack.shared.saveContext()
    }
    
    class func insertLastChats(objects:[[String:Any]]) {
        if objects.count == 0 { return }
        for object in objects {
            if let lastChat = CoreDataManager.lastChatExists(senderId: String.getString(object["sender_id"]), receiverId: String.getString(object["receiver_id"]), itemId: Int.getInt(object["item_id"])) {
                CoreDataManager.lastChat(lastChat: lastChat, object: object)
            } else {
                let lastChat = NSEntityDescription.insertNewObject(forEntityName: "LastChat", into: CoreDataStack.shared.persistentContainer.viewContext) as! LastChat
                CoreDataManager.lastChat(lastChat: lastChat, object: object)
            }
        }
        CoreDataStack.shared.saveContext()
    }
    
    //Coming from single message read
    class func addUpdateLastChat(chat:[String:Any], onChatScreenWithSameUser:Bool = false) {
        if let lastChat = CoreDataManager.lastChatExists(senderId: String.getString(chat["sender_id"]), receiverId: String.getString(chat["receiver_id"]), itemId: Int.getInt(chat["item_id"])) {
            lastChat.messageId = (chat["message_id"] as AnyObject).int64Value
            lastChat.message = (chat["message"] as AnyObject).stringValue
            lastChat.messageType = (chat["message_id"] as AnyObject).stringValue
            lastChat.timeStamp = (chat["timestamp"] as AnyObject).int64Value
            lastChat.dateString = CoreDataManager.getMessageDate(timestamp: lastChat.timeStamp) as NSDate?
            lastChat.isBlock = false
            if onChatScreenWithSameUser {
                lastChat.unreadCount = 0
            } else {
                lastChat.unreadCount += 1
            }
        } else {
            let lastChat = NSEntityDescription.insertNewObject(forEntityName: "LastChat", into: CoreDataStack.shared.persistentContainer.viewContext) as! LastChat
            lastChat.messageId = (chat["message_id"] as AnyObject).int64Value
            lastChat.message = (chat["message"] as AnyObject).stringValue
            lastChat.profilePhoto = (chat["message_id"] as AnyObject).stringValue
            lastChat.messageType = (chat["message_id"] as AnyObject).stringValue
            lastChat.timeStamp = (chat["timestamp"] as AnyObject).int64Value
            lastChat.dateString = CoreDataManager.getMessageDate(timestamp: lastChat.timeStamp) as NSDate?
            lastChat.username = (chat["message_id"] as AnyObject).stringValue
            lastChat.senderId = (chat["sender_id"] as AnyObject).stringValue
            lastChat.receiverId = (chat["receiver_id"] as AnyObject).stringValue
            lastChat.isBlock = false
            if onChatScreenWithSameUser {
                lastChat.unreadCount = 0
            } else {
                lastChat.unreadCount += 1
            }
        }
        CoreDataStack.shared.saveContext()
    }
    
    class func lastChat(lastChat:LastChat, object:[String: Any]) {
        lastChat.userId = (object["user_id"] as AnyObject).int64Value
        lastChat.itemId = (object["item_id"] as AnyObject).int64Value
        lastChat.is_delete = (object["profile_pic"] as AnyObject).int64Value
        lastChat.is_sold = (object["is_sold"] as AnyObject).int64Value
        lastChat.productImage = String.getString(object["url"])
        lastChat.offer_status = (object["offer_status"] as AnyObject).int64Value
        lastChat.item_name = String.getString(object["item_name"])
        lastChat.chat_user_id = (object["chat_user_id"] as AnyObject).int64Value
        lastChat.is_archive = (object["is_archive"] as AnyObject).int64Value
        lastChat.messageId = (object["message_id"] as AnyObject).int64Value
        lastChat.message = String.getString(object["message"])
        lastChat.profilePhoto = String.getString(object["profile_pic"])
        lastChat.senderId = String.getString(object["sender_id"])
        lastChat.receiverId = String.getString(object["receiver_id"])
        lastChat.messageType = String.getString(object["types"])
        lastChat.timeStamp = (object["timestamp"] as AnyObject).int64Value
        lastChat.username = String.getString(object["username"])
        lastChat.unreadCount = (object["unread_count"] as AnyObject).int16Value
        lastChat.item_price = (object["item_price"] as AnyObject).int64Value
        lastChat.offer_price = (object["offer_price"] as AnyObject).int64Value
        lastChat.is_rate = (object["is_rate"] as AnyObject).int16Value
        lastChat.category_id = (object["category_id"] as AnyObject).int16Value
        lastChat.min_price = (object["min_price"] as AnyObject).int32Value
        lastChat.max_price = (object["max_price"] as AnyObject).int32Value
//        lastChat.dateString = CoreDataManager.getMessageDate(timestamp: lastChat.timeStamp) as NSDate?\
//        lastChat.isBlock = (object[""] as AnyObject).int64Value        
    }
    
    class func addUpdateChatInDB(object:[String: Any]) {
        let chat = NSEntityDescription.insertNewObject(forEntityName: "Chat", into: CoreDataStack.shared.persistentContainer.viewContext) as! Chat
        chat.messageId = (object["message_id"] as AnyObject).int64Value
        chat.message = String.getString(object["message"])
        chat.messageType = String.getString(object["type"])
        chat.timeStamp = (object["timestamp"] as AnyObject).int64Value
        chat.senderId = String.getString(object["sender_id"])
        chat.receiverId = String.getString(object["receiver_id"])
        chat.itemId = (object["item_id"] as AnyObject).int64Value
        chat.isRead = true
        CoreDataStack.shared.saveContext()
    }
    
    class func archiveChat(object:[String: Any]) {
        let fetchRequest:NSFetchRequest<LastChat> = LastChat.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "((senderId == %@ AND receiverId == %@) OR (senderId == %@ AND receiverId == %@)) AND itemId == %i", String.getString(object["sender_id"]), String.getString(object["receiver_id"]), String.getString(object["receiver_id"]), String.getString(object["sender_id"]), Int.getInt(object["item_id"]))
        do {
            let lastChats = try CoreDataStack.shared.persistentContainer.viewContext.fetch(fetchRequest)
            if let lastChat = lastChats.first {
                lastChat.is_archive = 1
            }
            CoreDataStack.shared.saveContext()
        } catch let error as NSError {
            debugPrint(error.localizedDescription)
        }
    }
    
    class func unarchiveChat(object:[String: Any]) {
        let fetchRequest:NSFetchRequest<LastChat> = LastChat.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "((senderId == %@ AND receiverId == %@) OR (senderId == %@ AND receiverId == %@)) AND itemId == %i", String.getString(object["sender_id"]), String.getString(object["receiver_id"]), String.getString(object["receiver_id"]), String.getString(object["sender_id"]), Int.getInt(object["item_id"]))
        do {
            let lastChats = try CoreDataStack.shared.persistentContainer.viewContext.fetch(fetchRequest)
            if let lastChat = lastChats.first {
                lastChat.is_archive = 0
            }
            CoreDataStack.shared.saveContext()
        } catch let error as NSError {
            debugPrint(error.localizedDescription)
        }
    }

    class func  deleteChat(object:[String: Any]) {
        let fetchRequest:NSFetchRequest<LastChat> = LastChat.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "((senderId = %@ AND receiverId = %@) OR (senderId = %@ AND receiverId = %@)) AND itemId == %i", String.getString(object["sender_id"]), String.getString(object["receiver_id"]), String.getString(object["receiver_id"]), String.getString(object["sender_id"]), Int.getInt(object["item_id"]))
        do {
            let fetchedResults =  try CoreDataStack.shared.persistentContainer.viewContext.fetch(fetchRequest)
            for result in fetchedResults {
                CoreDataStack.shared.persistentContainer.viewContext.delete(result)
            }
            CoreDataStack.shared.saveContext()
        } catch let error {
            Console.log(error.localizedDescription)
        }
    }
    
    class func updateUnreadBadge(userId:String) {
//        if let lastChat = CoreDataManager.lastChatExists(userId: userId) {
//            lastChat.unreadCount = 0
//        }
//        CoreDataStack.shared.saveContext()
    }
    
    class func getMessageDate(timestamp:Int64) -> Date {
        let doubleTime = Double(timestamp)
        let lastMessageDate = Date(timeIntervalSince1970: doubleTime/1000)
        return lastMessageDate
    }

    class func lastChatExists(senderId: String, receiverId: String, itemId: Int) -> LastChat? {
        let fetchRequest:NSFetchRequest<LastChat> = LastChat.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "((senderId == %@ AND receiverId == %@) OR (senderId == %@ AND receiverId == %@)) AND itemId == %i", senderId, receiverId, receiverId, senderId, itemId)
        do {
            let lastChat = try CoreDataStack.shared.persistentContainer.viewContext.fetch(fetchRequest)
            return lastChat.first
        } catch let error as NSError {
            debugPrint(error.localizedDescription)
        }
        return nil
    }
    
    class func getChats(fetchedResultsController:NSFetchedResultsController<NSFetchRequestResult>, _ completionHandler:@escaping (_ success:Bool, _ error:NSError?) -> Void) {
        
        fetchedResultsController.managedObjectContext.perform {
            do {
                try fetchedResultsController.performFetch()
                completionHandler(true, nil)
            } catch {
                completionHandler(false, error as NSError)
            }
        }
    }
    
    class func getLastChats(fetchedResultsController:NSFetchedResultsController<LastChat>, _ completionHandler:@escaping (_ success:Bool, _ error:NSError?) -> Void) {        
        fetchedResultsController.managedObjectContext.perform {
            do {
                try fetchedResultsController.performFetch()
                completionHandler(true, nil)
            } catch {
                completionHandler(false, error as NSError)
            }
        }
    }
    
    class func clearDB() {
        UIApplication.shared.applicationIconBadgeNumber = 0
        NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: nil)
        CoreDataManager.deleteAllRecords(in: "Chat")
        CoreDataManager.deleteAllRecords(in: "LastChat")
        Constants.sharedUserDefaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        SocketHelper.shared.disconnect()
    }
    
    class func clearChat() {
        CoreDataManager.deleteAllRecords(in: "Chat")
    }
    
    class func deleteAllRecords(in entity : String) {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            let result = try context.execute(deleteRequest) as? NSBatchDeleteResult
            let objectIdArray = result?.result as? [NSManagedObjectID]
            if let objectIdArray = objectIdArray {
                let changes = [NSDeletedObjectsKey : objectIdArray]
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
            }
        }
        catch {
            print (error.localizedDescription)
        }
    }
}

