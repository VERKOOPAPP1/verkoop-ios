//
//  BudgetCell.swift
//  Verkoop
//
//  Created by Vijay on 19/04/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class BudgetCell: UICollectionViewCell {
    
    let budgetLabel: UILabel = {
        $0.text = "Budget Filter"
        $0.textColor = .gray
        $0.numberOfLines = 1
        $0.font = UIFont.kAppDefaultFontBold(ofSize: 16)
        return $0
    }(UILabel())
    
    let lineView: UIView = {
        $0.backgroundColor = UIColor(hexString: "#EBEBEB")
        return $0
    }(UIView())
    
    let lowBudgetButton: UIButton = {
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(string: "<15K / Month\n", attributes: [NSAttributedString.Key.font: UIFont.kAppDefaultFontBold(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black]))
        attributedString.append(NSAttributedString(string: "Household Income", attributes: [NSAttributedString.Key.font: UIFont.kAppDefaultFontRegular(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.gray]))
        $0.setAttributedTitle(attributedString, for: .normal)
        $0.titleLabel?.numberOfLines = 0
        $0.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        $0.backgroundColor = .white
        return $0
    }(UIButton())
    
    let mediumBudgetButton: UIButton = {
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(string: ">15K / Month\n", attributes: [NSAttributedString.Key.font: UIFont.kAppDefaultFontBold(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black]))
        attributedString.append(NSAttributedString(string: "Household Income", attributes: [NSAttributedString.Key.font: UIFont.kAppDefaultFontRegular(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.gray]))
        $0.setAttributedTitle(attributedString, for: .normal)
        $0.setTitle(">15K / Month\nHousehold Income", for: .normal)
        $0.titleLabel?.numberOfLines = 0
        $0.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        $0.backgroundColor = .white
        return $0
    }(UIButton())
    
    let highBudgetButton: UIButton = {
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(string: "<25K / Month\n", attributes: [NSAttributedString.Key.font: UIFont.kAppDefaultFontBold(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black]))
        attributedString.append(NSAttributedString(string: "Household Income", attributes: [NSAttributedString.Key.font: UIFont.kAppDefaultFontRegular(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.gray]))
        $0.setAttributedTitle(attributedString, for: .normal)
        $0.titleLabel?.numberOfLines = 0
        $0.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        $0.backgroundColor = .white
        return $0
    }(UIButton())
    
    let fullBudgetButton: UIButton = {
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(string: ">25K / Month\n", attributes: [NSAttributedString.Key.font: UIFont.kAppDefaultFontBold(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black]))
        attributedString.append(NSAttributedString(string: "Household Income", attributes: [NSAttributedString.Key.font: UIFont.kAppDefaultFontRegular(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.gray]))
        $0.setAttributedTitle(attributedString, for: .normal)
        $0.titleLabel?.numberOfLines = 0
        $0.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        $0.backgroundColor = .white
        return $0
    }(UIButton())

    
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white
        addSubview(budgetLabel)
        addSubview(lowBudgetButton)
        addSubview(mediumBudgetButton)
        addSubview(highBudgetButton)
        addSubview(fullBudgetButton)
        addSubview(lineView)
        budgetLabel.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.top.equalTo(5)
            make.height.equalTo(30)
        }
        
        lowBudgetButton.makeRoundCorner(4)
        lowBudgetButton.addShadow(offset: CGSize(width: 3, height: 3), color: .black, radius: 5, opacity: 0.3)
        lowBudgetButton.snp.makeConstraints { (make) in
            make.top.equalTo(budgetLabel.snp.bottom).offset(8)
            make.left.equalTo(16)
            make.right.equalTo(mediumBudgetButton.snp.left).offset(-16)
            make.width.equalTo(mediumBudgetButton.snp.width)
        }
        
        mediumBudgetButton.makeRoundCorner(4)
        mediumBudgetButton.addShadow(offset: CGSize(width: 3, height: 3), color: .black, radius: 5, opacity: 0.3)
        mediumBudgetButton.snp.makeConstraints { (make) in
            make.top.equalTo(budgetLabel.snp.bottom).offset(8)
            make.right.equalTo(-16)
            make.height.equalTo(lowBudgetButton.snp.height)
        }
        
        highBudgetButton.makeRoundCorner(4)
        highBudgetButton.addShadow(offset: CGSize(width: 3, height: 3), color: .black, radius: 5, opacity: 0.3)
        highBudgetButton.snp.makeConstraints { (make) in
            make.top.equalTo(lowBudgetButton.snp.bottom).offset(10)
            make.left.equalTo(16)
            make.right.equalTo(fullBudgetButton.snp.left).offset(-16)
            make.width.equalTo(fullBudgetButton.snp.width)
            make.height.equalTo(lowBudgetButton.snp.height)
            make.bottom.equalTo(lineView.snp.top).offset(-20)
        }
        
        fullBudgetButton.makeRoundCorner(4)
        fullBudgetButton.addShadow(offset: CGSize(width: 3, height: 3), color: .black, radius: 5, opacity: 0.3)
        fullBudgetButton.snp.makeConstraints { (make) in
            make.top.equalTo(mediumBudgetButton.snp.bottom).offset(10)
            make.right.equalTo(-16)
            make.bottom.equalTo(lineView.snp.top).offset(-20)
            make.height.equalTo(mediumBudgetButton.snp.height)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(1)
        }
        layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
