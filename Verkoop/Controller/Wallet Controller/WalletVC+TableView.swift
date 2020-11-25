//
//  WalletVC+TableView.swift
//  Verkoop
//
//  Created by Vijay on 28/05/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit
extension WalletVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionHistory?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:  ReuseIdentifier.TransactionHistoryCell, for: indexPath) as? TransactionHistoryCell else {
            return UITableViewCell()
        }
        cell.dataModel = transactionHistory?.data![indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
