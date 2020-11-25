//
//  SearchVC.swift
//  Verkoop
//
//  Created by Vijay on 09/04/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import SnapKit

enum SearchType: String {
    case item = "Search Verkoop"
    case user = "Search User"
    case follower = "Search Follower"
    case following = "Search Following User"
    case imageRecognition = "Search Image Result"
}

class SearchVC: UIViewController {

    lazy var tableView: UITableView = {
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .none
        return $0
    }(UITableView())
        
    let headerView: UIView = {
        $0.backgroundColor = kAppDefaultColor
        $0.clipsToBounds = true
        return $0
    }(UIView())
    
    let backButton: UIButton = {
        $0.setImage(UIImage(named: "back"), for: .normal)
        return $0
    }(UIButton())
    
    lazy var searchField: UITextField = {
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .words
        $0.returnKeyType = .search
        $0.placeholder = (self.searchType == .item ? self.placeholderText : self.searchType.rawValue)
        $0.font = UIFont.kAppDefaultFontBold(ofSize: 17)
        $0.backgroundColor = .white
        $0.makeRoundCorner(6)
        $0.delegate = self
        return $0
    }(UITextField())
    
    var userId = Constants.sharedUserDefaults.getUserId()
    var searchedImageData: SearchedImageModel?
    var searchItemData: SearchItemData?
    var searchUserData: SearchUserData?
    var filteredUserData: SearchUserData?
    var indices : [IndexPath] = []
    var searchType: SearchType = .item
    var tableBottom: Constraint!
    var placeholderText = SearchType.item.rawValue
    var recognizedTag: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        Constants.sharedAppDelegate.setSwipe(enabled: true, navigationController: navigationController)
    }
    
    fileprivate func initialSetup() {
        view.backgroundColor = .white
        view.addSubview(headerView)
        view.addSubview(tableView)
        headerView.addSubview(backButton)
        headerView.addSubview(searchField)
        
        headerView.snp.makeConstraints { (make) in  
            make.left.equalTo(0)
            make.top.equalTo(view.snp.topMargin)
            make.right.equalTo(0)
            make.height.equalTo(60)
        }
        headerView.addShadow(offset: CGSize(width: 3, height: 3), color: .darkGray, radius: 10, opacity: 0.7)
        
        backButton.addTarget(self, action: #selector(backButtonAction(_:)), for: .touchUpInside)
        backButton.snp.makeConstraints { (make) in
            make.left.equalTo(headerView.snp.left)
            make.top.equalTo(0)
            make.width.equalTo(45)
            make.bottom.equalTo(headerView.snp.bottom)
        }
        
        searchField.snp.makeConstraints { (make) in
            make.left.equalTo(backButton.snp.right)
            make.height.equalTo(43)
            make.centerY.equalTo(backButton.snp.centerY)
            make.right.equalTo(headerView.snp.right).offset(-16)
        }
        
        searchField.addLeftMargin()
        searchField.rightViewMode = .always
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: 30, height: 40)
        let searchImage = UIImageView()
        containerView.addSubview(searchImage)
        searchImage.image = UIImage(named: "search")
        searchImage.snp.makeConstraints { (make) in
            make.height.equalTo(15)
            make.width.equalTo(15)
            make.centerY.equalTo(containerView.snp.centerY)
            make.left.equalTo(containerView.snp.left)
        }
        searchField.rightView = containerView
    
        tableView.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.top.equalTo(headerView.snp.bottom).offset(1)
            tableBottom = make.bottom.equalTo(view.snp.bottom).constraint
        }
        tableView.register(SearchedUserCell.self, forCellReuseIdentifier: ReuseIdentifier.SearchedUserCell)
        tableView.register(SearchItemCell.self, forCellReuseIdentifier: ReuseIdentifier.SearchItemCell)
        Constants.sharedAppDelegate.setSwipe(enabled: true, navigationController: navigationController)
        
        tableView.reloadData()
        if searchType == .follower || searchType == .following {
            getUserList(username: "")
        } else if searchType == .imageRecognition {
            getRecognizedService(searchString: recognizedTag ?? "")
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            tableBottom.update(offset: -keyboardSize.height)
            UIView.animate(withDuration: 0.2) {
                self.tableView.layoutIfNeeded()
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        tableBottom.update(offset: 0)
        UIView.animate(withDuration: 0.2) {
            self.tableView.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

}
