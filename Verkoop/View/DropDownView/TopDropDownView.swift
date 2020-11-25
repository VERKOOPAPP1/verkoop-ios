//
//  TopDropDownView.swift
//  Verkoop
//
//  Created by Vijay on 05/04/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation
import SnapKit

class TopDropDownView: UIView {
    
    let blurView : UIView = {
        $0.backgroundColor = .black
        $0.alpha = 0.4
        return $0
    }(UIView())

    let containerView : UIView = {
        $0.backgroundColor = .white
        return $0
    }(UIView())
    
    lazy var tableView: UITableView = {
        $0.showsVerticalScrollIndicator = false
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .none
        $0.isScrollEnabled = false
        $0.backgroundColor = .clear
        return $0
    }(UITableView())
    
    public func initializeSetup() {
        addSubview(blurView)
        addSubview(containerView)
        containerView.addSubview(tableView)
        
        blurView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { (make) in
            make.right.equalTo(containerView.snp.right).offset(-16)
            make.top.equalTo(containerView.snp.top).offset(16)
            make.height.equalTo(0)
            make.width.equalTo(0)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(containerView)
        }
    }
    
    public func animateView(isAnimate: Bool = true) {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension TopDropDownView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
}
