//
//  StockDetailViewController.swift
//  LuckyStock
//
//  Created by 吳建豪 on 2017/2/27.
//  Copyright © 2017年 吳建豪. All rights reserved.
//

import Foundation
import UIKit
import LBTAComponents


class StockDetailViewController:UIViewController {
    
    let cellId = "stockDetailCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "公司資料", style: UIBarButtonItemStyle.plain, target: self, action: #selector(showCompanyInfo))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        let backBarButtonItem = UIBarButtonItem(title: "回前頁", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        backBarButtonItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.white], for: .normal)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    var stock:LuckyStock? {
        didSet {
          //  let imageUrlString = "http://pchome.megatime.com.tw/stockimage/\(stock?.number ?? "")_b.png"
            //  stockImageView.loadImage(urlString: imageUrlString)
            let imageUrlString = "http://histock.tw/stock/realtime.aspx?m=rt&no=\(stock?.number ?? "")"
            let url = URL(string:imageUrlString)
            let urlRequest = URLRequest(url: url!)
            stockWebView.loadRequest(urlRequest)
            print("here")
            
        }
        
    }
    func showCompanyInfo() {
        let companyInfoViewController = CompanyInfoViewController()
        companyInfoViewController.stock = stock
        navigationController?.pushViewController(companyInfoViewController, animated: true)
    }
    
    var stockImageView:CachedImageView = {
        let iv = CachedImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    var stockWebView = UIWebView()
    
    lazy var stockDetailTabeleView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(StockDetailCell.self, forCellReuseIdentifier: self.cellId)
        return tableView
    }()
    var myActivityIndicator = UIActivityIndicatorView.spinner
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.addSubview(stockImageView)
        view.addSubview(stockWebView)
        view.addSubview(stockDetailTabeleView)
        
    //   stockWebView.scalesPageToFit = true
        stockWebView.delegate = self
        stockWebView.scrollView.delegate = self
        stockWebView.backgroundColor = UIColor.white
        stockWebView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 280)
       stockDetailTabeleView.anchor(stockWebView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        stockWebView.addSubview(myActivityIndicator)
        myActivityIndicator.anchorCenterSuperview()
    }
    

}

extension StockDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! StockDetailCell
        cell.cellIndex = indexPath.row
        cell.stock = stock
        cell.delegateController = self
        if let stockNumber = stock?.number, let isNeedRemind = UserDefaults.standard.object(forKey: stockNumber) as? Bool {
         cell.isNeedRemind = isNeedRemind
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}


extension StockDetailViewController: UIWebViewDelegate{
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        
           myActivityIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        myActivityIndicator.stopAnimating()
        print("here")
        let contentSize:CGSize = stockWebView.scrollView.contentSize
        let viewSize:CGSize = self.view.bounds.size
        
        let rw:CGFloat = viewSize.width / contentSize.width
        
        stockWebView.scrollView.minimumZoomScale = rw
        stockWebView.scrollView.maximumZoomScale = rw
        stockWebView.scrollView.zoomScale = rw
    }
}

