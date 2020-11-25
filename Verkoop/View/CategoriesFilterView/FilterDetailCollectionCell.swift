//
//  FilterDetailCollectionCell.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 31/01/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//


class FilterDetailCollectionCell: UICollectionViewCell {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var userProfielButton: UIButton!
    @IBOutlet weak var labelItemType: UILabel!    
    @IBOutlet weak var likeDislikeButton: UIButton!
    @IBOutlet weak var labelLikes: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelItemName: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelUsername: UILabel!
    @IBOutlet weak var imageUserProfile: UIImageView!
    @IBOutlet weak var imageItemCategory: UIImageView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var soldView: UIView!
    @IBOutlet weak var soldLabel: UILabel!
    @IBOutlet weak var verticalLineView: UIView!
    @IBOutlet weak var conditionHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }
    
    func configureView() {
        imageUserProfile.setRadius(20)
        imageItemCategory.setRadius(5)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        soldView.roundCorners(corners: [.topLeft, .topRight], radius: 5)
        soldLabel.roundCorners(corners: [.topLeft, .topRight], radius: 5)
    }
}
