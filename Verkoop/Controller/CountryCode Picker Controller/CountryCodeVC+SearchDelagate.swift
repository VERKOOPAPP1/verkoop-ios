//
//  CountryCodeVC+SearchDelagate.swift
//  Verkoop
//
//  Created by Vijay on 11/06/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

extension CountryCodeVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text, searchText.count > 0 {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(searchCountry), object: nil)
            perform(#selector(searchCountry), with: nil, afterDelay: 0.01)
        } else {
            filteredList = countryList
        }
        countryTableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ SearchBar: UISearchBar) {
        SearchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ theSearchBar: UISearchBar) {
        theSearchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ SearchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        filteredList = countryList
        countryTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ SearchBar: UISearchBar) {
        filteredList = countryList
        countryTableView.reloadData()
        searchBar.resignFirstResponder()
    }
    
    @objc func searchCountry() {
        let searchString = searchBar.text
        let searchPredicate = NSPredicate(format: "SELF.name contains[cd] %@ OR SELF.dial_code contains[cd] %@ OR SELF.code contains[cd] %@", searchString!, searchString!, searchString!)
        filteredList = countryList.filter({ (country) -> Bool in
            return searchPredicate.evaluate(with: country)
        })
        countryTableView.reloadData()
    }
}
