//
//  ItemConditionFilterTableCell.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 01/02/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class ItemConditionFilterTableCell: UITableViewCell {

    @IBOutlet weak var buttonUsed: UIButton!
    @IBOutlet weak var buttonNew: UIButton!
    
    var delegate : AddDetailDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        buttonNew.isSelected = false
        buttonNew.backgroundColor = UIColor(hexString: "#D5D5D5")
        buttonNew.dropShadow()
        buttonNew.setRadius(5)
        buttonUsed.dropShadow()
        buttonUsed.setRadius(5)
        
        buttonNew.addTarget(self, action: #selector(buttonNewAction(_:)), for: .touchUpInside)
        buttonUsed.addTarget(self, action: #selector(buttonUsedAction(_:)), for: .touchUpInside)
    }
    
    @objc func buttonNewAction(_ sender: UIButton) {
        if let delegateObject = delegate {
            buttonNew.isSelected = true
            buttonNew.backgroundColor = kAppDefaultColor
            buttonUsed.isSelected = false
            buttonUsed.backgroundColor = UIColor(hexString: "#D5D5D5")
            delegateObject.selectUsedUnusedType!(isNew: 1)
        }
    }
    
    @objc func buttonUsedAction(_ sender: UIButton) {
        if let delegateObject = delegate {
            buttonNew.isSelected = false
            buttonUsed.isSelected = true
            buttonNew.backgroundColor = UIColor(hexString: "#D5D5D5")
            buttonUsed.backgroundColor = kAppDefaultColor
            delegateObject.selectUsedUnusedType!(isNew: 2)
        }
    }
}

extension UIView {
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

