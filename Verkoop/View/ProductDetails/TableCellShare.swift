//
//  TableCellShare.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 07/02/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class TableCellShare: UITableViewCell {

    @IBOutlet weak var defaultShareButton: UIButton!
    @IBOutlet weak var facebookShareButton: UIButton!
    @IBOutlet weak var whatsappShareButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
