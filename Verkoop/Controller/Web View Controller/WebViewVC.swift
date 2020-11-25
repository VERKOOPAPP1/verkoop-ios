//
//  WebViewVC.swift
//  Verkoop
//
//  Created by Vijay Singh Raghav on 10/10/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import WebKit

class WebViewVC: UIViewController {

    let headerTitleLabel: UILabel = {
        $0.font = UIFont.kAppDefaultFontBold(ofSize: 18.0)
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
    
    lazy var contentWebView: WKWebView = {
        let webView = WKWebView(frame: CGRect.zero, configuration: WKWebViewConfiguration())
        webView.navigationDelegate = self
        webView.allowsLinkPreview = true
        webView.uiDelegate = self
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        webView.sizeToFit()
        return webView
    }()
    
    var headerTitle = ""
    var urlString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        loadContent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Constants.sharedAppDelegate.setSwipe(enabled: true, navigationController: navigationController)
    }
    
    func initialSetup() {
        view.backgroundColor = .white
        view.addSubview(headerView)
        view.addSubview(contentWebView)
        headerView.addSubview(headerTitleLabel)
        headerView.addSubview(backButton)
        
        headerView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(view.snp.topMargin)
            make.right.equalTo(0)
            make.height.equalTo(60)
        } 
        
        backButton.addTarget(self, action: #selector(backButtonAction(_:)), for: .touchUpInside)
        backButton.snp.makeConstraints { (make) in
            make.left.equalTo(5)
            make.top.equalTo(0)
            make.width.equalTo(40)
            make.bottom.equalTo(headerView.snp.bottom)
        }
        
        headerTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(backButton.snp.right).offset(10)
            make.centerY.equalTo(backButton)
        }
        
        contentWebView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(headerView.snp.bottom).offset(1)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
    }
    
    func loadContent() {
        headerTitleLabel.text = headerTitle
        if let url = URL(string: urlString) {
            Loader.show()
            contentWebView.load(URLRequest(url: url))
        }
    }
    
    @objc func backButtonAction(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
