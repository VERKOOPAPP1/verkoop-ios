//
//  SwitchCell.swift
//  Verkoop
//
//  Created by Vijay on 19/04/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class SwitchCell: UITableViewCell {

    let titleLabel: UILabel = {
        $0.font = UIFont.kAppDefaultFontBold(ofSize: 17.0)
        $0.textColor = .lightGray
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        $0.text = "Are you a direct owner?"
        return $0
    }(UILabel())
    
    internal var directSwitch: UISwitch = {
        $0.setOn(false, animated: false)
        $0.thumbTintColor = kAppDefaultColor
        $0.onTintColor = .lightGray
        return $0
    }(UISwitch())
    
    let lineView: UIView = {
        $0.backgroundColor = .lightGray
        return $0
    }(UIView())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        backgroundColor = .white
        addSubview(titleLabel)
        addSubview(directSwitch)
        addSubview(lineView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(snp.left).offset(18)
            make.top.equalTo(snp.top).offset(4)
            make.bottom.equalTo(lineView.snp.top).offset(-4)
            make.right.equalTo(directSwitch.snp.left).offset(10)
        }
        
        directSwitch.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.right.equalTo(snp.right).offset(-4)
            make.width.equalTo(50)
            make.height.equalTo(30)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.bottom.equalTo(0)
            make.left.equalTo(snp.left).offset(8)
            make.right.equalTo(snp.right).offset(-8)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
