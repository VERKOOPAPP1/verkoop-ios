//
//  ProfileVC.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 06/02/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet weak var textFieldSearch: UITextField!
    @IBOutlet weak var collectionCellProfile: UICollectionView!
    @IBOutlet weak var buttonCategory: UIButton!
    @IBOutlet weak var sellButton: UIButton!
    
    var refreshControl = UIRefreshControl()
    var itemData: Item?
    var indices : [IndexPath] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        getUserProfile()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshDataNotification(_:)), name: NSNotification.Name(rawValue: NotificationName.RefreshController), object: nil)
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Constants.sharedAppDelegate.setSwipe(enabled: false, navigationController: navigationController)
    }        
    
    @objc func refreshDataNotification(_ notification: Notification) {
         getUserProfile(isshowLoader: true)
    }
    
    func setUpView() {
        sellButton.setRadius(25, .white, 3)
        buttonCategory.makeRoundCorner(5)
        textFieldSearch.makeRoundCorner(5)
        textFieldSearch.applyPadding(padding: 10)
        let frame = CGRect(x: 0, y: 0, width: 40, height: 18)
        textFieldSearch.setRightViewWith(imageName: "search", frame: frame)
        textFieldSearch.setAttributedPlaceholderWith(font: UIFont.kAppDefaultFontBold(ofSize: 17), color: .darkGray)
        collectionCellProfile.register(UINib(nibName: ReuseIdentifier.profileHeaderView, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ReuseIdentifier.profileHeaderView)
        collectionCellProfile.register(UINib(nibName: ReuseIdentifier.filterDetailCollectionCell, bundle: nil), forCellWithReuseIdentifier: ReuseIdentifier.filterDetailCollectionCell)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: UIControl.Event.valueChanged)
        collectionCellProfile.addSubview(refreshControl)
        collectionCellProfile.isHidden = true
    }
    
    @IBAction func chatButtonAction(_ sender: UIButton) {
        let vc = InboxVC.instantiate(fromAppStoryboard: .chat)
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func favouriteButtonAction(_ sender: UIButton) {
        let vc = FavouritesCategoriesVC()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func refreshData(_ sender: AnyObject) {
        getUserProfile(isshowLoader: true)
    }
    
    @IBAction func allCategoryAction(_ sender: UIButton) {
        let vc = CategoriesVC.instantiate(fromAppStoryboard: .categories)
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func sellButtonAction(_ sender: UIButton) {
        let vc = SelectedPhotosVC.instantiate(fromAppStoryboard: .categories)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ProfileVC: UITextFieldDelegate {
    
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
