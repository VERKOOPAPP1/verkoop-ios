//
//  CarAndPropertyCell.swift
//  Verkoop
//
//  Created by Vijay on 19/04/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class CarAndPropertyCell: UICollectionViewCell {
    
    let backView: UIView = {
        $0.backgroundColor = .white
        return $0
    }(UIView())
    
    let carImageView: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "cars")
        $0.isUserInteractionEnabled = true
        return $0
    }(UIImageView())
    
    let propertyImageView: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "property")
        $0.isUserInteractionEnabled = true
        return $0
    }(UIImageView())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(hexString: "#F5F5F5")
        addSubview(backView)
        addSubview(carImageView)
        addSubview(propertyImageView)
        
        backView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(snp.bottom).offset(-8)
        }
        
        carImageView.makeRoundCorner(7)
        carImageView.snp.makeConstraints { (make) in
            make.top.equalTo(snp.top).offset(16)
            make.left.equalTo(snp.left).offset(16)
            make.bottom.equalTo(backView.snp.bottom).offset(-16)
            make.width.equalTo(propertyImageView.snp.width)
        }
        
        propertyImageView.makeRoundCorner(7)
        propertyImageView.snp.makeConstraints { (make) in
            make.top.equalTo(snp.top).offset(16)
            make.left.equalTo(carImageView.snp.right).offset(16)
            make.right.equalTo(snp.right).offset(-16)
            make.bottom.equalTo(backView.snp.bottom).offset(-16)
        }
        layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
