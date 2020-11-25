//
//  SocketHelper.swift
//  Mudarib
//
//  Created by Vijay's Macbook on 31/05/18.
//  Copyright © 2018 Mobilecoderz. All rights reserved.
//

import Foundation
import SocketIO

class SocketHelper: NSObject {
    
    static let shared = SocketHelper()
    var socket:SocketIOClient!
    var manager:SocketManager!
    
    private override init() {
        super.init()
        manager = SocketManager(socketURL: URL(string: ConfigurationManager.shared().socketEndPoint())!, config: [.log(false), .compress])
        socket = manager.defaultSocket
    }
    
    //MARK:- Socket Connections
    func connect() {
        if socketStatus() == .connected {
            return
        }
        self.openConnectEvent()
        self.socket.connect()
    }
    
    func disconnect() {
        Console.log("SOCKET DISCONNECTED")
        self.socket.disconnect()
    }
    
    //MARK:- Socket Status
    func socketStatus() -> SocketIOStatus {
        return self.socket.status
    }
    
    //MARK:- Mandatory Events
    func openConnectEvent() {
        socket.off(clientEvent: .connect)
        socket.on(clientEvent: .connect) { data, ack in
            self.initEvent()
        }
    }
    
    //MARK:- Custom Events
    //Initialize our existence to socket
    func initEvent() {
        self.socket.emitWithAck(SocketEvent.initEvent, ["user_id": Constants.sharedUserDefaults.getUserId()]).timingOut(after: 0.0, callback: { (data) in
            if let object = data[0] as? [String:AnyObject], data.count > 0, let status = object["status"] as? Int, status == 1 {
                Console.log("SOCKET CONNECTED")
                self.switchOnEvents()
            }
        })
    }
    
    func sendMessage(params:[String:Any]) {
        self.socket.emitWithAck(SocketEvent.sendMessages, params).timingOut(after: 0.0) { (data:[Any]) in
            if let object = self.handleObject(data: data), let status = object["status"] as? Int {
                Console.log(object)
                if status == 1 {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationName.UpdateOfferStatusType), object: nil, userInfo: ["type":  String.getString(object["type"])])
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationName.RefreshLastChat), object: nil, userInfo: [:])
                    CoreDataManager.addUpdateChatInDB(object: object)
                } else {
                    
                }
            }
        }
    }
    
    func receiveMessage() {
        self.socket.off(SocketEvent.receiveMessage)
        self.socket.on(SocketEvent.receiveMessage) { (data:[Any], ack:SocketAckEmitter) in
            if let object = self.handleObject(data: data) , let status = object["status"] as? Int {
                if status == 1 {
                    Console.log(object)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationName.UpdateOfferStatusType), object: nil, userInfo: ["type":  String.getString(object["type"])])
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationName.RefreshLastChat), object: nil, userInfo: [:])
                    CoreDataManager.addUpdateChatInDB(object: object)
                } else if status == 2 {
                    Console.log("Inconsistent Recevie Message")
                }
            }
        }
    }
    
    func offerEvent(params:[String:Any], socketEvent: String) {
        Console.log(params)
        self.socket.emitWithAck(socketEvent, params).timingOut(after: 0.0) { (data:[Any]) in
            if let object = self.handleObject(data: data) , let status = object["status"] as? Int {
                Console.log(object)
                if status == 1 {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationName.UpdateOfferStatusType), object: nil, userInfo: ["type":  String.getString(object["type"])])
                    CoreDataManager.addUpdateChatInDB(object: object)
                } else if status == 2 {
                    Console.log("Offer is Accepted by other")
                }
            }
        }
    }
    
    func readMessage(params:[String:Any]) {
        self.socket.emitWithAck("", with: [params]).timingOut(after: 0.0) { (data:[Any]) in
            if let json = self.handleObject(data: data) {
                print(json)
                self.unreadBadgeCount()
                //                if json[Constants.ServerKey.status].boolValue {
                ////                    CoreDataManager.updateUnreadBadge(userId: params[Constants.ServerKey.senderId] as! String)
                //                }
            }
        }
    }
    
    func getChatList(param: [String:Any]) {
        Console.log(param)
        socket.emitWithAck(SocketEvent.inboxList, param).timingOut(after: 0.0) { (data:[Any]) in
            if let json = self.handleObject(data: data), let status = json["status"] as? Int, status == 1, let chats = json["data"] as? [[String:AnyObject]] {
                Console.log(data)
                CoreDataManager.insertLastChats(objects: chats)
            }
        }
    }
    
    func archiveChat(param: [String:Any]) {
        socket.emitWithAck(SocketEvent.archiveChat, param).timingOut(after: 0.0) { (data:[Any]) in
            if let object = self.handleObject(data: data), let status = object["status"] as? Int, status == 1 {
                CoreDataManager.archiveChat(object: param)
            }
        }
    }
    
    func unarchiveChat(param: [String:Any]) {
        Console.log(param)
        socket.emitWithAck(SocketEvent.unarchiveChat, param).timingOut(after: 0.0) { (data:[Any]) in
            if let object = self.handleObject(data: data), let status = object["status"] as? Int, status == 1 {
                Console.log(data)
                CoreDataManager.unarchiveChat(object: param)
            }
        }
    }
    
    func deleteChat(param: [String:Any]) {
        Console.log(param)
        socket.emitWithAck(SocketEvent.deleteChat, param).timingOut(after: 0.0) { (data:[Any]) in
            if let object = self.handleObject(data: data), let status = object["status"] as? Int, status == 1 {
                Console.log(object)
                CoreDataManager.deleteChat(object: param)
            }
        }
    }
    
    func readAll(params:[String:Any]) {
        self.socket.emitWithAck("", with: [params]).timingOut(after: 0.0) { (data:[Any]) in
            if let json = self.handleObject(data: data) {
                print(json)
                self.unreadBadgeCount()
                //                if json[Constants.ServerKey.status].boolValue {
                //                    CoreDataManager.updateUnreadBadge(userId: params[Constants.ServerKey.senderId] as! String)
                //                }
            }
        }
    }
    
    func getLatestMessages(params: [String:Any]) {
        self.socket.emitWithAck(SocketEvent.getLatestChat , with: [params]).timingOut(after: 0.0) { (data:[Any]) in
            if let json = self.handleObject(data: data) , let status = json["status"] as? Int , status == 1 , let array = json["data"] as? [[String:AnyObject]] {
                Console.log(array)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationName.MakeOffer), object: nil, userInfo: ["status":  "1"])
                CoreDataManager.insertChats(objects: array)
            }
        }
    }
    
    //Helper to get the Chat user_id
    func getChatUserId(param: [String: String], completion: @escaping (_ status: Bool, _ chatUserId: String) -> (Void)) {
        self.socket.emitWithAck(SocketEvent.directChat, param).timingOut(after: 0.0) { (data:[Any]) in
            if let object = self.handleObject(data: data) , let status = object["status"] as? Int , status == 1 {
                Console.log("Chat UserId : \(object["chat_user_id"] ?? "NO USER ID")")
                completion(true, String.getString(object["chat_user_id"]))
            }
        }
    }
    
    //MARK:- On Events
    func switchOnEvents() {
        //This notification is sent just once find out why???
        NotificationCenter.default.post(name: NSNotification.Name("lastMessage"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("receiveChat"), object: nil)
        self.receiveMessage()
        //        self.unreadBadgeCount()
    }
    
    func unreadBadgeCount() {
        self.socket.emitWithAck("", [:]).timingOut(after: 0.0, callback: { (data) in
            if let json = self.handleObject(data: data) {
                print("unreadBadgeCount \(json)")
                //                kAppDelegate.unreadCounts = json
            }
        })
    }
    
    
    //MARK:- Private Methods
    private func handleObject(data:[Any]) -> [String:Any]? {
        if let object = data[0] as? [String:AnyObject], data.count > 0 {
            return object
        }
        return nil
    }
    
    //Single message coming and then saving to both the tables
    private func addUpdateDB(json:[String:Any], onChatScreenWithSameUser:Bool = false) {
        CoreDataManager.addUpdateChatInDB(object: json)
        CoreDataManager.addUpdateLastChat(chat: json as! [String : String], onChatScreenWithSameUser: onChatScreenWithSameUser)
    }
}
