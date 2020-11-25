//
//  SelectCategoryVC+ScrollView.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 07/12/18.
//  Copyright © 2018 MobileCoderz. All rights reserved.
//

import UIKit
extension SelectCategoryVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
        pageControl.currentPage = currentPage
    }
    
}
