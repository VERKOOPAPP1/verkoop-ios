//
//  SelectPackageVC.swift
//  Verkoop
//
//  Created by Vijay on 27/05/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class SelectPackageVC: UIViewController {

    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var packageCollectionView: UICollectionView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var balancContainerView: UIView!
    
    var categoryId = ""
    var bannerImage: UIImage!
    var bannerId = ""
    var advertisementData: TransactionHistory?
    weak var delegate: RenewBannerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        getAdvertisementPlan()
    }
    
    fileprivate func initialSetup() {
        DispatchQueue.main.async {
            self.balancContainerView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 6)
            self.balancContainerView.addShadow(offset: CGSize(width: 1, height: 1), color: .black, radius: 3, opacity: 0.2)
            self.balanceLabel.text = "00"
            self.packageCollectionView.register(UINib(nibName: ReuseIdentifier.BuyPackageCell, bundle: nil), forCellWithReuseIdentifier: ReuseIdentifier.BuyPackageCell)
            self.packageCollectionView.delegate = self
            self.packageCollectionView.dataSource = self
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Constants.sharedAppDelegate.setSwipe(enabled: true, navigationController: navigationController)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
