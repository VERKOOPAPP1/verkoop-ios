//
//  SearchItemCell.swift
//  Verkoop
//
//  Created by Vijay on 10/04/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class SearchItemCell: UITableViewCell {
 
    let searchImage: UIImageView = {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "search")
        return $0
    }(UIImageView())
    
    var itemNameLabel: UILabel = {
        $0.numberOfLines = 1
        $0.text = "Username"
        $0.textColor = .black
        $0.font = UIFont.kAppDefaultFontBold(ofSize: 16)
        return $0
    }(UILabel())
    
    var itemCategoryLabel: UILabel = {
        $0.numberOfLines = 1
        $0.text = Titles.comments
        $0.textColor = .darkGray
        $0.font = UIFont.kAppDefaultFontMedium(ofSize: 16)
        return $0
    }(UILabel())
    
    let lineView : UIView = {
        $0.backgroundColor = .lightGray
        return $0
    }(UIView())
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        addSubview(searchImage)
        addSubview(itemNameLabel)
        addSubview(itemCategoryLabel)
        addSubview(lineView)
        
        searchImage.snp.makeConstraints { (make) in
            make.left.equalTo(snp.left).offset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(15)
            make.height.equalTo(15)
        }
        
        itemNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(snp.top).offset(8)
            make.left.equalTo(searchImage.snp.right).offset(16)
            make.right.equalTo(snp.right).offset(-8)
        }
        
        itemCategoryLabel.snp.makeConstraints { (make) in
            make.left.equalTo(searchImage.snp.right).offset(16)
            make.top.equalTo(itemNameLabel.snp.bottom)
            make.right.equalTo(snp.right).offset(-8)
            make.height.equalTo(itemNameLabel.snp.height)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(itemCategoryLabel.snp.bottom).offset(8)
            make.left.equalTo(snp.left).offset(8)
            make.right.equalTo(snp.right).offset(-8)
            make.height.equalTo(1)
        }
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
