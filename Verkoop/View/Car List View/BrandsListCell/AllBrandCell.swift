//
//  AllBrandCell.swift
//  Verkoop
//
//  Created by Vijay on 30/04/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class AllBrandCell: UICollectionViewCell {
    
    let brandImageView: UIImageView = {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .clear
        return $0
    }(UIImageView())
    
    var brandNameLabel: UILabel = {
        $0.numberOfLines = 1
        $0.text = ""
        $0.textColor = kAppDefaultColor
        $0.textAlignment = .center
        $0.font = UIFont.kAppDefaultFontBold(ofSize: 13)
        return $0
    }(UILabel())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        addSubview(brandImageView)
        addSubview(brandNameLabel)
        
        brandImageView.makeRoundCorner(6)
        brandImageView.snp.makeConstraints { (make) in
            make.top.equalTo(16)
            make.width.equalTo(frame.width * 0.45)
            make.centerX.equalTo(snp.centerX)
            make.height.equalTo(frame.height * 0.45)
            make.bottom.equalTo(brandNameLabel.snp.top).offset(-10)
        }
        
        brandNameLabel.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.left.equalTo(5)
            make.right.equalTo(-5)
            make.bottom.equalTo(-10)
        }
        layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
