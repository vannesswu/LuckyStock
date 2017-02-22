//
//  ViewController.swift
//  LuckyStock
//
//  Created by 吳建豪 on 2017/2/22.
//  Copyright © 2017年 吳建豪. All rights reserved.
//

import UIKit
import LBTAComponents

class LuckyStockViewController: UIViewController {

    let cellId = "cellId"
    var luckyStocks = [LuckyStock]()
    lazy var stockTabeleView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(StockCell.self, forCellReuseIdentifier: self.cellId)
        return tableView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "股票申購"
        view.addSubview(stockTabeleView)
        let myURLString = "http://histock.tw/stock/public.aspx"
        
        guard let myURL = NSURL(string: myURLString) else {
            print("Error: \(myURLString) doesn't seem to be a valid URL")
            return
        }
        
        do {
            let myHTMLString = try String(contentsOf: myURL as URL)
            let separeString = myHTMLString.components(separatedBy: "align=\"left\"")
            for i in 1...10 {
                let stock = LuckyStock(separeString[i])
            luckyStocks.append(stock)
                
            }
            print("HTML : ")
        } catch let error as NSError {
            print("Error: \(error)")
        }
        
        
    }
    override func viewWillLayoutSubviews() {
        stockTabeleView.fillSuperview()
    }

   
}


extension LuckyStockViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

