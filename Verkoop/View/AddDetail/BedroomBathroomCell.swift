//
//  BedroomBathroomCell.swift
//  Verkoop
//
//  Created by Vijay on 23/04/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class BedroomBathroomCell: UITableViewCell {
    
    let titleLabel: UILabel = {
        $0.font = UIFont.kAppDefaultFontBold(ofSize: 16.0)
        $0.textColor = .lightGray
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        $0.text = "Bedroom"
        return $0
    }(UILabel())
    
    let counterLabel: UILabel = {
        $0.font = UIFont.kAppDefaultFontBold(ofSize: 22)
        $0.textColor = .lightGray
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        $0.text = "0"
        return $0
    }(UILabel())
    
    internal var decreaseButton: UIButton = {
        $0.setTitle("-", for: .normal)
        $0.backgroundColor = kAppDefaultColor
        $0.titleLabel?.font = UIFont.kAppDefaultFontBold(ofSize: 22)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
        return $0
    }(UIButton())
    
    internal var increaseButton: UIButton = {
        $0.setTitle("+", for: .normal)
        $0.backgroundColor = kAppDefaultColor
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.titleLabel?.font = UIFont.kAppDefaultFontBold(ofSize: 22)
        return $0
    }(UIButton())
    
    let lineView: UIView = {
        $0.backgroundColor = .white
        return $0
    }(UIView())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        addSubview(titleLabel)
        addSubview(increaseButton)
        addSubview(decreaseButton)
        addSubview(counterLabel)
        addSubview(lineView)

        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(snp.left).offset(20)
            make.top.equalTo(snp.top).offset(6)
            make.bottom.equalTo(lineView.snp.top).offset(-6)
        }
        
        increaseButton.snp.makeConstraints { (make) in
            make.top.equalTo(snp.top).offset(10)
            make.bottom.equalTo(lineView.snp.top).offset(-10)
            make.right.equalTo(snp.right).offset(-16)
            make.width.equalTo(40)
        }
        
        counterLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(increaseButton.snp.centerY)
            make.right.equalTo(increaseButton.snp.left).offset(-8)
            make.width.greaterThanOrEqualTo(20)
        }
        
        decreaseButton.snp.makeConstraints { (make) in
            make.top.equalTo(snp.top).offset(10)
            make.bottom.equalTo(lineView.snp.top).offset(-10)
            make.right.equalTo(counterLabel.snp.left).offset(-8)
            make.width.equalTo(40)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(snp.left).offset(8)
            make.height.equalTo(1)
            make.bottom.equalTo(snp.bottom)
            make.right.equalTo(snp.right).offset(-8)
        }
        layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
