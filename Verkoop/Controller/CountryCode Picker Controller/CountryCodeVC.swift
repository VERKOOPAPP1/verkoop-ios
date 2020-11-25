//
//  CountryCodeVC.swift
//  Verkoop
//
//  Created by Vijay on 11/06/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class CountryCodeVC: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var countryTableView: UITableView!
    
    weak var delegate: CountryCodeDelegate?
    var countryList: [[String: Any]] = []
    var filteredList: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()        
    }
    
    fileprivate func initialSetup() {
        countryList = DocumentManager.sharedManager.getCountryList()
        filteredList = countryList
        countryTableView.delegate = self
        countryTableView.dataSource = self
    }
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
