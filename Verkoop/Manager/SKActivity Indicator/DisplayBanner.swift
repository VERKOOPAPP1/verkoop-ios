//
//  DisplayBanner.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 15/11/18.
//  Copyright © 2018 MobileCoderz. All rights reserved.
//

import BRYXBanner
class DisplayBanner {
    class func show(message:String?){
        let banner = Banner(title: message ?? ErrorMessages.somethingWentWrong, subtitle: "", image: nil, backgroundColor: UIColor.red)        
        banner.dismissesOnTap = true
        banner.show(duration: 1.2)        
    }
}
