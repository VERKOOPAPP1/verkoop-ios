//
//  SelectLocation+TableViewDelegates.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 13/03/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

extension SelectMeetupLocationVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.SelectLocationCell, for: indexPath) as! SelectLocationCell
        cell.titleLabel.text = locationArray[indexPath.row].name
        if let address = locationArray[indexPath.row].vicinity {
            cell.subTitleLabel.text = address
        } else if let address = locationArray[indexPath.row].formatted_address {
            cell.subTitleLabel.text = address
        } else {
            cell.subTitleLabel.text = ""
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegateObject = delegate {
            delegateObject.meetupLocation!(latitude: locationArray[indexPath.row].latitude ?? "", longitude: locationArray[indexPath.row].longitude ?? "", address: locationArray[indexPath.row].vicinity ?? locationArray[indexPath.row].formatted_address ?? "")
            navigationController?.popViewController(animated: true)
        }
    }
}
