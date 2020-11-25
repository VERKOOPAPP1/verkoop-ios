//
//  PurchaseCoinsVC.swift
//  Verkoop
//
//  Created by Vijay on 30/05/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class PurchaseCoinsVC: UIViewController {
    
    @IBOutlet weak var planCollectionView: UICollectionView!
    
    var planData: TransactionHistory?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPlan()
    }
    
    func initialSetup() {
        DispatchQueue.main.async {
            self.planCollectionView.register(UINib(nibName: ReuseIdentifier.BuyPackageCell, bundle: nil), forCellWithReuseIdentifier: ReuseIdentifier.BuyPackageCell)
            self.planCollectionView.delegate = self
            self.planCollectionView.dataSource = self
        }
    }
}

