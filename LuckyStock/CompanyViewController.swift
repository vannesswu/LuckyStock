//
//  CompanyViewController.swift
//  LuckyStock
//
//  Created by 吳建豪 on 2017/2/25.
//  Copyright © 2017年 吳建豪. All rights reserved.
//

import Foundation
import UIKit
import LBTAComponents
class CompanyViewController: UIViewController {
    
    
    var company = ""
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
        if let address = LuckyStock.stockCompaniesDict[company] ,let url = URL(string:address) {
        let urlRequest = URLRequest(url: url)
        webView?.loadRequest(urlRequest)
        }
   //     myActivityIndicator.startAnimating()
    }
}

extension CompanyViewController : UIWebViewDelegate{
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        
        //   myActivityIndicator.stopAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        myActivityIndicator.stopAnimating()
        
        
    }
}
