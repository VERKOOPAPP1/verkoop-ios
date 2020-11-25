//
//  CollectionViewCell.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 25/03/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class SingleCollectionViewCell: UITableViewCell {
    
    let pageControl: UIPageControl = {
        $0.pageIndicatorTintColor = .lightGray
        $0.currentPageIndicatorTintColor = .white
        $0.hidesForSinglePage = true
        return $0
    }(UIPageControl())
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 0.0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor(hexString: "#FAFAFA")
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        cv.isUserInteractionEnabled = true
        cv.isPrefetchingEnabled = true
        return cv
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        addSubview(collectionView)
        addSubview(pageControl)
        
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(snp.bottom).offset(-8)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
