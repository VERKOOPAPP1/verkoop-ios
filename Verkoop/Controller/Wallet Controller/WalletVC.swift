//
//  WalletVC.swift
//  Verkoop
//
//  Created by Vijay on 27/05/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class WalletVC: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var transactionTableView: UITableView!
    @IBOutlet weak var addMoneyButton: UIButton!
    
    var amount = ""
    var clientSecret = ""
    var backgroundQueue = DispatchQueue.global(qos: .background)
    var transactionHistory: TransactionHistory?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        requestWalletHistory()
    }
    
    fileprivate func initialSetup() {
        DispatchQueue.main.async {
            self.addMoneyButton.setRadius(self.addMoneyButton.frame.height / 2, kAppDefaultColor, 1.2)
            self.containerView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 6)
            self.containerView.addShadow(offset: CGSize(width: 1, height: 1), color: .black, radius: 3, opacity: 0.2)
            self.balanceLabel.attributedText = String.getAttributedString(value: "00")
            self.transactionTableView.register(UINib(nibName: ReuseIdentifier.TransactionHistoryCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.TransactionHistoryCell)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Constants.sharedAppDelegate.setSwipe(enabled: true, navigationController: navigationController)
    }
    
    @IBAction func addMoneyButton(_ sender: UIButton) {
        if let rateUserView = Bundle.main.loadNibNamed(ReuseIdentifier.AddMoneyPopup, owner: self, options: nil)?.first as? AddMoneyPopup {
            rateUserView.frame = view.frame
            rateUserView.delegate = self
            rateUserView.layoutIfNeeded()
            view.addSubview(rateUserView)
            rateUserView.animateView(isAnimate: true)
        }
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
}


/*
 let today = Date()
 let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)
 */
