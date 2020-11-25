//
//  ProductDetailVC+ScrollDelegates.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 25/03/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

extension ProductDetailVC: UIScrollViewDelegate {
    
    //MARK:- Private Methods
    //MARK:-
    
    func startTimer() {
        if let count = productDetail?.data?.items_image?.count, count > 1 , timer == nil {
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
        let itemIndex = Int(index) % (productDetail?.data?.items_image?.count)!
        customPageControl.currentPage = itemIndex
        customPageControl?.isUserInteractionEnabled = false
    }
    
    //MARK:- ScrollView Delegates
    //MARK:-
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView.tag == 10 {
//            self.stopTimer()
        } else {
            self.lastContentOffset = scrollView.contentOffset.y
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.tag == 10 {
//            self.startTimer()
        } else {
            UIView.animate(withDuration: 0.2) {
                self.offerButtonBottomConstraint.constant = 10
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.tag == 10 {
            if let collectionView = scrollView as? UICollectionView {
                setPager(collectionView: collectionView)
            }
        } else {
            if !isMyItem && self.offerButtonBottomConstraint.constant == -85 {
                UIView.animate(withDuration: 0.2) {
                    self.offerButtonBottomConstraint.constant = 10
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.tag == 10 {
            if let collectionView = scrollView as? UICollectionView {
                if productDetail != nil {
                    centerIfNeeded(collectionView: collectionView)
                    setPager(collectionView: collectionView)
                }
            }
        } else {
            if !isMyItem && self.lastContentOffset <= scrollView.contentOffset.y {
                if  self.offerButtonBottomConstraint.constant == 20 {
                    UIView.animate(withDuration: 0.2) {
                        self.offerButtonBottomConstraint.constant = -85
                        self.view.layoutIfNeeded()
                    }
                }
                //Move Up
            } else if (self.lastContentOffset > scrollView.contentOffset.y) {
                
            }
        }
    }
}


