//
//  Loader.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 15/11/18.
//  Copyright © 2018 MobileCoderz. All rights reserved.
//

import UIKit
class Loader {
    class func show() {
        SKActivityIndicator.spinnerStyle(.spinningCircle)
        SKActivityIndicator.spinnerColor(kAppDefaultColor)
        SKActivityIndicator.show("", userInteractionStatus: false)
    }
    
    class func hide() {
        SKActivityIndicator.dismiss()
    }
}
