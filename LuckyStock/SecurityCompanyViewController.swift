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
class SecurityCompanyViewController: UIViewController {
    
    
    var company = ""
    var myActivityIndicator = UIActivityIndicatorView.spinner
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       let backBarbutton = UIBarButtonItem(title: "前一頁", style: UIBarButtonItemStyle.plain, target: self, action: #selector(goback))
        backBarbutton.tintColor = UIColor.white
        let forwardBarbutton = UIBarButtonItem(title: "下一頁", style: UIBarButtonItemStyle.plain, target: self, action: #selector(forward))
        forwardBarbutton.tintColor = UIColor.white
        navigationItem.rightBarButtonItems = [forwardBarbutton,backBarbutton]
        
        
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
    
    func goback(){
        webView.goBack()
    }
    func forward() {
        webView.goForward()
    }
}

extension SecurityCompanyViewController : UIWebViewDelegate{
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        
        //   myActivityIndicator.stopAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        myActivityIndicator.stopAnimating()
        
        
    }
}
