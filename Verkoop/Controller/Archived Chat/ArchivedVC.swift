//
//  InboxVC.swift
//  Verkoop
//
//  Created by Vijay on 10/05/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit
import CoreData

class ArchivedVC: UIViewController {
    
    @IBOutlet weak var chatListTableView: UITableView!
    
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
        getChats()
    }
    
    func lastchatFetchRequest() -> NSFetchRequest<LastChat> {
        let fetchRequest:NSFetchRequest<LastChat> = LastChat.fetchRequest()
    
        if itemId != "0" {
            fetchRequest.predicate = NSPredicate(format: "is_archive == %i AND itemId == %i", 1 as Int, Int.getInt(itemId))
        } else {
            fetchRequest.predicate = NSPredicate(format: "is_archive == %i", 1 as Int)
        }
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timeStamp", ascending: true)]
        return fetchRequest
    }
    
    //MARK:- IBAction
    //MARK:-
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func getChats() {
        CoreDataManager.getLastChats(fetchedResultsController: self.fetchResultController as! NSFetchedResultsController<LastChat>, { (success:Bool, error:Error?) in
            if success {
                DispatchQueue.main.async {
                    self.chatListTableView.reloadData()
                    self.chatListTableView.setContentOffset(.zero, animated: true)
                }
            }
        })
    }
    
    func unarchiveChat(lastChat: LastChat) {
        if SocketHelper.shared.socketStatus() == .connected {
            var params: [String:String] = [:]
            if Constants.sharedUserDefaults.getUserId() == lastChat.senderId {
                params = ["sender_id": lastChat.senderId ?? "", "receiver_id": lastChat.receiverId ?? "" , "item_id": String.getString(lastChat.itemId)]
            } else {
                params = ["sender_id": lastChat.receiverId ?? "", "receiver_id": lastChat.senderId ?? "" , "item_id": String.getString(lastChat.itemId)]
            }
            SocketHelper.shared.unarchiveChat(param: params)
        }
    }
}
