//
//  TextViewCell.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 14/03/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class TextViewCell: UITableViewCell {

   lazy var textView: UITextView = {
        $0.font = UIFont.kAppDefaultFontBold(ofSize: 16.0)
        $0.textColor = .lightGray
        $0.autocorrectionType = .no
        $0.text = "Describe what you are selling and include any detail a buyer might be intrested in. People love item what stories"
        return $0
    }(UITextView())
    
    let lineView: UIView = {
        $0.backgroundColor = .lightGray
        return $0
    }(UIView())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        addSubview(textView)
        addSubview(lineView)
        
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(snp.top).offset(6)
            make.left.equalTo(snp.left).offset(8)
            make.right.equalTo(snp.right).offset(-8)
            make.bottom.equalTo(lineView.snp.top).offset(-4)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.bottom.equalTo(0)
            make.left.equalTo(snp.left).offset(8)
            make.right.equalTo(snp.right).offset(-8)
        }

        textView.doneAccessory = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }    
}

