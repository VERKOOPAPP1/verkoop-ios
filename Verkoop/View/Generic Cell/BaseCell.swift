//
//  BaseCell.swift
//  Verkoop
//
//  Created by Vijay on 28/05/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class BaseCell<D>: UITableViewCell {

    var dataModel: D!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
