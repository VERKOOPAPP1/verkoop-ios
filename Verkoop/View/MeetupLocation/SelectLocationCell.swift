//
//  SelectLocationCell.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 14/03/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class SelectLocationCell: UITableViewCell {

    let titleLabel: UILabel = {
        $0.font = UIFont.kAppDefaultFontBold(ofSize: 16.0)
        $0.textColor = .black
        $0.backgroundColor = .white
        $0.lineBreakMode = .byCharWrapping
        return $0
    }(UILabel())

    let subTitleLabel: UILabel = {
        $0.font = UIFont.kAppDefaultFontRegular(ofSize: 14.0)
        $0.textColor = .darkGray
        $0.backgroundColor = .white
        $0.lineBreakMode = .byCharWrapping
        return $0
    }(UILabel())
    
    let lineView : UIView = {
        $0.backgroundColor = .lightGray
        return $0
    }(UIView())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(lineView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(snp.top).offset(6)
            make.left.equalTo(snp.left).offset(10)
            make.right.equalTo(snp.right).offset(-8)
            make.height.equalTo(25)
        }

        subTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.left.equalTo(snp.left).offset(10)
            make.right.equalTo(snp.right).offset(-8)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(6)
            make.left.equalTo(snp.left).offset(10)
            make.right.equalTo(snp.right)
            make.bottom.equalTo(snp.bottom).offset(-1)
            make.height.equalTo(1)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
