//
//  BannerListController.swift
//  Verkoop
//
//  Created by Vijay on 31/05/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class BannerListVC: UIViewController {

    @IBOutlet weak var bannerListTableView: UITableView!
    
    var refreshControl = UIRefreshControl()
    var transactionHistory: TransactionHistory?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        requestBannerList()
    }
    
    fileprivate func initialSetup() {
        DispatchQueue.main.async {
            self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
            self.refreshControl.addTarget(self, action: #selector(self.refreshData(_:)), for: UIControl.Event.valueChanged)
            self.bannerListTableView.addSubview(self.refreshControl)
            self.bannerListTableView.register(UINib(nibName: ReuseIdentifier.BannerListCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.BannerListCell)
            self.bannerListTableView.delegate = self
            self.bannerListTableView.dataSource = self
            NotificationCenter.default.addObserver(self, selector: #selector(self.refreshData(_:)), name: NSNotification.Name(NotificationName.BannerSubmited), object: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Constants.sharedAppDelegate.setSwipe(enabled: true, navigationController: navigationController)
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func refreshData(_ sender: AnyObject) {
        requestBannerList()
    }
    
    @IBAction func createBannerButtonAction(_ sender: UIButton) {
        let bannerVC = CreateBannerVC.instantiate(fromAppStoryboard: .advertisement)
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(bannerVC, animated: true)
        }
    }
}
