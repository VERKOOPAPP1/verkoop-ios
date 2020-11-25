//
//  WebViewVC+WebDelegates.swift
//  Verkoop
//
//  Created by Vijay Singh Raghav on 10/10/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import WebKit

extension WebViewVC: WKNavigationDelegate, WKUIDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Loader.hide()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        Loader.show()
    }
}
