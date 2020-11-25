//
//  CoinsHistoryVC.swift
//  Verkoop
//
//  Created by Vijay on 30/05/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class CoinsHistoryVC: UIViewController {
    
    @IBOutlet weak var historyTableView: UITableView!
    var transactionHistory: TransactionHistory?
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        requestCoinHistory()
        NotificationCenter.default.addObserver(self, selector: #selector(coinPurchased(_:)), name: NSNotification.Name(NotificationName.CoinPurchased), object: nil)
    }
    
    @objc func coinPurchased(_ notification: Notification) {
        requestCoinHistory(showLoader: false)
    }
    
    fileprivate func initialSetup() {
        DispatchQueue.main.async {
            self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
            self.refreshControl.addTarget(self, action: #selector(self.refreshData(_:)), for: UIControl.Event.valueChanged)
            self.historyTableView.addSubview(self.refreshControl)
            self.historyTableView.register(UINib(nibName: ReuseIdentifier.TransactionHistoryCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.TransactionHistoryCell)
        }
    }
    
    @objc fileprivate func refreshData(_ sender: AnyObject) {
        requestCoinHistory()
    }
}
