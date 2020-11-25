//
//  CustomTableCell.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 15/03/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class CustomTableCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupLayout() {
        
    }
}
