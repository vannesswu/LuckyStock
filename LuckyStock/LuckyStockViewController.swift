//
//  ViewController.swift
//  LuckyStock
//
//  Created by 吳建豪 on 2017/2/22.
//  Copyright © 2017年 吳建豪. All rights reserved.
//

import UIKit
import LBTAComponents
import UserNotifications

class LuckyStockViewController: UIViewController {

    let cellId = "cellId"
    let headerId = "headerId"
    var luckyStocks = [LuckyStock]()
    
    lazy var stockSettingLauncher: StockSettingLauncher = {
        let launcher = StockSettingLauncher()
        return launcher
    }()
    
    
    
    
    lazy var stockTabeleView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(StockCell.self, forCellReuseIdentifier: self.cellId)
        tableView.register(StockHeader.self, forHeaderFooterViewReuseIdentifier: self.headerId)
        tableView.sectionHeaderHeight = 70

        return tableView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = "股票申購"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "設定", style: UIBarButtonItemStyle.plain, target: self, action: #selector(setting))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        
        
        view.addSubview(stockTabeleView)
        let myURLString = "http://histock.tw/stock/public.aspx"
        
        Service.shareinstance.getStockInBackground(baseurl: myURLString) { (stocks:[LuckyStock], error:Error?) in
            self.luckyStocks = stocks
            self.stockTabeleView.reloadData()
            self.sendNotify(stocks: stocks) { (bool:Bool) in
                
            }
        }
        // 1 Request permission
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                print("Notification access granted")
            } else {
                print("\(error?.localizedDescription)")
            }
        }
        
        
    }
    
    func setting() {
       stockSettingLauncher.showSetting()
    }
    
    func sendNotify(stocks:[LuckyStock], completion: @escaping (_ success:Bool)->()) {
        var matchStocks = judgeStockMatchTheConditions(stocks)
        let date = NSDate()
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        let today = formatter.string(from: date as Date)
        
        
        
        for stock in matchStocks! {
            let magicContent = UNMutableNotificationContent()
            magicContent.title = "股票申購通知"
            magicContent.subtitle = "符合條件股票: \(stock.name ?? "")"
            magicContent.body = "承銷價:\(stock.sellPrice ?? "") 參考市價:\(stock.marketPrice ?? "") 溢價差:\(stock.profit ?? "")"
            magicContent.badge = 1
            let notifTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 20, repeats: false)
            
       //     let request = UNNotificationRequest(identifier: "\(today) \(stock.name ?? "")", content: magicContent, trigger: notifTrigger)
            
            let request = UNNotificationRequest(identifier: "1", content: magicContent, trigger: notifTrigger)
            
            UNUserNotificationCenter.current().add(request) { (error) in
                if error != nil {
                    print("\(error)")
                    completion(false)
                } else {
                    completion(true)
                }
            }
         }
        }
    

    func judgeStockMatchTheConditions(_ stocks:[LuckyStock]) -> [LuckyStock]? {
        
        return stocks.filter({ (luckyStock:LuckyStock) -> Bool in
            if let profit = Double(luckyStock.profit!) {
               return  profit > 10.0
            }
            return false
        })
        
        
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
        return luckyStocks.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId)
        return header
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! StockCell
        cell.stock = luckyStocks[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

extension LuckyStockViewController:UNUserNotificationCenterDelegate{
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("Tapped in notification")
    }
    
    //This is key callback to present notification while the app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("Notification being triggered")
        //You can either present alert ,sound or increase badge while the app is in foreground too with ios 10
        //to distinguish between notifications
        if notification.request.identifier == "1"{
            
            completionHandler( [.alert,.sound,.badge])
            
        }
    }
}
