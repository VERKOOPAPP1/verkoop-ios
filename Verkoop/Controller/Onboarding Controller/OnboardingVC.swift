//
//  OnboardingVC.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 23/11/18.
//  Copyright © 2018 MobileCoderz. All rights reserved.
//

import UIKit
struct Onboarding {
    let image: UIImage
    let text: String
    init(image: UIImage, text: String) {
        self.image = image
        self.text = text
    }
}

class OnboardingVC: UIViewController {
    @IBOutlet weak var collectionViewOnboarding: UICollectionView!
    var model = [Onboarding]()
    var currentPage = 0
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var buttonSkip: UIButton!
    @IBOutlet weak var buttonNext: UIButton!

    @IBOutlet weak var labelDetail: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewOnboarding.register(UINib.init(nibName: ReuseIdentifier.onboardingCollectionCell, bundle: nil), forCellWithReuseIdentifier: ReuseIdentifier.onboardingCollectionCell)
        collectionViewOnboarding.dataSource = self
        collectionViewOnboarding.delegate = self
        let onboarding1 = Onboarding(image: #imageLiteral(resourceName: "walkthrough1"), text: "It is long established fact that reader will be distracted by readable content")
        let onboarding2 = Onboarding(image: #imageLiteral(resourceName: "walkthrough2"), text: "It is long established fact that reader will be distracted by readable content")
        let onboarding3 = Onboarding(image: #imageLiteral(resourceName: "walkthrough3"), text: "It is long established fact that reader will be distracted by readable content")
        model.append(onboarding1)
        model.append(onboarding2)
        model.append(onboarding3)
        let imageView = UIImageView(image: #imageLiteral(resourceName: "background"))
        imageView.frame = collectionViewOnboarding.frame
        collectionViewOnboarding.backgroundView = imageView
    }
 
    @IBAction func buttonSkipTapped(_ sender: UIButton) {
        switchToLoginVC()
    }
    
    @IBAction func buttonNextTapped(_ sender: UIButton) {
        if currentPage == model.count - 1 {
            switchToLoginVC()
        } else {
            let indexPath = IndexPath(row: currentPage + 1, section: 0)
            collectionViewOnboarding.scrollToItem(at: indexPath, at: .left, animated: true)
        }
    }
    
    func switchToLoginVC() {
        let vc = LoginVC.instantiate(fromAppStoryboard: .registration)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension UIImage {
    func toBase64() -> String? {
        guard let imageData = self.pngData() else { return nil }
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
}
