//
//  CollectionCellSelectedPhotos.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 07/02/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class CollectionCellSelectedPhotos: UICollectionViewCell {

    let addimageView : UIImageView = {        
        $0.isUserInteractionEnabled = false
        $0.backgroundColor = UIColor(hexString: "#ECECEC")
        return $0
    }(UIImageView())
    
    @IBOutlet weak var imageSelectedPhoto: UIImageView!
    @IBOutlet weak var viewCount: UIView!
    @IBOutlet weak var labelCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewCount.isHidden = true
        addSubview(addimageView)
        addimageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(35)
        }
        imageSelectedPhoto.isUserInteractionEnabled = false
        addimageView.isHidden = true
        setUpView()
    }
    
    func setUpView() {
        viewCount.makeRounded()
        viewCount.makeBorder(3, color: .white)
    }
}
