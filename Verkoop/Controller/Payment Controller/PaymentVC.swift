//
//  PaymentVC.swift
//  Verkoop
//
//  Created by Vijay on 18/06/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Stripe

class PaymentVC: UIViewController {
    
    let headerTitleLabel: UILabel = {
        $0.font = UIFont.kAppDefaultFontBold(ofSize: 18.0)
        $0.text = "Make Payment"
        $0.textColor = .white
        return $0
    }(UILabel())
    
    let headerView: UIView = {
        $0.backgroundColor = kAppDefaultColor
        return $0
    }(UIView())
    
    let backButton: UIButton = {
        $0.setImage(UIImage(named: "back"), for: .normal)
        return $0
    }(UIButton())
    
    let makePaymentButton: UIButton = {
        let button = UIButton()
        button.setTitle("Make Payment", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
     func initialSetup() {
        view.backgroundColor = .white
        view.addSubview(headerView)
        view.addSubview(makePaymentButton)
        headerView.addSubview(headerTitleLabel)
        headerView.addSubview(backButton)
        
        headerView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(view.frame.height*0.12)
        }
        
        backButton.addTarget(self, action: #selector(backButtonAction(_:)), for: .touchUpInside)
        backButton.snp.makeConstraints { (make) in
            make.left.equalTo(5)
            make.top.equalTo(20)
            make.width.equalTo(40)
            make.bottom.equalTo(headerView.snp.bottom)
        }
        
        headerTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(backButton.snp.right).offset(10)
            make.centerY.equalTo(backButton)
        }
        
        makePaymentButton.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(headerView.snp.bottom)
            make.bottom.equalTo(0)
        }
        makePaymentButton.addTarget(self, action: #selector(makeCardPayment(_:)), for: .touchUpInside)

    }
    
    @objc func backButtonAction(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func makeCardPayment(_ sender: UIButton) {
        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self
        
        let navigationController = UINavigationController(rootViewController: addCardViewController)
        present(navigationController, animated: true)
    }
}
