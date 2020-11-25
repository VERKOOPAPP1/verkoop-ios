//
//  BrandsCollectionCell.swift
//  Verkoop
//
//  Created by Vijay on 19/04/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit
import SnapKit

enum DataOption {
    case brandType
    case bodyType
    case zoneType
}

//This can be used for Property / Car / Daily Picks / So many things
class BrandsCollectionCell: UICollectionViewCell {
    
    let backView: UIView = {
        $0.backgroundColor = .white
        return $0
    }(UIView())
    
    let topLineView: UIView = {
        $0.backgroundColor = UIColor(hexString: "#EBEBEB")
        return $0
    }(UIView())

    let bottomLineView: UIView = {
        $0.backgroundColor = UIColor(hexString: "#EBEBEB")
        return $0
    }(UIView())
    
    let brandLabel: UILabel = {
        $0.text = "Brands"
        $0.textColor = kAppDefaultColor
        $0.numberOfLines = 0
        $0.font = UIFont.kAppDefaultFontBold(ofSize: 16)
        return $0
    }(UILabel())

    let viewAllButton: UIButton = {
        $0.setTitle("View All", for: .normal)
        $0.titleLabel?.font = UIFont.kAppDefaultFontBold(ofSize: 16)
        $0.contentHorizontalAlignment = .right
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
        $0.setTitleColor(.gray, for: .normal)
        return $0
    }(UIButton())
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 0.0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.showsHorizontalScrollIndicator = false
        cv.isUserInteractionEnabled = true
        cv.isPrefetchingEnabled = true
        return cv
    }()
    
    var type = DataOption.brandType
    var brands: [Category]?
    var carBodies: [Category]?
    var bottomConstraint: Constraint!
    var zoneArray: [[String:String]] = [["id":"1", "name":"East", "image":"http://verkoopadmin.com/VerkoopApp/public/images/zones/d_west.png"], ["id":"2", "name":"West", "image": "http://verkoopadmin.com/VerkoopApp/public/images/zones/d_south.png"], ["id":"3", "name":"North East", "image": "http://verkoopadmin.com/VerkoopApp/public/images/zones/d_north.png"], ["id":"3", "name":"North", "image": "http://verkoopadmin.com/VerkoopApp/public/images/zones/d_east.png"], ["id":"4", "name":"Central", "image": "http://verkoopadmin.com/VerkoopApp/public/images/zones/d_west.png"]]
    var delegate: FilteredSelectedDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        addSubview(backView)
        addSubview(topLineView)
        addSubview(bottomLineView)
        addSubview(brandLabel)
        addSubview(viewAllButton)
        addSubview(collectionView)
        
        backView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(8)
            make.right.equalTo(0)
            make.bottom.equalTo(snp.bottom).offset(-8)
        }
        
        brandLabel.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.top.equalTo(12)
            make.right.equalTo(viewAllButton.snp.left).offset(10)
        }

        topLineView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(brandLabel.snp.bottom)
            make.height.equalTo(1)
            make.bottom.equalTo(collectionView.snp.top)
        }
        
        viewAllButton.snp.makeConstraints { (make) in
            make.right.equalTo(0)
            make.top.equalTo(6)
            make.height.equalTo(45)
            make.bottom.equalTo(brandLabel.snp.bottom)
            make.width.equalTo(150)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(topLineView.snp.bottom)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(bottomLineView.snp.top)
        }
        
        bottomLineView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(0)
            bottomConstraint = make.bottom.equalTo(snp.bottom).offset(-20).constraint
        }
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
