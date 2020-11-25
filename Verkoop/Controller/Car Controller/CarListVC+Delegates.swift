//
//  CarListVC+Delegates.swift
//  Verkoop
//
//  Created by Vijay on 18/04/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

@objc protocol FilteredSelectedDelegate {
    @objc optional func didBrandFilteredSelected(brand_id: String)
    @objc optional func didCarTypeFilteredSelected(car_type_id: String)
    @objc optional func didZoneTypeFilteredSelected(zone_id: String)
}

extension CarListVC: RefreshScreen, FilteredSelectedDelegate {
    func refreshData() {
        
    }
    
    func didBrandFilteredSelected(brand_id: String) {
        let favouriteVC = FavouritesCategoriesVC()
        favouriteVC.itemType = .car
        favouriteVC.filterDict = ["brand_id": brand_id, "car_type_id": "", "zone_id": "", "type": "1", "price_no": ""]
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(favouriteVC, animated: true)
        }
    }
    
    func didCarTypeFilteredSelected(car_type_id: String) {
        let favouriteVC = FavouritesCategoriesVC()
        favouriteVC.itemType = .car
        favouriteVC.filterDict = ["brand_id": "", "car_type_id": car_type_id, "zone_id": "", "type": "1", "price_no": ""]
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(favouriteVC, animated: true)
        }
    }
}
