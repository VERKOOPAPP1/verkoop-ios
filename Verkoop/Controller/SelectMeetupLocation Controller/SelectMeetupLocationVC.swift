//
//  SelectMeetupLocationVC.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 13/03/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit
import SnapKit

class SelectMeetupLocationVC: UIViewController {

    var delegate: AddDetailDelegate?
    var locationArray : [LocationModel] = []
    
    lazy var tableView: UITableView = {
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .none
        return $0
    }(UITableView())
    
    let headerTitleLabel: UILabel = {
        $0.font = UIFont.kAppDefaultFontBold(ofSize: 18.0)
        $0.text = "Deal Location"
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
    
    lazy var searchField: UITextField = {
        $0.placeholder = "Search"
        $0.font = UIFont.kAppDefaultFontRegular(ofSize: 16.0)
        $0.backgroundColor = .white
        $0.makeRoundCorner(4)
        $0.delegate = self
        return $0
    }(UITextField())
    
    let testButton: UIButton = {
        return $0
    }(UIButton())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    fileprivate func initialSetup() {
        
        view.backgroundColor = .white
        view.addSubview(headerView)
        view.addSubview(tableView)
        headerView.addSubview(headerTitleLabel)
        headerView.addSubview(backButton)
        headerView.addSubview(searchField)
        headerView.addSubview(testButton)
        
        headerView.addInnerShadow(onSide: .all, shadowColor: .black, shadowSize: 3, shadowOpacity: 0.5)
        headerView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.height.equalTo(view.frame.height * 0.18)
        }

        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom).offset(-1)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.snp.bottom)
        }
        
        searchField.setLeftImage(imageName: "search")
        searchField.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.bottom.equalTo(-10).priority(.required)
            make.height.lessThanOrEqualTo(45)
            make.right.equalTo(-15)
        }
        
        backButton.addTarget(self, action: #selector(backButtonAction(_:)), for: .touchUpInside)
        backButton.snp.makeConstraints { (make) in
            make.left.equalTo(headerView.snp.left)
            make.top.equalTo(25)
            make.width.equalTo(50)
            make.bottom.equalTo(searchField.snp.top).offset(-10)
        }
        
        headerTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(backButton.snp.right).offset(10)
            make.centerY.equalTo(backButton)
        }
        
        testButton.snp.makeConstraints { (make) in
            make.right.equalTo(-5)
            make.top.equalTo(20)
            make.width.equalTo(50)
            make.bottom.equalTo(searchField.snp.top).offset(-10)
        }
                
        tableView.separatorStyle = .none
        tableView.register(SelectLocationCell.self, forCellReuseIdentifier: ReuseIdentifier.SelectLocationCell)
        Constants.sharedAppDelegate.setSwipe(enabled: true, navigationController: navigationController)
    }
    
    @objc func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
