//
//  OnboardingVC+ScrollView.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 23/11/18.
//  Copyright © 2018 MobileCoderz. All rights reserved.
//
import UIKit
extension OnboardingVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
        pageControl.currentPage = currentPage
        labelDetail.text = model[currentPage].text
        
        if currentPage == model.count - 1 {
            buttonSkip.isHidden = true
            buttonNext.setTitle("DONE", for: .normal)
        } else {
            buttonNext.setTitle("NEXT", for: .normal)
            buttonSkip.isHidden = false
        }
    }
}
