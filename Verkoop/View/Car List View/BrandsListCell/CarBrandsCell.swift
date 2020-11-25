
//
//  CarBrandsCell.swift
//  Verkoop
//
//  Created by Vijay on 18/04/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class CarBrandsCell: UICollectionViewCell {
    
    let backView: UIView = {
        $0.backgroundColor = .white
        return $0
    }(UIView())
    
    let brandImageView: UIImageView = {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.backgroundColor = .clear
        return $0
    }(UIImageView())
    
    let bodyImageView: UIImageView = {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.backgroundColor = .clear
        return $0
    }(UIImageView())
    
    var brandLabelView: UIView = {
        $0.backgroundColor = .black
        $0.alpha = 0.2
        return $0
    }(UIView())
    
    var brandNameLabel: UILabel = {
        $0.numberOfLines = 1
        $0.text = ""
        $0.textColor = .black
        $0.font = UIFont.kAppDefaultFontBold(ofSize: 11)
        return $0
    }(UILabel())

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        addSubview(backView)
        addSubview(brandImageView)
        addSubview(bodyImageView)
        addSubview(brandLabelView)
        addSubview(brandNameLabel)

        backView.makeRoundCorner(8)
        backView.snp.makeConstraints { (make) in
            make.left.equalTo(5)
            make.top.equalTo(5)
            make.right.equalTo(-5)
            make.bottom.equalTo(-5)
        }
        
        bodyImageView.makeRoundCorner(6)
        bodyImageView.snp.makeConstraints { (make) in
            make.left.equalTo(5)
            make.top.equalTo(5)
            make.right.equalTo(-5)
            make.bottom.equalTo(-5)
        }
        
        brandImageView.makeRoundCorner(6)
        brandImageView.snp.makeConstraints { (make) in
            make.top.equalTo(16)
            make.width.equalTo(frame.width * 0.45)
            make.centerX.equalTo(snp.centerX)
            make.height.equalTo(frame.height * 0.45)
        }
        
        brandNameLabel.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.bottom.equalTo(-10)
        }
        
        brandLabelView.snp.makeConstraints { (make) in
            make.left.equalTo(snp.left).offset(5)
            make.top.equalTo(brandNameLabel.snp.top)
            make.right.equalTo(snp.right).offset(-5)
            make.bottom.equalTo(bodyImageView.snp.bottom)
        }
        brandLabelView.addShadow(offset: CGSize(width: 5, height: 5), color: .black, radius: 5, opacity: 0.7)
        brandLabelView.isHidden = true
        layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
