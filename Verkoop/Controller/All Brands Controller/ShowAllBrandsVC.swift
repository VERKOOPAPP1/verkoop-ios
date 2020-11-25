//
//  ShowAllBrandsVC.swift
//  Verkoop
//
//  Created by Vijay on 30/04/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class ShowAllBrandsVC: UIViewController {

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor(hexString: "#EDEDED")
        cv.showsHorizontalScrollIndicator = false
        cv.isUserInteractionEnabled = true
        cv.isPrefetchingEnabled = true
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    let headerTitleLabel: UILabel = {
        $0.font = UIFont.kAppDefaultFontBold(ofSize: 18.0)
        $0.text = "Car Brands"
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
    
    var brands: [Category]?
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Constants.sharedAppDelegate.setSwipe(enabled: true, navigationController: navigationController)
    }
    
    fileprivate func initialSetup() {
        
        view.backgroundColor = .white
        view.addSubview(headerView)
        view.addSubview(collectionView)
        headerView.addSubview(headerTitleLabel)
        headerView.addSubview(backButton)
        
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
        
        headerTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(backButton.snp.right).offset(10)
            make.centerY.equalTo(backButton)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(headerView.snp.bottom)
            make.bottom.equalTo(0)
        }
        collectionView.register(AllBrandCell.self, forCellWithReuseIdentifier: ReuseIdentifier.AllBrandCell)
    }
    
    @objc func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
