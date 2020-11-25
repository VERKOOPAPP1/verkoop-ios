//
//  BannerDetailVC.swift
//  Verkoop
//
//  Created by Vijay on 10/06/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class BannerDetailVC: UIViewController {

    @IBOutlet weak var bannerCollectionView: UICollectionView!
    
    var refreshControl = UIRefreshControl()
    var customPageControl : UIPageControl!
    var advertiseCollectionView : UICollectionView!
    let dummyCount = 3
    var timer: Timer?
    var timerStarted = false
    var pageIndex = 1
    var bannerData: BannerData?
    var indices : [IndexPath] = []
    var bannerId = ""
    var userId = ""
    
    var cellWidth: CGFloat {
        return  kScreenWidth
    }
    
    var totalContentWidth: CGFloat {
        if let count = bannerData?.data?.banner?.count {
            return  CGFloat(count * dummyCount) * cellWidth
        } else {
            return cellWidth
        }
    }
    
    //MARK:- Life Cycle Delegates
    //MARK:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startTimer()
        Constants.sharedAppDelegate.setSwipe(enabled: true, navigationController: navigationController)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.invalidate()
        timerStarted = false
    }
    
    //MARK:- Private Methods
    //MARK:-
    
    fileprivate func initialSetup() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: UIControl.Event.valueChanged)
        bannerCollectionView.addSubview(refreshControl)
        bannerCollectionView.tag = 1
        bannerCollectionView.register(UINib(nibName: ReuseIdentifier.adsCollectionCell, bundle: nil), forCellWithReuseIdentifier: ReuseIdentifier.adsCollectionCell)
        bannerCollectionView.register(UINib(nibName: ReuseIdentifier.filterDetailCollectionCell, bundle: nil), forCellWithReuseIdentifier: ReuseIdentifier.filterDetailCollectionCell)
        requestBannerDetail()
    }
    
    @objc func refreshData(_ sender: AnyObject) {
        pageIndex = 1
        requestBannerDetail()
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
