//
//  UserRatingVC.swift
//  Verkoop
//
//  Created by Vijay on 12/06/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

class UserRatingVC: UIViewController {

    @IBOutlet weak var ratingTableView: UITableView!
    
    enum RatingType: Int {
        case good, average, poor
    }
    
    var ratingType: RatingType = .good
    var userRating: UserRating?
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        requestUserRating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Constants.sharedAppDelegate.setSwipe(enabled: true, navigationController: navigationController)
    }
    
    fileprivate func initialSetup() {
        DispatchQueue.main.async {
            self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
            self.refreshControl.addTarget(self, action: #selector(self.refreshData(_:)), for: UIControl.Event.valueChanged)
            self.ratingTableView.addSubview(self.refreshControl)
            self.ratingTableView.register(UINib(nibName: ReuseIdentifier.UserRatingTableCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.UserRatingTableCell)
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc fileprivate func refreshData(_ sender: AnyObject) {
        requestUserRating()
    }
}
