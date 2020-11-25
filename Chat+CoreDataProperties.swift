//
//  Chat+CoreDataProperties.swift
//  
//
//  Created by Vijay on 15/05/19.
//
//

import Foundation
import CoreData


extension Chat {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Chat> {
        return NSFetchRequest<Chat>(entityName: "Chat")
    }

    @NSManaged public var chat_user_id: Int64
    @NSManaged public var isRead: Bool
    @NSManaged public var message: String?
    @NSManaged public var messageId: Int64
    @NSManaged public var messageType: String?
    @NSManaged public var price: Int64
    @NSManaged public var receiverId: String?
    @NSManaged public var senderId: String?
    @NSManaged public var timeStamp: Int64
    @NSManaged public var itemId: Int64

}
