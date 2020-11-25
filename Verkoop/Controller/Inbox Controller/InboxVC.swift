//
//  InboxVC.swift
//  Verkoop
//
//  Created by Vijay on 10/05/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit
import CoreData

class InboxVC: UIViewController {
    
    @IBOutlet weak var threeButtonContainerView: UIView!
    @IBOutlet weak var chatListTableView: UITableView!
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var buyingButton: UIButton!
    @IBOutlet weak var sellingButton: UIButton!
    
    var itemId = "0"
    var fetchResultController:NSFetchedResultsController<NSFetchRequestResult>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Constants.sharedAppDelegate.setSwipe(enabled: true, navigationController: navigationController)
    }
    
    fileprivate func initialSetup() {
        self.fetchResultController = (NSFetchedResultsController(fetchRequest: self.lastchatFetchRequest(), managedObjectContext: CoreDataStack.shared.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil) as! NSFetchedResultsController<NSFetchRequestResult>)
        self.fetchResultController.delegate = self
        chatListTableView.register(UINib(nibName: ReuseIdentifier.ChatListTableCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.ChatListTableCell)
        
        let buttonArray = [allButton,buyingButton,sellingButton]
        for (index, button) in buttonArray.enumerated() {
            let bottomLine = CALayer()
            bottomLine.frame = CGRect.init(x: 3, y: 41, width: allButton.frame.size.width - 6, height: 3)
            bottomLine.backgroundColor = index == 0 ? kAppDefaultColor.cgColor : UIColor.clear.cgColor
            button?.layer.addSublayer(bottomLine)
        }
        threeButtonContainerView.addShadow(offset: CGSize(width: 2, height: 2), color: .gray, radius: 4, opacity: 0.5)
        getChats()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshChats(_:)), name: NSNotification.Name(rawValue: NotificationName.RefreshLastChat), object: nil)
    }
    
    @objc func refreshChats(_ notification: Notification) {
        getChatList()
    }
    
    func lastchatFetchRequest() -> NSFetchRequest<LastChat> {
        let fetchRequest:NSFetchRequest<LastChat> = LastChat.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "is_archive == %i", Int64(0))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timeStamp", ascending: false)]
        return fetchRequest
    }
    
    //MARK:- IBAction
    //MARK:-
    
    @IBAction func archiveButtonAction(_ sender: Any) {
        let archiveVC = ArchivedVC.instantiate(fromAppStoryboard: .chat)
        archiveVC.itemId = itemId
        navigationController?.pushViewController(archiveVC, animated: true)
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func threeButtonAction(_ sender: UIButton) {
        allButton.layer.sublayers?.first?.backgroundColor = sender.tag == 0 ? kAppDefaultColor.cgColor : UIColor.clear.cgColor
        buyingButton.layer.sublayers?.first?.backgroundColor = sender.tag == 1 ? kAppDefaultColor.cgColor : UIColor.clear.cgColor
        sellingButton.layer.sublayers?.first?.backgroundColor = sender.tag == 2 ? kAppDefaultColor.cgColor : UIColor.clear.cgColor
        filterChat(chatType: sender.tag)
    }
    
    @objc func getChatList() {
        if SocketHelper.shared.socketStatus() == .connected {
            let params = ["sender_id": Constants.sharedUserDefaults.getUserId(), "item_id": itemId]
                as [String : String]
            SocketHelper.shared.getChatList(param: params)
        }
    }
    
    func getChats() {
        CoreDataManager.getLastChats(fetchedResultsController: self.fetchResultController as! NSFetchedResultsController<LastChat>, { (success:Bool, error:Error?) in
            if success {
                self.filterChat(chatType: 0, isRequestChat: true)
            }
        })
    }
    
    func archiveChat(lastChat: LastChat) {
        if SocketHelper.shared.socketStatus() == .connected {
            var params: [String:String] = [:]
            if Constants.sharedUserDefaults.getUserId() == lastChat.senderId {
                params = ["sender_id": lastChat.senderId ?? "", "receiver_id": lastChat.receiverId ?? "" , "item_id": String.getString(lastChat.itemId)]
            } else {
                params = ["sender_id": lastChat.receiverId ?? "", "receiver_id": lastChat.senderId ?? "" , "item_id": String.getString(lastChat.itemId)]
            }
            SocketHelper.shared.archiveChat(param: params)
        }
    }
    
    func deleteChat(lastChat: LastChat) {
        if SocketHelper.shared.socketStatus() == .connected {
            var params: [String:String] = [:]
            if Constants.sharedUserDefaults.getUserId() == lastChat.senderId {
                params = ["sender_id": lastChat.senderId ?? "", "receiver_id": lastChat.receiverId ?? "" , "item_id": String.getString(lastChat.itemId)]
            } else {
                params = ["sender_id": lastChat.receiverId ?? "", "receiver_id": lastChat.senderId ?? "" , "item_id": String.getString(lastChat.itemId)]
            }
            SocketHelper.shared.deleteChat(param: params)
        }
    }
    
    func filterChat(chatType: Int, isRequestChat: Bool = false) {
        if chatType == 0 {
            if itemId != "0" {
                fetchResultController.fetchRequest.predicate = NSPredicate(format: "is_archive == %i AND itemId == %i", Int64(0), Int.getInt(itemId))
            } else {
                fetchResultController.fetchRequest.predicate = NSPredicate(format: "is_archive == %i", Int64(0))
            }
        } else if chatType == 1 {
            if itemId != "0" {
                fetchResultController.fetchRequest.predicate = NSPredicate(format: "is_archive == %i AND userId != %@ AND itemId == %i", Int64(0), Constants.sharedUserDefaults.getUserId(), Int.getInt(itemId))
            } else {
                fetchResultController.fetchRequest.predicate = NSPredicate(format: "is_archive == %i AND userId != %@", Int64(0), Constants.sharedUserDefaults.getUserId())
            }
        } else if chatType == 2 {
            if itemId != "0" {
                fetchResultController.fetchRequest.predicate = NSPredicate(format: "is_archive == %i AND userId == %@ AND itemId == %i", Int64(0), Constants.sharedUserDefaults.getUserId(), Int.getInt(itemId))
            } else {
                fetchResultController.fetchRequest.predicate = NSPredicate(format: "is_archive == %i AND userId == %@", Int64(0), Constants.sharedUserDefaults.getUserId())
            }
        }
        do {
            try self.fetchResultController.performFetch()
            DispatchQueue.main.async {
                self.chatListTableView.reloadData()
                self.delay(time: 0.1, completionHandler: {
                    self.chatListTableView.setContentOffset(.zero, animated: true)
                })
            }
            if chatType == 0 && isRequestChat {
                self.getChatList()
            }
        } catch let error {
            Console.log(error.localizedDescription)
        }
    }
}
