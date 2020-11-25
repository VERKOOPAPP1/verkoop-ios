//
//  NotificationCell.swift
//  Verkoop
//
//  Created by Vijay Singh Raghav on 07/10/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

class NotificationCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var notificationImageView: UIImageView!
    
    var notificationObject: NotificationObject? {
        didSet {
            timeLabel.text = Utilities.sharedUtilities.getTimeDifference(dateString: String.getString(notificationObject?.created_at?.date?.split(separator: ".").first))
            headingLabel.text = notificationObject?.message
            descriptionLabel.text = notificationObject?.description
            if let url = URL(string: API.assetsUrl + (notificationObject?.image ?? "")) {
                notificationImageView.kf.setImage(with: url, placeholder: UIImage(named: "post_placeholder"))
            } else {
                notificationImageView.image = UIImage(named: "post_placeholder")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        notificationImageView.layoutIfNeeded()
        notificationImageView.makeRounded()
    }
}
