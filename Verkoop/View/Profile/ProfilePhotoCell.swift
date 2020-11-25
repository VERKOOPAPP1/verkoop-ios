//
//  ProfilePhotoCell.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 26/03/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class ProfilePhotoCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}
