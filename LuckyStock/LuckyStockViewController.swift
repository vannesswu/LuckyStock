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
    let headerId = "headevar"
    var luckyStocks = [LuckyStock]()
    var filterStocks = [LuckyStock]()

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
        
        let backBarButtonItem = UIBarButtonItem(title: "回前頁", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        backBarButtonItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.white], for: .normal)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.backBarButtonItem = backBarButtonItem
        
        
        
        view.addSubview(stockTabeleView)
        let myURLString = "http://histock.tw/stock/public.aspx"
        
        Service.shareinstance.fetchWebStockData(baseurl: myURLString) { (stocks:[LuckyStock], error:Error?) in
            self.luckyStocks = stocks
            self.handleUserSetting()
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
        stockSettingLauncher = StockSettingLauncher()
        stockSettingLauncher.delegateController = self
       stockSettingLauncher.showSetting()
    }
    
    
    func handleUserSetting() {
       let userDefault = UserDefaults.standard
        
       judgeStockMatchTheConditions()
        
        if let isNeedRemind = userDefault.object(forKey: "isNeedRemind") as? Bool {
        settingNotify(isNeedRemind)
        }
       stockTabeleView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        stockTabeleView.reloadData()
    }
    

    func judgeStockMatchTheConditions() {
        
        let userDefault = UserDefaults.standard
        filterStocks = luckyStocks
        
        if UserDefaults.isHideOverDateSetting() {
            filterStocks = filterStocks.filter({ (luckyStock:LuckyStock) -> Bool in
            luckyStock.status?.rawValue != "expired"
           })
        }
        if let userSellPrice = userDefault.string(forKey: "sellPrice"), userSellPrice != "" {
            filterStocks = filterStocks.filter({ (luckyStock:LuckyStock) -> Bool in
                if let sellPrice = Double(luckyStock.sellPrice!) {
                    return  sellPrice <= Double(userSellPrice)!
                }
                return false
            })
        }
        if let userProfitPrice = userDefault.string(forKey: "profitPrice"), userProfitPrice != "" {
            filterStocks = filterStocks.filter({ (luckyStock:LuckyStock) -> Bool in
                if let profitPrice = Double(luckyStock.profit!) {
                    return  profitPrice >= Double(userProfitPrice)!
                }
                return luckyStock.profit == "無資料" ? true : false
            })
        }
        
        
    }
    func settingNotify(_ needRemind:Bool) {
        
        
        
        if needRemind {
            if let remindTime = UserDefaults.standard.object(forKey: "remindTime") as? Date {
                let stockContent = UNMutableNotificationContent()
                stockContent.title = "股票申購通知"
                stockContent.body = "點擊查看是否有新申購股票符合條件"
                //            stockContent.body = "承銷價:\(stock.sellPrice ?? "") 參考市價:\(stock.marketPrice ?? "") 溢價差:\(stock.profit ?? "")"
                stockContent.badge = 1
                
                let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: remindTime)
                let notifTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                
                let request = UNNotificationRequest(identifier: "stockNotify", content: stockContent, trigger: notifTrigger)
                UNUserNotificationCenter.current().add(request) { (error) in
                    if error != nil {
                        print("\(error)")
                    }
                }
            }
        } else {
          UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["stockNotify"])
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
        return filterStocks.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId)
        return header
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! StockCell
        cell.delegateController = self
        cell.stock = filterStocks[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let stockDetailVC = StockDetailViewController()
        stockDetailVC.stock = filterStocks[indexPath.row]
        navigationController?.pushViewController(stockDetailVC, animated: true)
        
        
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
