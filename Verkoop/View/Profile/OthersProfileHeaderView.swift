//
//  OthersProfileHeaderView.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 03/04/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class OthersProfileHeaderView: UICollectionReusableView {
    @IBOutlet weak var reviewShadowView: UIView!
    @IBOutlet weak var followerShadowView: UIView!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var joiningDataLabel: UILabel!
    @IBOutlet weak var verficicaitonTypeLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    
    @IBOutlet weak var goodRatingButton: UIButton!
    @IBOutlet weak var poorRatingButton: UIButton!
    @IBOutlet weak var averageRatingButton: UIButton!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var seeFollowerButton: UIButton!
    @IBOutlet weak var seeFollowingButton: UIButton!
    
    override func awakeFromNib() {
        setUpView()
    }
    
    func setUpView() {
        
        followButton.makeRoundCorner(followButton.frame.height/2)
        
        reviewShadowView.setRadius(8)
        reviewShadowView.addShadow(offset: CGSize(width: 5, height: 5), color: .darkGray, radius: 5, opacity: 0.5)
        
        followerShadowView.setRadius(8)
        followerShadowView.addShadow(offset: CGSize(width: 5, height: 5), color: .darkGray, radius: 5, opacity: 0.5)
        layoutIfNeeded()
    }
}
