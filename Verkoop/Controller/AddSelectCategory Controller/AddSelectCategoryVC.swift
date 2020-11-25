//
//  AddSelectCategoryVC.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 05/02/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class AddSelectCategoryVC: UIViewController {
    
    @IBOutlet weak var buttonCloseCategory: UIButton!
    @IBOutlet weak var tableAddSelectCategory: UITableView!
    @IBOutlet weak var viewAddCategoryCard: UIView!
    
    var delegate : AddDetailDelegate?
    var selectedSection = -1
    var categoryList: CategoryList?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        requestServer()
        setUpView()
        UIApplication.shared.statusBarView?.backgroundColor =  .clear
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarView?.backgroundColor = kAppDefaultColor
    }
    
    func setUpView() {
        viewAddCategoryCard.isHidden = true
        viewAddCategoryCard.makeRoundCorner(7)
        tableAddSelectCategory.register(UINib(nibName: ReuseIdentifier.addDetailHeaderView, bundle: nil), forHeaderFooterViewReuseIdentifier: ReuseIdentifier.addDetailHeaderView)
    }
    
    @IBAction func tappedActionClose(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
}
