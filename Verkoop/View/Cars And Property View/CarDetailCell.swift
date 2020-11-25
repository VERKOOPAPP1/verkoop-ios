//
//  CarDetailCell.swift
//  Verkoop
//
//  Created by Vijay on 29/04/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

class CarDetailCell: UITableViewCell {
    
    @IBOutlet weak var transmissionTypeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var registrationLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var modelNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
