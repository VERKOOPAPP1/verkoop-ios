//
//  CategoryFilterVC+Delegates.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 30/03/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

extension CategoriesFilterVC: ApplyFilterDelegates {
    func didFiltersApplied(filterParams: Dictionary<String, String>) {
        self.filterParams = filterParams        
        requestServer(params: filterParams)        
    }
}

extension CategoriesFilterVC: RefreshScreen {
    func refreshData() {
        requestServer(params: filterParams)
    }
}

