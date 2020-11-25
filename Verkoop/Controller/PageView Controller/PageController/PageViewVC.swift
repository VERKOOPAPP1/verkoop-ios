//
//  PageViewVC.swift
//  Verkoop
//
//  Created by Vijay on 30/05/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

protocol PageControllerDelegates: class {
    func didPageChanged(index: Int)
}

class PageViewVC: UIPageViewController {
    
    var currentIndex = -1
    var controllers = [UIViewController]()
    weak var pageDelegate: PageControllerDelegates?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        let coinsVC = PurchaseCoinsVC.instantiate(fromAppStoryboard: .advertisement)
        let historyVC = CoinsHistoryVC.instantiate(fromAppStoryboard: .advertisement)
        controllers.append(coinsVC)
        controllers.append(historyVC)
        setViewController(index: 0)
        currentIndex = 0
    }

    func setViewController(index: Int) {
        if index == currentIndex {
            return
        } else if index > currentIndex { // forward
            setViewControllers([controllers[index]], direction: .forward, animated: true, completion: nil)
        } else { // backword
            setViewControllers([controllers[index]], direction: .reverse, animated: true, completion: nil)
        }
        currentIndex = index
    }
    
    required init?(coder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options:nil)
    }
}

extension PageViewVC: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let currentIndex = controllers.firstIndex(of: viewController) {
            let previousIndex = currentIndex - 1
            return (previousIndex == -1) ? nil : controllers[previousIndex]
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let currentIndex = controllers.firstIndex(of: viewController) {
            let nextIndex = currentIndex + 1
            return (nextIndex == controllers.count) ? nil : controllers[nextIndex]
        }
        return nil
    }
}

extension PageViewVC: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let delegateObject = pageDelegate {
            if let _ = previousViewControllers.first as? PurchaseCoinsVC {
                self.currentIndex = 1
            } else {
                self.currentIndex = 0
            }
            delegateObject.didPageChanged(index: currentIndex)
        }
    }
}
