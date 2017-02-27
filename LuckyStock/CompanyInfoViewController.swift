//
//  CompanyInfoViewController.swift
//  LuckyStock
//
//  Created by 吳建豪 on 2017/2/28.
//  Copyright © 2017年 吳建豪. All rights reserved.
//

import Foundation
import UIKit
import LBTAComponents

class CompanyInfoViewController:UIViewController {
    
    
    var stock:LuckyStock?
    var myActivityIndicator = UIActivityIndicatorView.spinner
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    var webView:UIWebView!
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        webView = UIWebView()
        webView.scalesPageToFit = true
        view.addSubview(webView)
        view.addSubview(myActivityIndicator)
        webView.fillSuperview()
        myActivityIndicator.anchorCenterSuperview()
        if let stockNumber = stock?.number ,let url = URL(string:"http://pchome.m.megatime.com.tw/stock/sid\(stockNumber).html") {
            let urlRequest = URLRequest(url: url)
            webView?.loadRequest(urlRequest)
        }
             myActivityIndicator.startAnimating()
    }
}

extension CompanyInfoViewController : UIWebViewDelegate{
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        
        myActivityIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        myActivityIndicator.stopAnimating()
        
        
    }
}
