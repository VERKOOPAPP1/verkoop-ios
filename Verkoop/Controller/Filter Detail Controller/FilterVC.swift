//
//  FilterVC.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 31/01/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class FilterVC: UIViewController {
        
    @IBOutlet weak var buttonApply: UIButton!
    @IBOutlet weak var tableFilterVC: UITableView!
    
    var filterParams: [String:String] = [:]
    var delegate: ApplyFilterDelegates?
    var sectionFilter = Section()    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Constants.sharedAppDelegate.setSwipe(enabled: true, navigationController: navigationController)
    }
    
    fileprivate func initialSetup() {
        buttonApply.dropShadow()
        buttonApply.setRadius(buttonApply.frame.height / 2)
        tableFilterVC.register(TitleAndCheckBoxCell.self, forCellReuseIdentifier: ReuseIdentifier.TitleAndCheckBoxCell)
        tableFilterVC.register(UINib(nibName: ReuseIdentifier.itemConditionFilterTableCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.itemConditionFilterTableCell)
        tableFilterVC.register(UINib(nibName: ReuseIdentifier.priceTableCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.priceTableCell)
        sectionFilter.sectionArray[0].filterArray[Int.getInt(filterParams["sort_no"]) - 1].isSelected = true
    }
}
