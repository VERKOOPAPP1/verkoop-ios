//
//  AddCarSell.swift
//  Verkoop
//
//  Created by Vijay on 20/05/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class PropertyTypeCell: UITableViewCell {

    @IBOutlet var propertyTypeButton: [UIButton]!
    
    var delegate: AddDetailDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        for button in propertyTypeButton {
            button.setRadius(6, UIColor(hexString: "#C6C6C6"), 1.5)
        }
    }
    
    func setSelectedButton(propertyType: String) {
        var selectedIndex = 0
        if propertyType == "House" {
            selectedIndex = 0
        } else if propertyType == "Flat" {
            selectedIndex = 1
        } else if propertyType == "Townhouse" {
            selectedIndex = 2
        } else if propertyType == "Land" {
            selectedIndex = 3
        } else if propertyType == "Farm" {
            selectedIndex = 4
        } else {
            selectedIndex = 0
        }
        DispatchQueue.main.async {
            self.propertyTypeButton[selectedIndex].setTitleColor(.white, for: .normal)
            self.propertyTypeButton[selectedIndex].backgroundColor = kAppDefaultColor
        }
    }
    
    @IBAction func propertyButtonAction(_ sender: UIButton) {
        for button in propertyTypeButton {
            DispatchQueue.main.async {
                button.setTitleColor(.lightGray, for: .normal)
                button.backgroundColor = UIColor(hexString: "#E9E9E9")
            }
        }
        DispatchQueue.main.async {
            sender.setTitleColor(.white, for: .normal)
            sender.backgroundColor = kAppDefaultColor
        }
        
        if let delegateObject = delegate {
            delegateObject.didSelectPropertyType?(propertyType: sender.titleLabel?.text ?? "")
        }
    }
    
    func getButtonFromIndex(tag: Int) -> UIButton {
        for button in propertyTypeButton {
            if button.tag == tag {
                return button
            }
        }
        return UIButton()
    }
}
