//
//  CategoriesFilterVC.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 31/01/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class CategoriesFilterVC: UIViewController {
    
    var item_id = ""
    var type = "0" //0 for Main Category && 1 For Sub-Category
    var catgoryId = ""
    var categoryName = ""
    var indices: [IndexPath] = []
    var filterData : FilterModel?
    var filterParams: [String:String] = [:]
    let sortFilter = ["", "Sort - Nearby","Sort - Popular","Sort - Recently added","Sort - Price : High to Low","Sort - Price : Low to High"]
    var categoriesFilterArray: [AppliedFilter] = []
    
    @IBOutlet weak var sellButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var collectionViewFilter: UICollectionView!
    @IBOutlet weak var collectionViewFilterDetail: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initiallSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Constants.sharedAppDelegate.setSwipe(enabled: true, navigationController: navigationController)
    }
    
    func initiallSetup() {
        
        sellButton.setRadius(sellButton.frame.height/2, .white, 3)
        sellButton.addTarget(self, action: #selector(sellButtonAction(_:)), for: .touchUpInside)
        searchTextField.makeRoundCorner(5)
        searchTextField.applyPadding(padding: 10)
        
        let frame = CGRect(x: 0, y: 0, width: 40, height: 18)
        searchTextField.setRightViewWith(imageName: "search", frame: frame)
        searchTextField.placeholder = categoryName
        searchTextField.setAttributedPlaceholderWith(font: UIFont.kAppDefaultFontMedium(ofSize: 17), color: .darkGray)
        
        collectionViewFilter.register(UINib(nibName: ReuseIdentifier.filterCollectionCell, bundle: nil), forCellWithReuseIdentifier: ReuseIdentifier.filterCollectionCell)
        collectionViewFilterDetail.register(UINib(nibName: ReuseIdentifier.AllCategoryHorizontalCell, bundle: nil), forCellWithReuseIdentifier: ReuseIdentifier.AllCategoryHorizontalCell)        
        collectionViewFilterDetail.register(UINib(nibName: ReuseIdentifier.filterDetailCollectionCell, bundle: nil), forCellWithReuseIdentifier: ReuseIdentifier.filterDetailCollectionCell)
        
        filterParams[FilterKeys.category_id.rawValue] = catgoryId
        filterParams[FilterKeys.item_type.rawValue] = ""
        filterParams[FilterKeys.latitude.rawValue] = ""
        filterParams[FilterKeys.longitude.rawValue] = ""
        filterParams[FilterKeys.max_price.rawValue] = ""
        filterParams[FilterKeys.min_price.rawValue] = ""
        filterParams[FilterKeys.meet_up.rawValue] = ""
        filterParams[FilterKeys.sort_no.rawValue] = "2"
        filterParams[FilterKeys.type.rawValue] = type
        filterParams[FilterKeys.item_id.rawValue] = item_id
        filterParams[FilterKeys.userId.rawValue] = Constants.sharedUserDefaults.getUserId()
        categoriesFilterArray.append(AppliedFilter(filterName: "Sort - Popular", filterType: .sort))
        requestServer(params: filterParams)
    }
    
    //MARK:- IBActions
    //MARK:-
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func favouriteButtonAction(_ sender: UIButton) {
        let vc = FavouritesCategoriesVC()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func filterButtonAction(_ sender: UIButton) {
        let filterVC = FilterVC.instantiate(fromAppStoryboard: .categories)
        filterVC.filterParams = filterParams
        filterVC.delegate = self
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(filterVC, animated: true)
        }
    }
    
    @IBAction func chatButtonAction(_ sender: UIButton) {
        let vc = InboxVC.instantiate(fromAppStoryboard: .chat)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func sellButtonAction(_ sender: UIButton) {
        let vc = SelectedPhotosVC.instantiate(fromAppStoryboard: .categories)
        navigationController?.pushViewController(vc, animated: true)
    }        
}

extension CategoriesFilterVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let searchVC = SearchVC()
        searchVC.placeholderText = textField.placeholder!
        navigationController?.pushViewController(searchVC, animated: true)
        view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
