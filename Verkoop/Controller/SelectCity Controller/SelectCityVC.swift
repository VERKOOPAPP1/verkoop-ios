//
//  SelectCityVC.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 28/03/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

enum SelectionType: Int {
    case regionSelection
    case brandSelection
    case subCategorySelection
}

class SelectCityVC: UIViewController {
    var zoneArray: [[String:String]] = [["id":"1", "name":"East"], ["id":"2", "name":"West"], ["id":"3", "name":"North East"], ["id":"3", "name":"North"], ["id":"4", "name":"Central"]]
    
    var selectionType = SelectionType.regionSelection
    var isStateList = true
    var isBrandList = true
    var stateArray: [StateModel] = []
    var searchedStateArray: [StateModel] = []
    var cityArray : [CityModel] = []
    var searchedCityArray : [CityModel] = []
    var categoryList: CategoryList?
    var searchedCategoryList: CategoryList?
    var countryID = ""
    var countryName = ""
    
    //We are using it for many listing option , that's why given the generic name
    var mainCategoryID = -1//Used For main Category
    var subCategoryID = -1//Used for Subcateogry, If any
    var mainCategorySelectedIndex = -1//Index for main Cateogory
    var subCategorySelectedIndex = -1//Index for Subcategory, If any
    
    lazy var tableView: UITableView = {
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .singleLine
        return $0
    }(UITableView())
    
    let headerTitleLabel: UILabel = {
        $0.font = UIFont.kAppDefaultFontBold(ofSize: 18.0)
        $0.text =  "States"
        $0.textColor = .white
        return $0
    }(UILabel())
    
    let headerView: UIView = {
        $0.backgroundColor = kAppDefaultColor
        return $0
    }(UIView())
    
    let backButton: UIButton = {
        $0.setImage(UIImage(named: "back"), for: .normal)
        return $0
    }(UIButton())
    
    lazy var searchField: UITextField = {
        $0.placeholder = isStateList ? Titles.searchState : Titles.searchCity
        $0.font = UIFont.kAppDefaultFontRegular(ofSize: 16.0)
        $0.backgroundColor = .white
        $0.makeRoundCorner(4)
        $0.delegate = self
        return $0
    }(UITextField())
    
    let testButton: UIButton = {
        return $0
    }(UIButton())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        
        if selectionType == .regionSelection {
            loadCityStateList()
            headerTitleLabel.text = isStateList ? "Region" : "City"
        } else if selectionType == .brandSelection {
            if isBrandList {
                getBrandService()
                headerTitleLabel.text = "Select Brand"
                searchField.placeholder = "Search Brand"
            } else {
                if let brandName = searchedCategoryList?.data![mainCategorySelectedIndex].name {
                    headerTitleLabel.text = brandName
                }
                searchField.placeholder = "Search Car Type"
            }
        } else if selectionType == .subCategorySelection {
            loadCityStateList()
            searchField.placeholder = "Search Zone"
            headerTitleLabel.text = "Select Zone"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Constants.sharedAppDelegate.setSwipe(enabled: true, navigationController: navigationController)
    }
    
     fileprivate func initialSetup() {
        
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(headerView)
        headerView.addSubview(backButton)
        headerView.addSubview(searchField)
        headerView.addSubview(headerTitleLabel)
        headerView.addSubview(testButton)
        
        headerView.addInnerShadow(onSide: .all, shadowColor: .black, shadowSize: 3, shadowOpacity: 0.5)
        headerView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.height.equalTo(view.frame.height * 0.18)
        }

        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom).offset(-1)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.snp.bottom)
        }
        
        searchField.setLeftImage(imageName: "search")
        searchField.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.bottom.equalTo(-10).priority(.required)
            make.height.lessThanOrEqualTo(45)
            make.right.equalTo(-15)
        }
        
        backButton.addTarget(self, action: #selector(backButtonAction(_:)), for: .touchUpInside)
        backButton.snp.makeConstraints { (make) in
            make.left.equalTo(headerView.snp.left)
            make.top.equalTo(25)
            make.width.equalTo(50)
            make.bottom.equalTo(searchField.snp.top).offset(-10)
        }

        headerTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(backButton.snp.right).offset(10)
            make.centerY.equalTo(backButton)
        }
        
        testButton.snp.makeConstraints { (make) in
            make.right.equalTo(-5)
            make.top.equalTo(20)
            make.width.equalTo(50)
            make.bottom.equalTo(searchField.snp.top).offset(-10)
        }
        
        tableView.separatorStyle = .none
        tableView.register(TitleAndCheckBoxCell.self, forCellReuseIdentifier: ReuseIdentifier.TitleAndCheckBoxCell)
        Constants.sharedAppDelegate.setSwipe(enabled: true, navigationController: navigationController)
    }
    
    func loadCityStateList() {
        if isStateList {
            if let statesJSONData = DocumentManager.sharedManager.readData(name: "states.json") {
                do {
                    let jsonDict = try JSONSerialization.jsonObject(with: statesJSONData, options: []) as!
                        [String:Any]
                    if let countryArray = jsonDict["country"] as? [[String:Any]], let country = countryArray.first {
                        if let stateList = country["states"] as? [[String:Any]] {
                            stateArray = stateList.map {
                                let state = StateModel(json: $0)
                                return state
                            }
                            searchedStateArray = stateArray
                            if mainCategoryID != -1 {
                                mainCategorySelectedIndex = stateArray.firstIndex(where: {(state) -> Bool in
                                    return mainCategoryID == state.id
                                }) ?? -1
                            }
                            countryID = String.getString(country["id"])
                            countryName = String.getString(country["name"])
                        }
                    }
                } catch let error  {
                    Console.log(error.localizedDescription)
                }
            }
        } else {
            cityArray = stateArray[mainCategorySelectedIndex].cities
            searchedCityArray = cityArray
            if subCategoryID != -1 {
                subCategorySelectedIndex = cityArray.firstIndex(where: {(city) -> Bool in
                    return subCategoryID == city.id
                }) ?? -1
            }
        }
        
        OperationQueue.main.addOperation {
            self.tableView.reloadData()
        }
    }
    
    @objc func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
