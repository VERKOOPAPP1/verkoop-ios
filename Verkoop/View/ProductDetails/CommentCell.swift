//
//  CommentCell.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 25/03/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class CommentTableCell: UITableViewCell {
    
    var titleLabel: UILabel = {
        $0.numberOfLines = 1
        $0.text = Titles.comments
        $0.textColor = .darkGray
        $0.font = UIFont.kAppDefaultFontBold(ofSize: 18.0)
        return $0
    }(UILabel())
    
    let commentButton: UIButton = {
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        $0.contentHorizontalAlignment = .right
        $0.setTitleColor(kAppDefaultColor, for: .normal)
        $0.titleLabel?.font = UIFont.kAppDefaultFontBold(ofSize: 17)
        $0.setTitle(Titles.postComment, for: .normal)
        return $0
    }(UIButton())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        addSubview(commentButton)
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(snp.centerY)
            make.left.equalTo(snp.left).offset(16)
            make.width.equalTo(100)
        }
        
        commentButton.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right).offset(10)
            make.top.equalTo(snp.top).offset(5)
            make.right.equalTo(snp.right).offset(-8)
            make.bottom.equalTo(snp.bottom).offset(-5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
