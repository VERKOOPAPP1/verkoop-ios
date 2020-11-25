//
//  BannerDetailVC+Protocols.swift
//  Verkoop
//
//  Created by Vijay on 10/06/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

extension BannerDetailVC: RefreshScreen {
    func refreshData() {
        requestBannerDetail(showLoader: false)
    }
}
