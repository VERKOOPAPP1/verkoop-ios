//
//  SingleButtonTableCell.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 25/03/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit
import QuartzCore
import Foundation

class SingleButtonTableCell: UITableViewCell {
    
    let applyButton: UIButton = {
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = kAppDefaultColor
        $0.titleLabel?.font = UIFont.kAppDefaultFontBold(ofSize: 18)
        return $0
    }(UIButton())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        addSubview(applyButton)
        
        applyButton.snp.makeConstraints { (make) in
            make.width.equalTo(self.frame.size.width*0.45)
            make.centerX.equalToSuperview()
            make.top.equalTo(snp.top).offset(5)
            make.bottom.equalTo(snp.bottom).offset(-5)
        }
        applyButton.setRadius(applyButton.frame.height/2, .white, 3)
    }
        
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


