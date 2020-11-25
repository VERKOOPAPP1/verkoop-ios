
//
//  TitleAndCheckBoxCell.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 13/03/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit
import SnapKit

class TitleAndCheckBoxCell: UITableViewCell {
    
    let titleLabel: UILabel = {
        $0.font = UIFont.kAppDefaultFontBold(ofSize: 16.0)
        $0.textColor = .darkGray
        $0.backgroundColor = .white
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        return $0
    }(UILabel())
    
    internal var checkButton: UIButton = {
        $0.setImage(UIImage(named: "checkbox_inactive"), for: .normal)
        $0.setImage(UIImage(named: "checkbox_active"), for: .selected)
        return $0
    }(UIButton())
    
    let lineView: UIView = {
        $0.backgroundColor = .lightGray
        return $0
    }(UIView())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        addSubview(titleLabel)
        addSubview(checkButton)
        addSubview(lineView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(snp.left).offset(15)
            make.top.equalTo(snp.top).offset(4)
            make.bottom.equalTo(lineView.snp.top).offset(-4)
            make.right.equalTo(checkButton.snp.left).offset(10)
        }
        
        checkButton.snp.makeConstraints { (make) in
            make.top.equalTo(snp.top)
            make.bottom.equalTo(lineView.snp.top)
            make.right.equalTo(snp.right).offset(-4)
            make.width.equalTo(50)
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
