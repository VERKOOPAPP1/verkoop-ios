//
//  AddDetailHeaderView.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 05/02/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class AddDetailHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var buttonHeader : UIButton!
    @IBOutlet weak var viewSeparator : UIView!
    @IBOutlet weak var viewSeparatorTop : UIView!
    
    override func awakeFromNib() {
        viewSeparatorTop.isHidden = true
    }    
}
