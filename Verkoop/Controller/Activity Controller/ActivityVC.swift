//
//  ActivityVC.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 28/03/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class ActivityVC: UIViewController {

    @IBOutlet weak var textFieldSearch: UITextField!
    @IBOutlet weak var buttonCategory: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl = UIRefreshControl()
    var notificationModel: NotificationModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        getNotificationList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Constants.sharedAppDelegate.setSwipe(enabled: false, navigationController: navigationController)
    }
    
    fileprivate func initialSetup() {
        buttonCategory.makeRoundCorner(5)
        textFieldSearch.makeRoundCorner(5)
        textFieldSearch.applyPadding(padding: 10)
        let frame = CGRect(x: 0, y: 0, width: 40, height: 18)
        textFieldSearch.setRightViewWith(imageName: "search", frame: frame)
        textFieldSearch.setAttributedPlaceholderWith(font: UIFont.kAppDefaultFontBold(ofSize: 17), color: .darkGray)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        tableView.register(UINib(nibName: ReuseIdentifier.NotificationCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.NotificationCell)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        buttonCategory.addTarget(self, action: #selector(buttonCategoryAction(_:)), for: .touchUpInside)
    }
    
    @IBAction func chatButtonAction(_ sender: UIButton) {
        let vc = InboxVC.instantiate(fromAppStoryboard: .chat)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func favouriteButtonAction(_ sender: UIButton) {
        let vc = FavouritesCategoriesVC()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func buttonCategoryAction(_ sender: UIButton) {
        let vc = CategoriesVC.instantiate(fromAppStoryboard: .categories)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func testButton(_ sender: UIButton) {
        Console.log("Button Tapped")
    }
    
    @objc fileprivate func refreshData(_ sender: AnyObject) {
        getNotificationList()
    }
}

extension ActivityVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let searchVC = SearchVC()
        navigationController?.pushViewController(searchVC, animated: true)
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
