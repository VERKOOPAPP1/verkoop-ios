//
//  HomeVC+ScrollView.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 07/12/18.
//  Copyright © 2018 MobileCoderz. All rights reserved.
//

import UIKit
extension HomeVC: UIScrollViewDelegate {
    
    //MARK:- Private Methods
    //MARK:-
    
    func startTimer() {
        if let count = itemData?.data?.advertisments?.count, count > 1 , timer == nil {
            let timeInterval = 2.0
            timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(rotate), userInfo: nil, repeats: true)
            timer!.fireDate = NSDate().addingTimeInterval(timeInterval) as Date
        }
    }
    
    @objc func rotate() {
        let offset = CGPoint(x: advertiseCollectionView.contentOffset.x + kScreenWidth, y: advertiseCollectionView.contentOffset.y)
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
        } else if (currentOffset.x + kScreenWidth) >= contentWidth {
            let difference = (currentOffset.x + kScreenWidth) - contentWidth
             collectionView.contentOffset = CGPoint(x: width - (kScreenWidth + difference), y:currentOffset.y )
        }
    }
    
    func setPager(collectionView : UICollectionView) {
        let currentOffSet = collectionView.contentOffset
        let index = currentOffSet.x / collectionView.frame.size.width
        let itemIndex = Int(index)  %  (itemData?.data?.advertisments?.count)!
        customPageControl.currentPage = itemIndex
        customPageControl?.isUserInteractionEnabled = false
    }

    //MARK:- ScrollView Delegates
    //MARK:-
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let count = itemData?.data?.advertisments?.count, count > 0 {
            if scrollView.tag == HomeScreenCollectionView.advertisment.rawValue {
                if let collectionView = scrollView as? UICollectionView {
                    self.centerIfNeeded(collectionView: collectionView)
                    setPager(collectionView: collectionView)
                }
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let count = itemData?.data?.advertisments?.count, count > 0 {
            if scrollView.tag == HomeScreenCollectionView.advertisment.rawValue {
                self.stopTimer()
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if let count = itemData?.data?.advertisments?.count, count > 0 {
            if scrollView.tag == HomeScreenCollectionView.advertisment.rawValue {
                self.startTimer()
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let count = itemData?.data?.advertisments?.count, count > 0 {
            if scrollView.tag == HomeScreenCollectionView.advertisment.rawValue {
                if let collectionView = scrollView as? UICollectionView {
                    setPager(collectionView: collectionView)
                }
            } else {
                if textFieldSearch.isFirstResponder {
                    textFieldSearch.resignFirstResponder()
                }
            }
        } else {
            if textFieldSearch.isFirstResponder {
                textFieldSearch.resignFirstResponder()
            }
        }
    }
}
