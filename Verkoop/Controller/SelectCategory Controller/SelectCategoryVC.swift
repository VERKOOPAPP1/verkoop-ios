//
//  SelectCategoryVC.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 28/11/18.
//  Copyright © 2018 MobileCoderz. All rights reserved.
//

import UIKit

class SelectCategoryVC: UIViewController {
    
    @IBOutlet weak var labelSelected: UILabel!
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var collectionViewCategory: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var categoriesIdArray : [String] = []
    var categoryList: CategoryList?
    var noOfSelectedCategories = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewCategory.register(UINib.init(nibName: ReuseIdentifier.selectCategoryCollectionCell, bundle: nil), forCellWithReuseIdentifier: ReuseIdentifier.selectCategoryCollectionCell)
        collectionViewCategory.dataSource = self
        collectionViewCategory.delegate = self
        collectionViewCategory.backgroundColor = .clear
        buttonNext.setRadius(buttonNext.frame.height/2, .white, 2.5)
        setCategories(selected: 0)
        requestServer(parms: nil)
    }
    
    func setupDummyData() {
        
    }
    
    func setCategories(selected: Int){
        labelSelected.text = String(selected) + " / 3"
    }
    
    @IBAction func buttonSkipTapped(sender: UIButton) {
        let vc = SelectOptionsVC.instantiate(fromAppStoryboard: .selection)
        navigationController?.pushViewController(vc, animated: true)
        Constants.sharedUserDefaults.set(CurrentScreen.option.rawValue, forKey: UserDefaultKeys.screen)
    }
    
    @IBAction func buttonNextTapped(sender: UIButton) {
        if noOfSelectedCategories == 3 {
          updateSelectedCategory()
        } else {
            DisplayBanner.show(message: "Please select at least three category")
        }
    }
}
