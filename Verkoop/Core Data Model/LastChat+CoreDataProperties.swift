//
//  LastChat+CoreDataProperties.swift
//  
//
//  Created by Vijay Singh Raghav on 29/08/19.
//
//

import Foundation
import CoreData


extension LastChat {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LastChat> {
        return NSFetchRequest<LastChat>(entityName: "LastChat")
    }

    @NSManaged public var category_id: Int16
    @NSManaged public var chat_user_id: Int64
    @NSManaged public var dateString: NSDate?
    @NSManaged public var is_archive: Int64
    @NSManaged public var is_delete: Int64
    @NSManaged public var is_rate: Int16
    @NSManaged public var is_sold: Int64
    @NSManaged public var isBlock: Bool
    @NSManaged public var item_name: String?
    @NSManaged public var item_price: Int64
    @NSManaged public var itemId: Int64
    @NSManaged public var max_price: Int32
    @NSManaged public var message: String?
    @NSManaged public var messageId: Int64
    @NSManaged public var messageType: String?
    @NSManaged public var min_price: Int32
    @NSManaged public var offer_price: Int64
    @NSManaged public var offer_status: Int64
    @NSManaged public var productImage: String?
    @NSManaged public var profilePhoto: String?
    @NSManaged public var receiverId: String?
    @NSManaged public var senderId: String?
    @NSManaged public var timeStamp: Int64
    @NSManaged public var unreadCount: Int16
    @NSManaged public var userId: Int64
    @NSManaged public var username: String?

}
