//
//  SelectOptionsVC.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 29/11/18.
//  Copyright © 2018 MobileCoderz. All rights reserved.
//

class SelectOptionsVC: UIViewController {
    @IBOutlet weak var buttonLater: UIButton!
    @IBOutlet weak var buttonSell: UIButton!
    @IBOutlet weak var buttonShop: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonLater.setRadius(buttonLater.frame.height/2, .white, 2.5)
        buttonSell.setRadius(buttonSell.frame.height/2)
        buttonShop.setRadius(buttonShop.frame.height/2)
    }
    
    @IBAction func buttonLaterTapped(sender: UIButton){
       switchToDashboard()
    }
    
    @IBAction func buttonShopTapped(sender: UIButton) {
        switchToDashboard()
    }
    
    @IBAction func buttonSellTapped(sender: UIButton) {
        Constants.sharedUserDefaults.set("1", forKey: UserDefaultKeys.kSellItem)
        switchToDashboard()
    }
    
    func switchToDashboard() {
        let vc = DashboardTabBarController.instantiate(fromAppStoryboard: .home)
        navigationController?.pushViewController(vc, animated: true)
        Constants.sharedUserDefaults.set(CurrentScreen.dashboard.rawValue, forKey: UserDefaultKeys.screen)
    }
}

/*
 func enableAppyButton() {
 
 buttonSave.alpha = 0.7
 buttonSave.isEnabled = false
 
 guard let _ = addDetailDict[AddDetailDictKeys.image.rawValue] else {
 return
 }
 
 guard let name = addDetailDict[AddDetailDictKeys.name.rawValue] as? String, name.count > 0 else {
 return
 }
 
 guard let category = addDetailDict[AddDetailDictKeys.category_name.rawValue] as? String, category.count > 0 else {
 return
 }
 
 guard let price = addDetailDict[AddDetailDictKeys.price.rawValue] as? String, price.count > 0 else {
 return
 }
 
 guard let description = addDetailDict[AddDetailDictKeys.description.rawValue] as? String, description.count > 0 else {
 return
 }
 
 if itemType == .generic { //Generic Validation
 guard let _ = addDetailDict[AddDetailDictKeys.item_type.rawValue] as? String else {
 return
 }
 
 guard let meetUp = addDetailDict[AddDetailDictKeys.meet_up.rawValue] as? String else {
 return
 }
 if meetUp == "1" {
 guard let address = addDetailDict[AddDetailDictKeys.address.rawValue] as? String, address.count > 0 else {
 return
 }
 }
 } else if itemType == .car { //Car Validation
 guard let brand = addDetailDict[AddDetailDictKeys.brand_name.rawValue] as? String, brand.count > 0 else {
 return
 }
 
 guard let location = addDetailDict[AddDetailDictKeys.location.rawValue] as? String, location.count > 0 else {
 return
 }
 
 guard let minYear = addDetailDict[AddDetailDictKeys.fromYear.rawValue] as? String, let maxYear = addDetailDict[AddDetailDictKeys.toYear.rawValue] as? String, minYear.count == 4, maxYear.count == 4 else {
 return
 }
 
 guard let minPrice = addDetailDict[AddDetailDictKeys.minPrice.rawValue] as? String, let maxPrice = addDetailDict[AddDetailDictKeys.maxPrice.rawValue] as? String, minPrice.count > 0, maxPrice.count > 0 else {
 return
 }
 
 guard let owner = addDetailDict[AddDetailDictKeys.direct_owner.rawValue] as? String, owner.count > 0  else {
 return
 }
 } else if itemType == .property || itemType == .rentals { //Property Validation
 guard let zone = addDetailDict[AddDetailDictKeys.location.rawValue] as? String, zone.count > 0 else {
 return
 }
 
 guard let street = addDetailDict[AddDetailDictKeys.street_name.rawValue] as? String, street.count > 0 else {
 return
 }
 
 guard let postal = addDetailDict[AddDetailDictKeys.postal_code.rawValue] as? String, postal.count > 0 else {
 return
 }
 
 guard let area = addDetailDict[AddDetailDictKeys.city.rawValue] as? String, area.count > 0 else {
 return
 }
 
 guard let bedroom = addDetailDict[AddDetailDictKeys.bedroom.rawValue] as? String, bedroom.count > 0 else {
 return
 }
 
 guard let bathroom = addDetailDict[AddDetailDictKeys.bathroom.rawValue] as? String, bathroom.count > 0 else {
 return
 }
 
 guard let minPrice = addDetailDict[AddDetailDictKeys.minPrice.rawValue] as? String, let maxPrice = addDetailDict[AddDetailDictKeys.maxPrice.rawValue] as? String, minPrice.count > 0, maxPrice.count > 0 else {
 return
 }
 
 guard let owner = addDetailDict[AddDetailDictKeys.direct_owner.rawValue] as? String, owner.count > 0  else {
 return
 }
 }
 buttonSave.alpha = 1
 buttonSave.isEnabled = true
 }
 */
