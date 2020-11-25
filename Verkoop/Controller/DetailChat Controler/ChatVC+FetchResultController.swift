//
//  ChatVC+FetchResultController.swift
//  Verkoop
//
//  Created by Vijay on 09/05/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation
import CoreData

extension ChatVC: NSFetchedResultsControllerDelegate {
    
    //MARK:- NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        chatTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        chatTableView.endUpdates()
    }    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let ip = newIndexPath {
                chatTableView.insertRows(at: [ip], with: .bottom)
                sendButton.isEnabled = true
                sendButton.alpha = 1
                scrollToBottom(animated: true)
            }
        case .update:
            chatTableView.reloadRows(at: [indexPath!], with: .none)
        default:
            break;
        }
    }
}
