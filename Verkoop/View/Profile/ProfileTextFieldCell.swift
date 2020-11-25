//
//  ProfileTextFieldCell.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 26/03/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class ProfileTextFieldCell: UITableViewCell {
    
    @IBOutlet weak var changeMobileButton: UIButton!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var inputField: UITextField!    
    @IBOutlet weak var heightContraint: NSLayoutConstraint!
    @IBOutlet weak var lineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }    
}
