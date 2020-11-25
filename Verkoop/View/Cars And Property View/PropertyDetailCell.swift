//
//  PropertyDetailCell.swift
//  Verkoop
//
//  Created by Vijay on 29/04/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class PropertyDetailCell: UITableViewCell {

    @IBOutlet weak var bedroomTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var furnishedValueLabel: UILabel!
    @IBOutlet weak var furnishedTitleLabel: UILabel!
    @IBOutlet weak var parkingTypeLabel: UILabel!
    @IBOutlet weak var propertyTypeLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var postalCodeLabel: UILabel!
    @IBOutlet weak var bedroomLabel: UILabel!
    @IBOutlet weak var bathroomLabel: UILabel!
    @IBOutlet weak var zoneLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
