//
//  FilterCategoryImageCell.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 29/03/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit
import SnapKit

class FilterCategoryImageCell: UICollectionViewCell {
    
    var categoryNameLabel: UILabel!
    var categoryImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let backView = UIView()
        backView.layer.borderColor = UIColor.lightGray.cgColor
        backView.layer.cornerRadius = 6.0
        backView.addShadow(offset: CGSize(width: 2, height: 5), color: .gray, radius: 5, opacity: 0.6)
        addSubview(backView)
        backView.snp.makeConstraints { (make) in
            make.left.equalTo(snp.left).offset(5)
            make.right.equalTo(snp.right).offset(-5)
            make.top.equalTo(snp.top).offset(5)
            make.bottom.equalTo(snp.bottom).offset(-5)
        }
        
        categoryNameLabel = UILabel()
        categoryImageView = UIImageView()
        addSubview(categoryImageView)
        addSubview(categoryNameLabel)
        categoryImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(backView)
        }
        categoryImageView.contentMode = .scaleAspectFit
        
        categoryNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(categoryImageView.snp.left).offset(3)
            make.right.equalTo(categoryImageView.snp.right).offset(-3)
            make.bottom.equalTo(categoryImageView.snp.bottom).offset(-12)
        }
        categoryNameLabel.font = UIFont.kAppDefaultFontMedium(ofSize: 12)
        categoryNameLabel.textAlignment = .center
        categoryNameLabel.textColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadData(subCat: SubCategory) {
        categoryNameLabel.text = String.getString(subCat.name)
        if let url = URL(string: String.getString(subCat.image)) {
            categoryImageView.kf.setImage(with: url)
        } else {
            categoryImageView.image = UIImage(named: "post_placeholder")
        }
    }
}
