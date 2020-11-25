//
//  OtherUserProfileVC.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 03/04/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

class OtherUserProfileVC: UIViewController {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor(hexString: "#FAFAFA")
        cv.showsHorizontalScrollIndicator = false
        cv.isUserInteractionEnabled = true
        cv.isPrefetchingEnabled = true
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    let headerTitleLabel: UILabel = {
        $0.font = UIFont.kAppDefaultFontBold(ofSize: 18.0)
        $0.text = "Profile"
        $0.textColor = .white
        return $0
    }(UILabel())
    
    let headerView: UIView = {
        $0.backgroundColor = kAppDefaultColor
        return $0
    }(UIView())
    
    let backButton: UIButton = {
        $0.setImage(UIImage(named: "back"), for: .normal)
        return $0
    }(UIButton())
    
    let moreInfoButton: UIButton = {
        var image = UIImage(named: "more")?.rotateImage(degrees: CGFloat(Double.pi/2))
        image = image?.imageWithColor(.white)
        $0.setImage(image, for: .normal)
        return $0
    }(UIButton())
    
    var isUserBlocked = false
    var itemData: Item?
    var indices : [IndexPath] = []
    var userId = ""
    var userName = ""
    var isFollowAPIDataLoading = false
    var isBlockAPIDataLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        headerTitleLabel.text = userName.count > 0 ? userName : "User Profile"
        Constants.sharedAppDelegate.setSwipe(enabled: true, navigationController: navigationController)
    }
    
    fileprivate func initialSetup() {
        UIApplication.shared.statusBarView?.backgroundColor =  kAppDefaultColor
        view.backgroundColor = .white
        view.addSubview(headerView)
        view.addSubview(collectionView)
        headerView.addSubview(headerTitleLabel)
        headerView.addSubview(backButton)
        headerView.addSubview(moreInfoButton)
        
        headerView.addShadow(offset: CGSize(width: 5, height: 5), color: .darkGray, radius: 5, opacity: 0.5)
        headerView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(view.frame.height*0.12)
        }
        
        backButton.addTarget(self, action: #selector(backButtonAction(_:)), for: .touchUpInside)
        backButton.snp.makeConstraints { (make) in
            make.left.equalTo(5)
            make.top.equalTo(20)
            make.width.equalTo(40)
            make.bottom.equalTo(headerView.snp.bottom)
        }

        moreInfoButton.addTarget(self, action: #selector(moreInfoButtonAction(_:)), for: .touchUpInside)
        moreInfoButton.snp.makeConstraints { (make) in
            make.right.equalTo(-5)
            make.top.equalTo(20)
            make.width.equalTo(40)
            make.bottom.equalTo(headerView.snp.bottom)
        }

        headerTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(backButton.snp.right).offset(10)
            make.centerY.equalTo(backButton)
            make.right.equalTo(moreInfoButton.snp.left).offset(16)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(headerView.snp.bottom)
            make.bottom.equalTo(0)
        }
        collectionView.register(UINib(nibName: ReuseIdentifier.OthersProfileHeaderView, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ReuseIdentifier.OthersProfileHeaderView)
        collectionView.register(UINib(nibName: ReuseIdentifier.filterDetailCollectionCell, bundle: nil), forCellWithReuseIdentifier: ReuseIdentifier.filterDetailCollectionCell)
        headerTitleLabel.text = userName.count > 0 ? userName : "User Profile"
        collectionView.isHidden = true
        getUserProfile()
    }
    
    @objc func backButtonAction(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func moreInfoButtonAction(_ sender: UIButton) {
        let alertController = UIAlertController(title:nil, message: nil, preferredStyle: .actionSheet)      
        let blockUser = UIAlertAction(title: isUserBlocked ? Titles.unblockUser : Titles.blockUser, style: .default) { (action) in
            
            let alertVC = UIAlertController(title: self.isUserBlocked ? Titles.unblockUser : Titles.blockUser, message: self.isUserBlocked ? "Do you want to unblock this user?" : "Do you want to block this user?", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "YES", style: .default, handler: { (action) in
                if !self.isBlockAPIDataLoading {
                    self.isBlockAPIDataLoading = true
                    if self.isUserBlocked {
                        self.unblockUser(id: String.getString((self.itemData?.data?.block_id)))
                    } else {
                        self.blockUser()
                    }
                    self.isUserBlocked = !self.isUserBlocked
                }
            })
            let cancelButton = UIAlertAction(title: "NO", style: .default, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            })
            alertVC.addAction(okButton)
            alertVC.addAction(cancelButton)
            alertVC.view.tintColor = .darkGray
            DispatchQueue.main.async {
                self.present(alertVC, animated: true, completion: nil)
            }
        }
        
        let reportUser = UIAlertAction(title: Titles.reportUser, style: .default) { (action) in
            let reportView = CustomActionSheet(frame: self.view.frame)
            reportView.initializeSetup()
            reportView.delegate = self
            self.view.addSubview(reportView)
            reportView.reports = self.itemData?.data?.reports ?? []
            reportView.tableView.reloadData()
            self.delay(time: 0.05, completionHandler: {
                reportView.animateView(isAnimate: true)
            })
        }
        
        let cancelAction = UIAlertAction(title: Titles.cancel, style: .cancel, handler: nil)
        alertController.addAction(blockUser)
        alertController.addAction(reportUser)
        alertController.addAction(cancelAction)
        alertController.view.tintColor = .darkGray
        self.present(alertController, animated: true, completion: nil)
    }
}

