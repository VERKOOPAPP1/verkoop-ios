//
//  SearchedUserCell.swift
//  Verkoop
//
//  Created by Vijay on 10/04/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class SearchedUserCell: UITableViewCell {

    let profileImage: UIImageView = {
        $0.contentMode = .scaleAspectFill
        return $0
    }(UIImageView())
    
    var nameLabel: UILabel = {
        $0.numberOfLines = 1
        $0.text = "Username"
        $0.textColor = .black
        $0.font = UIFont.kAppDefaultFontBold(ofSize: 15)
        return $0
    }(UILabel())
    
    let followButton: UIButton = {
        $0.setTitle("Follow", for: .normal)
        $0.setTitle("Following", for: .selected)
        $0.setTitleColor(kAppDefaultColor, for: .normal)
        $0.setTitleColor(.darkGray, for: .selected)
        $0.titleLabel?.font = UIFont.kAppDefaultFontBold(ofSize: 15)
        return $0
    }(UIButton())
    
    let lineView: UIView = {
        $0.backgroundColor = .lightGray
        return $0
    }(UIView())
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        addSubview(profileImage)
        addSubview(nameLabel)
        addSubview(followButton)
        addSubview(lineView)
        
        profileImage.makeRoundCorner(27.5)
        profileImage.snp.makeConstraints { (make) in
            make.left.equalTo(snp.left).offset(12)
            make.top.equalTo(snp.top).offset(8)
            make.bottom.equalTo(lineView.snp.top).offset(-8)
            make.width.equalTo(55)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(profileImage.snp.right).offset(8)
            make.right.equalTo(followButton.snp.left).offset(10)
            make.height.equalTo(30)
            make.centerY.equalTo(profileImage.snp.centerY)
        }
        
        followButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(profileImage.snp.centerY)
            make.right.equalTo(snp.right).offset(-12)
            make.width.equalTo(90)
            make.height.equalTo(60)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(snp.left).offset(8)
            make.right.equalTo(snp.right).offset(-8)
            make.bottom.equalTo(snp.bottom)
            make.height.equalTo(1)
        }
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
