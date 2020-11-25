//
//  ParkingTableCell.swift
//  Verkoop
//
//  Created by Vijay on 20/05/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

enum CellTypeUsed: Int {
    case parking, ownerShip, transmission, furnished
}

class ParkingTableCell: UITableViewCell {
    
    var cellType: CellTypeUsed = .parking
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var garageImageView: UIImageView!
    @IBOutlet weak var parkingImageView: UIImageView!    
    
    weak var delegate: CheckBoxDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func parkingTypeButtonAction(_ sender: UIButton) {
        if let delegateObject = delegate {
            if sender.tag == 1 {
                parkingImageView.image = #imageLiteral(resourceName: "checkbox_active")
                garageImageView.image = #imageLiteral(resourceName: "checkbox_inactive")
            } else {
                garageImageView.image = #imageLiteral(resourceName: "checkbox_active")
                parkingImageView.image = #imageLiteral(resourceName: "checkbox_inactive")
            }
            delegateObject.didSelectParkingType(parkingType:String.getString(sender.tag) , cellType: cellType)            
        }
    }
}
