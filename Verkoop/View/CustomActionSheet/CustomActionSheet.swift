//
//  CustomActionSheet.swift
//  Verkoop
//
//  Created by Vijay on 05/04/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit
import SnapKit

class CustomActionSheet: UIView {
    
    let blurView : UIView = {
        $0.backgroundColor = .black
        $0.alpha = 0.0
        return $0
    }(UIView())
    
    let containerView : UIView = {
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        return $0
    }(UIView())
    
    lazy var tableView: UITableView = {
        $0.showsVerticalScrollIndicator = false
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle  = .none
        $0.backgroundColor = .clear
        return $0
    }(UITableView())
    
    let titleLabel: UILabel = {
        $0.text = "Why are you reporting this User?"
        $0.textColor = kAppDefaultColor
        $0.numberOfLines = 0
        $0.font = UIFont.kAppDefaultFontBold(ofSize: 18.0)
        return $0
    }(UILabel())
    
    let descriptionLabel: UILabel = {
        $0.text = ""
        $0.numberOfLines = 0
        $0.textColor = kAppDefaultColor
        $0.font = UIFont.kAppDefaultFontBold(ofSize: 16.0)
        return $0
    }(UILabel())
    
    let submitButton: UIButton = {
        $0.layer.cornerRadius = 22.5
        $0.setTitle(Titles.submit, for: .normal)
        $0.titleLabel?.font = UIFont.kAppDefaultFontMedium(ofSize: 16.0)
        $0.setTitleColor(.white, for: .normal)
        $0.tag = -1
        return $0
    }(UIButton())
    
    let cancelButton: UIButton = {
        $0.setTitle(Titles.cancel, for: .normal)
        $0.titleLabel?.font = UIFont.kAppDefaultFontMedium(ofSize: 16.0)
        $0.setTitleColor(.black, for: .normal)
        return $0
    }(UIButton())
    
    var reports : [Report] = []
    var delegate: ReportUserDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSetup()
    }
    
    public func initializeSetup() {
        addSubview(blurView)
        addSubview(containerView)
        containerView.addSubview(tableView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(cancelButton)
        containerView.addSubview(submitButton)
        
        blurView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        containerView.addShadow(offset: CGSize(width: 5, height: 5), color: .black, radius: 10, opacity: 0.7)
        containerView.makeRoundCorner(8)
        containerView.snp.makeConstraints { (make) in
            make.right.equalTo(snp.right).offset(-16)
            make.left.equalTo(snp.left).offset(16)
            make.bottom.equalTo(snp.bottom).offset(16)
            make.height.equalTo(0)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.right.equalTo(containerView.snp.right).offset(-16)
            make.left.equalTo(containerView.snp.left).offset(16)
            make.top.equalTo(containerView.snp.top).offset(8)
            make.height.greaterThanOrEqualTo(30)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalTo(containerView.snp.left).offset(8)
            make.right.equalTo(containerView.snp.right).offset(-8)
        }
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(tableView.snp.bottom).offset(10)
            make.left.equalTo(containerView.snp.left).offset(16)
            make.right.equalTo(containerView.snp.right).offset(-16)
            make.height.greaterThanOrEqualTo(30)
        }
        
        submitButton.addTarget(self, action: #selector(submitButtonAction(_:)), for: .touchUpInside)
        submitButton.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.left.equalTo(containerView.snp.left).offset(16)
            make.right.equalTo(cancelButton.snp.left).offset(8)
            make.bottom.equalTo(containerView.snp.bottom).offset(-8)
            make.height.equalTo(45)
        }
        submitButton.backgroundColor = kAppDefaultColor
        submitButton.makeRoundCorner(22.5)
        
        cancelButton.addTarget(self, action: #selector(cancelButtonAction(_:)), for: .touchUpInside)
        cancelButton.snp.makeConstraints { (make) in
            make.top.equalTo(submitButton.snp.top)
            make.right.equalTo(containerView.snp.right).offset(-16)
            make.bottom.equalTo(submitButton.snp.bottom)
            make.width.equalTo(submitButton.snp.width)
            make.height.equalTo(45)
        }
        
        self.layoutIfNeeded()
        
        tableView.register(UINib(nibName: ReuseIdentifier.SingleLabelCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.SingleLabelCell)
    }
    
    public func animateView(isAnimate: Bool = true) {
        if isAnimate {
            self.containerView.snp.remakeConstraints { (make) in
                make.left.equalTo(snp.left).offset(18)
                make.right.equalTo(snp.right).offset(-18)
                make.bottom.equalTo(snp.bottom).offset(-30)
                make.height.equalTo(self.frame.height * 0.83)
            }

            UIView.animate(withDuration: 0.35) {
                self.blurView.alpha = 0.4
                self.layoutIfNeeded()
            }
        } else {
            self.containerView.snp.remakeConstraints { (make) in
                make.left.equalTo(snp.left).offset(18)
                make.right.equalTo(snp.right).offset(-18)
                make.bottom.equalTo(snp.bottom).offset(-16)
                make.height.equalTo(0)
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                self.blurView.alpha = 0.0
                self.layoutIfNeeded()
            }) { (status) in
                self.removeFromSuperview()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func submitButtonAction(_ sender: UIButton) {
        if let delegateObject = delegate, sender.tag != -1 {
            delegateObject.didReportUser?(reportId: String.getString(reports[sender.tag].id))
            animateView(isAnimate: false)
        }
    }
    
    @objc func cancelButtonAction(_ sender: UIButton) {
        animateView(isAnimate: false)
    }
}

extension CustomActionSheet: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.SingleLabelCell, for: indexPath) as? SingleLabelCell else {
            return UITableViewCell()
        }
        let report = reports[indexPath.row]
        cell.title.font = UIFont.kAppDefaultFontBold(ofSize: 17.0)
        cell.title.textColor = (report.isSelected ?? false) ? kAppDefaultColor : .darkGray
        cell.title.text = report.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let report = reports[indexPath.row]
        if let value = report.isSelected, value  {
            return
        }
        
        guard let currentCell = tableView.cellForRow(at: indexPath) as? SingleLabelCell else {
            return
        }
        
        for (index, tempReport) in reports.enumerated() {
            if let value = tempReport.isSelected , value {
                reports[index].isSelected = false
                guard let previousCell = tableView.cellForRow(at: IndexPath(row: index, section: indexPath.section)) as? SingleLabelCell else {
                    return
                }
                previousCell.title.textColor = .black
                break
            }
        }
        submitButton.tag = indexPath.row
        reports[indexPath.row].isSelected = true
        currentCell.title.textColor = kAppDefaultColor
        UIView.animate(withDuration: 0.15) {
            self.descriptionLabel.text = report.description ?? report.name
            self.layoutIfNeeded()
        }
    }
}

