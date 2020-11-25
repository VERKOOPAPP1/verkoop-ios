//
//  SortFilterTableCell.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 31/01/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class SortFilterTableCell: UITableViewCell {

    @IBOutlet weak var buttonCheckUncheck: UIButton!
    @IBOutlet weak var buttonSelectSortFilter: UIButton!
    @IBOutlet weak var labelSortFilterName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
