//
//  BannerDetailVC+ScrollView.swift
//  Verkoop
//
//  Created by Vijay on 10/06/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation
extension BannerDetailVC: UIScrollViewDelegate {
    
    //MARK:- Private Methods
    //MARK:-
    
    func startTimer() {
        if let count = bannerData?.data?.banner?.count, count > 1 , timer == nil {
            let timeInterval = 2.0
            timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(rotate), userInfo: nil, repeats: true)
            timer!.fireDate = NSDate().addingTimeInterval(timeInterval) as Date
        }
    }
    
    @objc func rotate() {
        let offset = CGPoint(x: advertiseCollectionView.contentOffset.x + cellWidth, y: advertiseCollectionView.contentOffset.y)
        advertiseCollectionView.setContentOffset(offset, animated: true)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func centerIfNeeded(collectionView : UICollectionView) {
        let currentOffset = collectionView.contentOffset
        let contentWidth = self.totalContentWidth
        let width = contentWidth / CGFloat(dummyCount)
        if currentOffset.x < 0 {
            collectionView.contentOffset = CGPoint(x: width - currentOffset.x, y: currentOffset.y)
        } else if (currentOffset.x + cellWidth) >= contentWidth {
            let difference = (currentOffset.x + cellWidth) - contentWidth
            collectionView.contentOffset = CGPoint(x: width - (cellWidth + difference), y:currentOffset.y )
        }
    }
    
    func setPager(collectionView : UICollectionView) {
        let currentOffSet = collectionView.contentOffset
        let index = currentOffSet.x / collectionView.frame.size.width
        let itemIndex = Int(index)  %  (bannerData?.data?.banner?.count)!
        customPageControl.currentPage = itemIndex
        customPageControl?.isUserInteractionEnabled = false
    }
    
    //MARK:- ScrollView Delegates
    //MARK:-
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.tag == HomeScreenCollectionView.advertisment.rawValue {
            if let collectionView = scrollView as? UICollectionView {
                self.centerIfNeeded(collectionView: collectionView)
                setPager(collectionView: collectionView)
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView.tag == HomeScreenCollectionView.advertisment.rawValue {
            self.stopTimer()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.tag == HomeScreenCollectionView.advertisment.rawValue {
            self.startTimer()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.tag == HomeScreenCollectionView.advertisment.rawValue {
            if let collectionView = scrollView as? UICollectionView {
                setPager(collectionView: collectionView)
            }
        }
    }
}
