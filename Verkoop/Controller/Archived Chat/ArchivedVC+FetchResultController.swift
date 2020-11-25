//
//  InboxVC+FetchResultController.swift
//  Verkoop
//
//  Created by Vijay on 10/05/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

import CoreData

extension ArchivedVC: NSFetchedResultsControllerDelegate {
    
    //MARK:- NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        chatListTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        chatListTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                chatListTableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = newIndexPath {
                if let lastChat = self.fetchResultController.object(at: indexPath)  as? LastChat, lastChat.is_archive == 0 {
                    chatListTableView.deleteRows(at: [indexPath], with: .left)
                } else {
                    chatListTableView.reloadRows(at: [indexPath], with: .none)
                }
            }
        case .move:
            if let indexPath = indexPath {
                chatListTableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                chatListTableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                chatListTableView.deleteRows(at: [indexPath], with: .automatic)
            }
        default:
            break;
        }
    }
}
