//
//  BuyCoinsVC.swift
//  Verkoop
//
//  Created by Vijay on 29/05/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

class BuyCoinsVC: UIViewController {

    var pageVC: PageViewVC?
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var balancContainerView: UIView!
    @IBOutlet weak var buyCoinButton: UIButton!
    @IBOutlet weak var buyHistoryButton: UIButton!
    @IBOutlet weak var bottomTriangleImage: UIImageView!
    @IBOutlet weak var bottomTraingleSecondImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    fileprivate func initialSetup() {
        DispatchQueue.main.async {
            self.balancContainerView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 6)
            self.balancContainerView.addShadow(offset: CGSize(width: 3, height: 3), color: .black, radius: 5, opacity: 0.3)
            self.balanceLabel.text = "0"
        }
        NotificationCenter.default.addObserver(self, selector: #selector(coinPurchased(_:)), name: NSNotification.Name(NotificationName.CoinPurchased), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Constants.sharedAppDelegate.setSwipe(enabled: true, navigationController: navigationController)
    }
    
    @objc func coinPurchased(_ notification: Notification) {
        if let info = notification.userInfo {
            let oldCoin = Int.getInt(balanceLabel.text) + Int.getInt(info["coins"])
            DispatchQueue.main.async {
                self.balanceLabel.text = String.getString(oldCoin)
            }
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        pageVC = segue.destination as? PageViewVC
        pageVC?.pageDelegate = self
    }
    
    @IBAction func buyCoinsButtonAction(_ sender: UIButton) {
        if let _ = pageVC {
            pageVC?.currentIndex = 1
            pageVC?.setViewController(index: 0)
            addBottomArrow(forIndex: 0)
        }
    }
    
    @IBAction func historyButtonAction(_ sender: UIButton) {
        if let _ = pageVC {
            pageVC?.currentIndex = 0
            pageVC?.setViewController(index: 1)
            addBottomArrow(forIndex: 1)
        }
    }
}
