//
//  MeetupLocationCell.swift
//  Verkoop
//
//  Created by Vijay on 11/04/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class MeetupLocationCell: UITableViewCell {
    
    var meetupLabel: UILabel = {
        $0.numberOfLines = 1
        $0.text = "Meet-up"
        $0.textColor = .gray
        $0.font = UIFont.kAppDefaultFontMedium(ofSize: 18)
        return $0
    }(UILabel())
    
    let markerImage: UIImageView = {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "address")
        return $0
    }(UIImageView())
    
    var addressLabel: UILabel = {
        $0.numberOfLines = 0
        $0.text = "Address"
        $0.textColor = .gray
        $0.font = UIFont.kAppDefaultFontBold(ofSize: 18)
        return $0
    }(UILabel())
    
    var detailAddressLabel: UILabel = {
        $0.numberOfLines = 0
        $0.text = "Not Available"
        $0.textColor = .blue
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
        addSubview(markerImage)
        addSubview(meetupLabel)
        addSubview(addressLabel)
        addSubview(detailAddressLabel)
        addSubview(lineView)
        
        meetupLabel.snp.makeConstraints { (make) in
            make.left.equalTo(snp.left).offset(20)
            make.top.equalTo(snp.top).offset(8)
            make.height.equalTo(25)
        }
        
        addressLabel.snp.makeConstraints { (make) in
            make.left.equalTo(markerImage.snp.right).offset(8)
            make.top.equalTo(meetupLabel.snp.bottom).offset(5)
            make.height.equalTo(25)
        }
        
        markerImage.snp.makeConstraints { (make) in
            make.left.equalTo(snp.left).offset(20)
            make.width.equalTo(15)
            make.centerY.equalTo(addressLabel.snp.centerY).offset(-1)
            make.height.equalTo(15)
        }
        
        detailAddressLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(addressLabel.snp.leading)
            make.top.equalTo(addressLabel.snp.bottom)
            make.right.equalTo(snp.right).offset(-8)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(detailAddressLabel.snp.bottom).offset(8)
            make.left.equalTo(snp.left).offset(8)
            make.right.equalTo(snp.right).offset(-8)
            make.bottom.equalTo(snp.bottom)
            make.height.equalTo(1)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
