//
//  CountryCodeVC+TableView.swift
//  Verkoop
//
//  Created by Vijay on 11/06/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

protocol CountryCodeDelegate: class {
    func didSelectCountryCode(dialCode: String)
}

extension CountryCodeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.CountryCodeTableCell, for: indexPath) as? CountryCodeTableCell else {
            return UITableViewCell()
        }
        let country = filteredList[indexPath.row]
        cell.countryImageView.image = UIImage(named: String.getString(country["code"]))
        cell.countryNameLabel.text = country["name"] as? String ?? ""
        cell.countryCodeLabel.text = country["dial_code"] as? String ?? "+27"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let country = filteredList[indexPath.row]
        if let delegateObject = delegate {
            delegateObject.didSelectCountryCode(dialCode: String.getString(country["dial_code"]))
            searchBar.resignFirstResponder()
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }        
}
