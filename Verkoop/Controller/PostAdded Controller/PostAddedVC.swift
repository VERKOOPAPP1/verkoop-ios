//
//  PostAddedVC.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 06/02/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class PostAddedVC: UIViewController {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var itemCategoryLabel: UILabel!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var viewCardPostAdded: UIView!
    
    var itemName = ""
    var itemImage = ""
    var categoryName = ""
    var price = ""
    var delegate: AddDetailDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    func setUpView() {
        viewCardPostAdded.makeRoundCorner(10)
        itemNameLabel.text = itemName
        itemCategoryLabel.text = categoryName
        priceLabel.text = "R" + price
    }
    
    @IBAction func shareButtonAction(_ sender: UIButton) {
        Utilities.share(content: itemImage, controller: self, subjectLine: "Check the Verkoop App")
    }
    
    @IBAction func whatappButtonAction(_ sender: UIButton) {
        if !Utilities.shareOnWhatsApp(itemImage) {
            
        }
    }
    
    @IBAction func facebookButtonAction(_ sender: UIButton) {
        showShareDialog(shareString: itemImage)
    } 
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
        self.dismiss(animated: false) {
            if let delegateObject = self.delegate {
                delegateObject.didNavigateToProfileScreen!()
            }
        }
    }
}
