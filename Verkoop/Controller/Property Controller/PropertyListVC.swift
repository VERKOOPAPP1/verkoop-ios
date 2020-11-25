//
//  PropertyListVC.swift
//  Verkoop
//
//  Created by Vijay on 19/04/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class PropertyListVC: UIViewController {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 0.0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.tag = 100
        cv.delegate = self
        cv.dataSource = self
        cv.isPrefetchingEnabled = true
        cv.isUserInteractionEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = UIColor(hexString: "#FAFAFA")
        return cv
    }()
    
    let headerView: UIView = {
        $0.backgroundColor = kAppDefaultColor
        return $0
    }(UIView())
    
    let headerTitleLabel: UILabel = {
        $0.font = UIFont.kAppDefaultFontBold(ofSize: 18.0)
        $0.text = "Sale"
        $0.textColor = .white
        return $0
    }(UILabel())
    
    let backButton: UIButton = {
        $0.setImage(UIImage(named: "back"), for: .normal)
        $0.addTarget(self, action: #selector(backButtonAction(_:)), for: .touchUpInside)
        return $0
    }(UIButton())
    
    let chatButton: UIButton = {
        $0.setImage(UIImage(named: "chat"), for: .normal)
        $0.addTarget(self, action: #selector(chatButtonAction(_:)), for: .touchUpInside)
        return $0
    }(UIButton())
    
    let favouriteButton: UIButton = {
        $0.setImage(UIImage(named: "favourites"), for: .normal)
        $0.addTarget(self, action: #selector(favouriteButtonAction(_:)), for: .touchUpInside)
        return $0
    }(UIButton())
    
    let sellButton: UIButton = {
        $0.setTitle("SELL", for: .normal)
        $0.backgroundColor = kAppDefaultColor
        $0.addTarget(self, action: #selector(sellButtonAction(_:)), for: .touchUpInside)
        return $0
    }(UIButton())
    
    lazy var searchField: UITextField = {
        $0.placeholder = "Property"
        $0.font = UIFont.kAppDefaultFontRegular(ofSize: 16.0)
        $0.backgroundColor = .white
        $0.makeRoundCorner(4)
        $0.delegate = self
        return $0
    }(UITextField())
    
    var propertyData: CarModel?
    var indices : [IndexPath] = []
    
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
        view.addSubview(collectionView)
        view.addSubview(headerView)
        view.addSubview(sellButton)
        headerView.addSubview(backButton)
        headerView.addSubview(chatButton)
        headerView.addSubview(searchField)
        headerView.addSubview(favouriteButton)
        headerView.addSubview(headerTitleLabel)
        
        headerView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.topMargin)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.height.equalTo(100)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom).offset(-1)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.snp.bottom)
        }
        
        sellButton.snp.makeConstraints { (make) in
            make.width.equalTo(120)
            make.height.equalTo(50)
            make.centerX.equalTo(view.snp.centerX)
            make.bottom.equalTo(view.snp.bottomMargin).offset(-35)
        }
        sellButton.setRadius(25, .white, 3)
        
        searchField.setLeftImage(imageName: "search")
        searchField.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.bottom.equalTo(-10).priority(.required)
            make.height.lessThanOrEqualTo(42)
            make.right.equalTo(-15)
        }
        
        backButton.snp.makeConstraints { (make) in
            make.left.equalTo(headerView.snp.left)
            make.top.equalTo(0)
            make.width.equalTo(50)
            make.bottom.equalTo(searchField.snp.top).offset(-10)
        }
        
        headerTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(backButton.snp.right).offset(10)
            make.centerY.equalTo(backButton)
        }
        
        favouriteButton.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.width.equalTo(40)
            make.bottom.equalTo(searchField.snp.top).offset(-10)
        }
        
        chatButton.snp.makeConstraints { (make) in
            make.left.equalTo(favouriteButton.snp.right).offset(0)
            make.right.equalTo(-5)
            make.top.equalTo(0)
            make.width.equalTo(40)
            make.bottom.equalTo(searchField.snp.top).offset(-10)
        }
        
        collectionView.register(BrandsCollectionCell.self, forCellWithReuseIdentifier: ReuseIdentifier.BrandsCollectionCell)
        collectionView.register(BudgetCell.self, forCellWithReuseIdentifier: ReuseIdentifier.BudgetCell)
        collectionView.register(UINib(nibName: ReuseIdentifier.filterDetailCollectionCell, bundle: nil), forCellWithReuseIdentifier: ReuseIdentifier.filterDetailCollectionCell)
        
        Constants.sharedAppDelegate.setSwipe(enabled: true, navigationController: navigationController)
        requestServer(params: ["type": "2"])
    }
    
    @objc func backButtonAction(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func sellButtonAction(_ sender: UIButton) {
        let vc = SelectedPhotosVC.instantiate(fromAppStoryboard: .categories)
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func favouriteButtonAction(_ sender: UIButton) {
        let vc = FavouritesCategoriesVC()
        vc.delegate = self
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func chatButtonAction(_ sender: UIButton) {
        let vc = InboxVC.instantiate(fromAppStoryboard: .chat)
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
