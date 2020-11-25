//
//  CommentListCell.swift
//  Verkoop
//
//  Created by Vijay on 09/04/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class CommentListCell: UITableViewCell {

    let profileImage: UIImageView = {        
        $0.contentMode = .scaleAspectFill
        return $0
    }(UIImageView())
    
    var nameLabel: UILabel = {
        $0.numberOfLines = 1
        $0.text = "Username"
        $0.textColor = .darkGray
        $0.font = UIFont.kAppDefaultFontMedium(ofSize: 16)
        return $0
    }(UILabel())

    var commentLabel: UILabel = {
        $0.numberOfLines = 0
        $0.text = Titles.comments
        $0.textColor = .black
        $0.font = UIFont.kAppDefaultFontBold(ofSize: 17)
        return $0
    }(UILabel())
    
    var timeLabel: UILabel = {
        $0.numberOfLines = 1
        $0.text = Titles.comments
        $0.textColor = .darkGray
        $0.font = UIFont.kAppDefaultFontMedium(ofSize: 14)
        return $0
    }(UILabel())
    
    let deleteButton: UIButton = {
        var image = UIImage(named: "more")?.rotateImage(degrees: CGFloat(Double.pi/2))
        image = image?.imageWithColor(.black)
        $0.setImage(image, for: .normal)
        return $0
    }(UIButton())
    
    let lineView : UIView = {
        $0.backgroundColor = .lightGray
        return $0
    }(UIView())

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubview(profileImage)
        addSubview(nameLabel)
        addSubview(commentLabel)
        addSubview(timeLabel)
        addSubview(deleteButton)
        addSubview(lineView)

        profileImage.makeRoundCorner(30)
        profileImage.snp.makeConstraints { (make) in
            make.left.equalTo(snp.left).offset(12)
            make.top.equalTo(snp.top).offset(8)
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(profileImage.snp.right).offset(8)
            make.top.equalTo(snp.top).offset(8)
            make.right.equalTo(deleteButton.snp.left).offset(10)
            make.height.equalTo(28)
        }
        
        commentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(profileImage.snp.right).offset(8)
            make.top.equalTo(nameLabel.snp.bottom)
            make.right.equalTo(deleteButton.snp.left).offset(10)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(profileImage.snp.right).offset(8)
            make.top.equalTo(commentLabel.snp.bottom)
            make.right.equalTo(deleteButton.snp.left).offset(10)
            make.height.equalTo(28)
        }
        
        deleteButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(profileImage.snp.centerY)
            make.right.equalTo(snp.right).offset(-10)
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(timeLabel.snp.bottom).offset(8)
            make.left.equalTo(snp.left).offset(8)
            make.height.equalTo(1)
            make.right.equalTo(snp.right).offset(-8)
            make.bottom.equalTo(snp.bottom)
        }
        self.layoutIfNeeded()
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
