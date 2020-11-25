//
//  ProfileHeaderView.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 06/02/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class ProfileHeaderView: UICollectionReusableView {

    @IBOutlet weak var coinView: UIView!
    @IBOutlet weak var walletView: UIView!
    @IBOutlet weak var shareShadowView: UIView!
    @IBOutlet weak var reviewShadowView: UIView!
    @IBOutlet weak var followerShadowView: UIView!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var joiningDataLabel: UILabel!
    @IBOutlet weak var verficicaitonTypeLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var goodRatingButton: UIButton!
    @IBOutlet weak var poorRatingButton: UIButton!
    @IBOutlet weak var averageRatingButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var walletButton: UIButton!
    @IBOutlet weak var getCoinsButton: UIButton!
    @IBOutlet weak var seeFollowerButton: UIButton!    
    @IBOutlet weak var seeFollowingButton: UIButton!
    override func awakeFromNib() {
        setUpView()        
    }
    
    func setUpView() {
        coinView.makeRoundCorner(8)
        walletView.makeRoundCorner(8)
        
        shareShadowView.setRadius(8)
        shareShadowView.addShadow(offset: CGSize(width: 5, height: 5), color: .darkGray, radius: 5, opacity: 0.5)
        
        reviewShadowView.setRadius(8)
        reviewShadowView.addShadow(offset: CGSize(width: 5, height: 5), color: .darkGray, radius: 5, opacity: 0.5)
        
        followerShadowView.setRadius(8)
        followerShadowView.addShadow(offset: CGSize(width: 5, height: 5), color: .darkGray, radius: 5, opacity: 0.5)
    }
}
