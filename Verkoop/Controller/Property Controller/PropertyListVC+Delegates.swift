//
//  PropertyListVC+Delegates.swift
//  Verkoop
//
//  Created by Vijay on 18/04/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

extension PropertyListVC: RefreshScreen , FilteredSelectedDelegate {
    func refreshData() {
        
    }
    
    func didZoneTypeFilteredSelected(zone_id: String) {
        let favouriteVC = FavouritesCategoriesVC()
        favouriteVC.itemType = .property
        favouriteVC.filterDict = ["brand_id": "", "zone_id": zone_id, "car_type_id": "", "type": "2", "price_no": ""]
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(favouriteVC, animated: true)
        }
    }
}
