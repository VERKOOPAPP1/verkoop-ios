//
//  AddDetailVC.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 05/02/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit
import Photos

enum ItemType: Int {
    case generic
    case car
    case property
    case rentals
    case imageSearch
}

class AddDetailVC: UIViewController {
    
    var isEdit = false
    var isSelectLocation = false
    var itemType = ItemType.generic
    
    var textViewPlaceholder = "Describe what you are selling and include any detail a buyer might be  intrested in. People love item what stories"
    
    var genericSection = ["Selected Photos ", "", "Item Condition","Deal Option","Description"]
    var carSection = ["Selected Photos ", "", "Year range of car", "Price", "Description"]
    var propertySection = ["Selected Photos ", "", "" , "Price", "Property Type", "Others", "Description"]
    var genericSectionPlaceholder = ["Name", Constants.sharedUserDefaults.getUserMobile(), "Category", "Price"]
    var propertySectionPlaceholder = ["Name", Constants.sharedUserDefaults.getUserMobile(), "Category", "Province", "City", "Street name", "Postal code", "Parking", "Furnished"]
    var carSectionPlaceholder = ["Name", Constants.sharedUserDefaults.getUserMobile(), "Category", "Brand", "Province", "Direct owner", "Transmission"]
    
    var photoAsset = [Photos]()
    var addDetailDict : [String: Any] = [:]
    var removedImage : [Int] = []
    var delegate : DidDeselectPhotos?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonSave: UIButton!
    
    //MARK:- Life Cycle Delegates
    //MARK:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Constants.sharedAppDelegate.setSwipe(enabled: true, navigationController: navigationController)
        
        NotificationCenter.default.addObserver(self, selector: #selector(getSelectedBrand(_:)), name: NSNotification.Name(NotificationName.GetSelectedBrand), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getSelectedZone(_:)), name: NSNotification.Name(NotificationName.GetSelectedZone), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(NotificationName.GetSelectedBrand), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(NotificationName.GetSelectedZone), object: nil)
    }
    
    //MARK:- Private Functions
    //MARK:-
    
    @objc func getSelectedBrand(_ notification: Notification) {
        if let dict = notification.userInfo {
            addDetailDict[AddDetailDictKeys.brand_id.rawValue] = String.getString(dict["brand_id"])
            addDetailDict[AddDetailDictKeys.brand_name.rawValue] = String.getString(dict["brand_name"])
            addDetailDict[AddDetailDictKeys.model_name.rawValue] = String.getString(dict["model_name"])
            addDetailDict[AddDetailDictKeys.model_id.rawValue] = String.getString(dict["model_id"])
            tableView.reloadData()
//            enableAppyButton()
        }
    }

    @objc func getSelectedZone(_ notification: Notification) {
        if let dict = notification.userInfo {
            addDetailDict[AddDetailDictKeys.zone_id.rawValue] = String.getString(dict["zone_id"])
            addDetailDict[AddDetailDictKeys.location.rawValue] = String.getString(dict["zone_name"])
            tableView.reloadData()
//            enableAppyButton()
        }
    }
    
    func setUpView() {            
        buttonSave.addTarget(self, action: #selector(buttonSaveAction(_:)), for: .touchUpInside)
        buttonSave.setRadius(25)
        tableView.register(SwitchCell.self, forCellReuseIdentifier: ReuseIdentifier.SwitchCell)
        tableView.register(TextViewCell.self, forCellReuseIdentifier: ReuseIdentifier.TextViewCell)
        tableView.register(TitleAndCheckBoxCell.self, forCellReuseIdentifier: ReuseIdentifier.TitleAndCheckBoxCell)
        tableView.register(UINib(nibName: ReuseIdentifier.priceTableCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.priceTableCell)
        tableView.register(UINib(nibName: ReuseIdentifier.PropertyTypeCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.PropertyTypeCell)
        tableView.register(UINib(nibName: ReuseIdentifier.ParkingTableCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.ParkingTableCell)
        tableView.register(UINib(nibName: ReuseIdentifier.tableCellSelectedPhotos, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.tableCellSelectedPhotos)
        tableView.register(UINib(nibName: ReuseIdentifier.tableCellSelectCategory, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.tableCellSelectCategory)
        tableView.register(UINib(nibName: ReuseIdentifier.itemConditionFilterTableCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.itemConditionFilterTableCell)
        tableView.register(UINib(nibName: ReuseIdentifier.MobileTableCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.MobileTableCell)
        tableView.register(BedroomBathroomCell.self, forCellReuseIdentifier: ReuseIdentifier.BedroomBathroomCell)
        tableView.register(SwitchCell.self, forCellReuseIdentifier: ReuseIdentifier.SwitchCell)
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        
        if isEdit {
//            enableAppyButton()
        } else {
            categoryButtonAction(UIButton())
        }
    }
    
    //Default Setting the data .
    func setData(productDetail: ProductDetailModel) {
        if isEdit {
            addDetailDict[AddDetailDictKeys.item_id.rawValue] = String.getString(productDetail.id)
            addDetailDict[AddDetailDictKeys.user_id.rawValue] = Constants.sharedUserDefaults.getUserId()
            addDetailDict[AddDetailDictKeys.name.rawValue] = String.getString(productDetail.name)
            addDetailDict[AddDetailDictKeys.price.rawValue] = String.getString(productDetail.price)
            addDetailDict[AddDetailDictKeys.description.rawValue] = String.getString(productDetail.description)
            addDetailDict[AddDetailDictKeys.category_id.rawValue] = String.getString(productDetail.category_id)
            addDetailDict[AddDetailDictKeys.category_name.rawValue] = String.getString(productDetail.category_name)
            
            if itemType == .generic {
                if let meetup = productDetail.meet_up , meetup == 1 {
                    genericSection.insert("Location", at: 4)
                }
                addDetailDict[AddDetailDictKeys.item_type.rawValue] = String.getString(productDetail.item_type)
                addDetailDict[AddDetailDictKeys.meet_up.rawValue] = String.getString(productDetail.meet_up)
                addDetailDict[AddDetailDictKeys.address.rawValue] = String.getString(productDetail.address)
                addDetailDict[AddDetailDictKeys.latitude.rawValue] = String(format:"%f", productDetail.latitude ?? 0.0)
                addDetailDict[AddDetailDictKeys.longitude.rawValue] = String(format:"%f", productDetail.longitude ?? 0.0)
            } else if itemType == .car {
                addDetailDict[AddDetailDictKeys.transmission_type.rawValue] = productDetail.additional_info?.transmission_type ?? "1"
                addDetailDict[AddDetailDictKeys.direct_owner.rawValue] = productDetail.additional_info?.direct_owner ?? "1"
                addDetailDict[AddDetailDictKeys.toYear.rawValue] = productDetail.additional_info?.to_year
                addDetailDict[AddDetailDictKeys.fromYear.rawValue] = productDetail.additional_info?.from_year
                addDetailDict[AddDetailDictKeys.minPrice.rawValue] = productDetail.additional_info?.min_price
                addDetailDict[AddDetailDictKeys.maxPrice.rawValue] = productDetail.additional_info?.max_price
                addDetailDict[AddDetailDictKeys.model_name.rawValue] = productDetail.additional_info?.model_name
                addDetailDict[AddDetailDictKeys.model_id.rawValue] = String.getString(productDetail.model_id)
                addDetailDict[AddDetailDictKeys.brand_name.rawValue] = productDetail.additional_info?.brand_name
                addDetailDict[AddDetailDictKeys.brand_id.rawValue] = String.getString(productDetail.brand_id)
                addDetailDict[AddDetailDictKeys.location.rawValue] = productDetail.additional_info?.location
            } else if itemType == .property || itemType == .rentals {
                if itemType == .rentals {
                    addDetailDict[AddDetailDictKeys.furnished.rawValue] = productDetail.additional_info?.furnished
                }
                addDetailDict[AddDetailDictKeys.direct_owner.rawValue] = productDetail.additional_info?.direct_owner ?? "1"
                addDetailDict[AddDetailDictKeys.property_type.rawValue] = productDetail.additional_info?.property_type
                addDetailDict[AddDetailDictKeys.parking_type.rawValue] = productDetail.additional_info?.parking_type
                addDetailDict[AddDetailDictKeys.minPrice.rawValue] = productDetail.additional_info?.min_price
                addDetailDict[AddDetailDictKeys.maxPrice.rawValue] = productDetail.additional_info?.max_price
                addDetailDict[AddDetailDictKeys.minPrice.rawValue] = productDetail.additional_info?.min_price
                addDetailDict[AddDetailDictKeys.maxPrice.rawValue] = productDetail.additional_info?.max_price
                addDetailDict[AddDetailDictKeys.location.rawValue] = productDetail.additional_info?.location
                addDetailDict[AddDetailDictKeys.street_name.rawValue] = productDetail.additional_info?.street_name
                addDetailDict[AddDetailDictKeys.postal_code.rawValue] = productDetail.additional_info?.postal_code
                addDetailDict[AddDetailDictKeys.city.rawValue] = productDetail.additional_info?.city
                addDetailDict[AddDetailDictKeys.bedroom.rawValue] = productDetail.additional_info?.bedroom
                addDetailDict[AddDetailDictKeys.bathroom.rawValue] = productDetail.additional_info?.bathroom
            }
        } else if itemType == .generic {
            addDetailDict[AddDetailDictKeys.user_id.rawValue] = Constants.sharedUserDefaults.getUserId()
            addDetailDict[AddDetailDictKeys.item_type.rawValue] = "1"
            addDetailDict[AddDetailDictKeys.meet_up.rawValue] = "0"
            addDetailDict[AddDetailDictKeys.address.rawValue] = ""
            addDetailDict[AddDetailDictKeys.name.rawValue] = ""
            addDetailDict[AddDetailDictKeys.price.rawValue] = ""
            addDetailDict[AddDetailDictKeys.description.rawValue] = ""
            addDetailDict[AddDetailDictKeys.latitude.rawValue] = "0.0"
            addDetailDict[AddDetailDictKeys.longitude.rawValue] = "0.0"
        } else if itemType == .car {
            addDetailDict[AddDetailDictKeys.user_id.rawValue] = Constants.sharedUserDefaults.getUserId()
            addDetailDict[AddDetailDictKeys.direct_owner.rawValue] = "1"
            addDetailDict[AddDetailDictKeys.transmission_type.rawValue] = "1"
        } else if itemType == .property || itemType == .rentals {
            addDetailDict[AddDetailDictKeys.direct_owner.rawValue] = productDetail.additional_info?.direct_owner ?? "1"
            addDetailDict[AddDetailDictKeys.user_id.rawValue] = Constants.sharedUserDefaults.getUserId()
            addDetailDict[AddDetailDictKeys.parking_type.rawValue] = "1"
            addDetailDict[AddDetailDictKeys.property_type.rawValue] = "1"            
        }
        addDetailDict[AddDetailDictKeys.image.rawValue] = photoAsset
    }
    
    @IBAction func buttonTappedBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func buttonSaveAction(_ sender: UIButton) {
        if !enableAppyButton() {
            return
        }
        sender.isEnabled = false
        delay(time: 2.0) {
            sender.isEnabled = true
        }
        DispatchQueue.main.async {
            Loader.show()
        }
        var imageArray : [Data] = []
        var base64Array: [String] = []
        for (_, photo) in self.photoAsset.enumerated() {
            let options = PHImageRequestOptions()
            options.deliveryMode = .highQualityFormat
            options.isSynchronous = true
            options.isNetworkAccessAllowed = true
            
            if photo.imageUrl == nil {
                PHImageManager.default().requestImage(for: photo.assest!, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFill, options: options) { (image, _) in
                    if let image = image, let data = image.jpeg(.medium) {
                        let base64String = Utilities.sharedUtilities.base64EncodeImage(image)
                        imageArray.append(data)
                        base64Array.append(base64String)
                    }
                }
            }
        }        
        addDetailDict[AddDetailDictKeys.image.rawValue] = nil
        addDetailDict[AddDetailDictKeys.image.rawValue] = imageArray
        addDetailDict[AddDetailDictKeys.image_remove_id.rawValue] = ""
        if isEdit {
            addDetailDict[AddDetailDictKeys.image_remove_id.rawValue] = removedImage.map{String($0)}.joined(separator: ",")
        }
        addDetailDict[AddDetailDictKeys.type.rawValue] = String(itemType.rawValue)
        
        if itemType == .car {
            var param : [String:Any] = [:]
            
            param[AddDetailDictKeys.type.rawValue] = addDetailDict[AddDetailDictKeys.type.rawValue]
            param[AddDetailDictKeys.user_id.rawValue] = addDetailDict[AddDetailDictKeys.user_id.rawValue]
            param[AddDetailDictKeys.category_id.rawValue] = addDetailDict[AddDetailDictKeys.category_id.rawValue]
            param[AddDetailDictKeys.brand_id.rawValue] = addDetailDict[AddDetailDictKeys.brand_id.rawValue]
            param[AddDetailDictKeys.model_id.rawValue] = addDetailDict[AddDetailDictKeys.model_id.rawValue]
            param[AddDetailDictKeys.image.rawValue] = addDetailDict[AddDetailDictKeys.image.rawValue]
            param[AddDetailDictKeys.name.rawValue] = addDetailDict[AddDetailDictKeys.name.rawValue]
            param[AddDetailDictKeys.price.rawValue] = addDetailDict[AddDetailDictKeys.price.rawValue]
            param[AddDetailDictKeys.description.rawValue] = addDetailDict[AddDetailDictKeys.description.rawValue]
            param[AddDetailDictKeys.item_type.rawValue] = addDetailDict[AddDetailDictKeys.item_type.rawValue]
            param[AddDetailDictKeys.item_id.rawValue] = addDetailDict[AddDetailDictKeys.item_id.rawValue]
            param[AddDetailDictKeys.item_type.rawValue] = "0"
            
            var additionalInfo: [String: Any] = [:]
            additionalInfo[AddDetailDictKeys.transmission_type.rawValue] = addDetailDict[AddDetailDictKeys.transmission_type.rawValue]
            additionalInfo[AddDetailDictKeys.location.rawValue] = addDetailDict[AddDetailDictKeys.location.rawValue]
            additionalInfo[AddDetailDictKeys.brand_name.rawValue] = addDetailDict[AddDetailDictKeys.brand_name.rawValue]
            additionalInfo[AddDetailDictKeys.model_name.rawValue] = addDetailDict[AddDetailDictKeys.model_name.rawValue]
            additionalInfo[AddDetailDictKeys.fromYear.rawValue] = addDetailDict[AddDetailDictKeys.fromYear.rawValue]
            additionalInfo[AddDetailDictKeys.toYear.rawValue] = addDetailDict[AddDetailDictKeys.toYear.rawValue]
            additionalInfo[AddDetailDictKeys.minPrice.rawValue] = addDetailDict[AddDetailDictKeys.minPrice.rawValue]
            additionalInfo[AddDetailDictKeys.maxPrice.rawValue] = addDetailDict[AddDetailDictKeys.maxPrice.rawValue]
            additionalInfo[AddDetailDictKeys.maxPrice.rawValue] = addDetailDict[AddDetailDictKeys.maxPrice.rawValue]
            additionalInfo[AddDetailDictKeys.direct_owner.rawValue] = addDetailDict[AddDetailDictKeys.direct_owner.rawValue]
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: additionalInfo)
                let jsonString = String(data: jsonData, encoding: .utf8)
                param[AddDetailDictKeys.additional_info.rawValue] = jsonString
            } catch let error {
                Console.log(error.localizedDescription)
            }
            
            getImageLabelFromVision(with: base64Array) {[weak self] (status, imageLabelArray) in
                if status {
                    param[AddDetailDictKeys.label.rawValue] = imageLabelArray
                    self?.addItemService(params: param)
                } else {
                    //Vision API failed
                }
            }
        } else if itemType == .property || itemType == .rentals {
            var param : [String:Any] = [:]
            
            param[AddDetailDictKeys.type.rawValue] = addDetailDict[AddDetailDictKeys.type.rawValue]
            param[AddDetailDictKeys.user_id.rawValue] = addDetailDict[AddDetailDictKeys.user_id.rawValue]
            param[AddDetailDictKeys.category_id.rawValue] = addDetailDict[AddDetailDictKeys.category_id.rawValue]
            param[AddDetailDictKeys.image.rawValue] = addDetailDict[AddDetailDictKeys.image.rawValue]
            param[AddDetailDictKeys.name.rawValue] = addDetailDict[AddDetailDictKeys.name.rawValue]
            param[AddDetailDictKeys.price.rawValue] = addDetailDict[AddDetailDictKeys.price.rawValue]
            param[AddDetailDictKeys.description.rawValue] = addDetailDict[AddDetailDictKeys.description.rawValue]
            param[AddDetailDictKeys.zone_id.rawValue] = addDetailDict[AddDetailDictKeys.zone_id.rawValue]
            param[AddDetailDictKeys.model_id.rawValue] = addDetailDict[AddDetailDictKeys.model_id.rawValue]
            param[AddDetailDictKeys.item_type.rawValue] = addDetailDict[AddDetailDictKeys.item_type.rawValue]
            param[AddDetailDictKeys.item_id.rawValue] = addDetailDict[AddDetailDictKeys.item_id.rawValue]
            param[AddDetailDictKeys.item_type.rawValue] = "0"
            
            var additionalInfo: [String: Any] = [:]
            additionalInfo[AddDetailDictKeys.location.rawValue] = addDetailDict[AddDetailDictKeys.location.rawValue]
            additionalInfo[AddDetailDictKeys.street_name.rawValue] = addDetailDict[AddDetailDictKeys.street_name.rawValue]
            additionalInfo[AddDetailDictKeys.postal_code.rawValue] = addDetailDict[AddDetailDictKeys.postal_code.rawValue]
            additionalInfo[AddDetailDictKeys.city.rawValue] = addDetailDict[AddDetailDictKeys.city.rawValue]
            additionalInfo[AddDetailDictKeys.bedroom.rawValue] = addDetailDict[AddDetailDictKeys.bedroom.rawValue]
            additionalInfo[AddDetailDictKeys.bathroom.rawValue] = addDetailDict[AddDetailDictKeys.bathroom.rawValue]
            additionalInfo[AddDetailDictKeys.minPrice.rawValue] = addDetailDict[AddDetailDictKeys.minPrice.rawValue]
            additionalInfo[AddDetailDictKeys.maxPrice.rawValue] = addDetailDict[AddDetailDictKeys.maxPrice.rawValue]
            additionalInfo[AddDetailDictKeys.parking_type.rawValue] = addDetailDict[AddDetailDictKeys.parking_type.rawValue]
            additionalInfo[AddDetailDictKeys.property_type.rawValue] = addDetailDict[AddDetailDictKeys.property_type.rawValue]
            additionalInfo[AddDetailDictKeys.direct_owner.rawValue] = addDetailDict[AddDetailDictKeys.direct_owner.rawValue]
            if itemType == .rentals {
                additionalInfo[AddDetailDictKeys.furnished.rawValue] = addDetailDict[AddDetailDictKeys.furnished.rawValue]
            }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: additionalInfo)
                let jsonString = String(data: jsonData, encoding: .utf8)
                param[AddDetailDictKeys.additional_info.rawValue] = jsonString
            } catch let error {
                Console.log(error.localizedDescription)
            }
            getImageLabelFromVision(with: base64Array) {[weak self] (status, imageLabelArray) in
                if status {
                    param[AddDetailDictKeys.label.rawValue] = imageLabelArray
                    self?.addItemService(params: param)
                } else {
                    //Vision API failed
                }
            }
        } else {
            getImageLabelFromVision(with: base64Array) {[weak self] (status, imageLabelArray) in
                if status {
                    self?.addDetailDict[AddDetailDictKeys.label.rawValue] = imageLabelArray
                    self?.addItemService(params: self?.addDetailDict)
                } else {
                    //Vision API failed
                }
            }
        }
    }
}
