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
import GoogleMobileAds

class LuckyStockViewController: UIViewController,GADInterstitialDelegate {

    let cellId = "cellId"
    let headerId = "headevar"
    var animateIsNeed = true
    var luckyStocks = [LuckyStock]()
    var filterStocks = [LuckyStock]()
    var interstitial: GADInterstitial!
    var clickNumber = 0
    
    lazy var stockSettingLauncher: StockSettingLauncher = {
        let launcher = StockSettingLauncher()
        return launcher
    }()
    
    let handleingView:UIView = {
        let view = UIView()
        let label = UILabel()
        let spinner = UIActivityIndicatorView.spinner
        label.text = "資料處理中請稍候..."
        view.addSubview(label)
        view.addSubview(spinner)
        label.anchorCenterSuperview()
        spinner.anchor(label.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        spinner.anchorCenterXToSuperview()
        spinner.startAnimating()
        view.backgroundColor = UIColor(white: 1, alpha: 1)
        return view
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
    
    let bannerView = GADBannerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = "抽股票"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "設定", style: UIBarButtonItemStyle.plain, target: self, action: #selector(setting))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        let backBarButtonItem = UIBarButtonItem(title: "回抽股票", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        backBarButtonItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.white], for: .normal)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.backBarButtonItem = backBarButtonItem
        
        UserDefaultFirstSetup()
        
        view.addSubview(stockTabeleView)
        view.addSubview(bannerView)
        
        setupHandleingView()
        let myURLString = "http://histock.tw/stock/public.aspx"
        
        
        Service.shareinstance.fetchWebStockData(baseurl: myURLString) { (stocks:[LuckyStock], error:Error?) in
            self.handleingView.removeFromSuperview()
            if error != nil {
                self.handleingError()
                return
            }
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
        
        // add Banna ads
        bannerView.backgroundColor = UIColor.white
        bannerView.adUnitID = "ca-app-pub-8818309556860374/3808980448"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        // create interstitial ads
        interstitial = createAndLoadInterstitial()
        
    }
    func UserDefaultFirstSetup() {
        if UserDefaults.isDailyNeedRemind() == nil {
            UserDefaults.standard.set(true, forKey: "isNeedRemind")
            UserDefaults.standard.synchronize()
        }
        if UserDefaults.remindTime() == nil {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            formatter.locale = Locale(identifier: "zh_TW")
            let initialTime = formatter.date(from: "09:00")
            UserDefaults.standard.set(initialTime, forKey: "remindTime")
            UserDefaults.standard.synchronize()
            
        }
    }
    
    func setupHandleingView() {
        view.addSubview(handleingView)
        handleingView.fillSuperview()
    }

    func handleingError(){
        let alertController = UIAlertController(title: "Oops! 出錯了", message: "網路連線異常請稍候再試", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        navigationController?.present(alertController, animated: true, completion: nil)
        
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
    
    // regenerate interstitial request
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-8818309556860374/5285713640")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
    }

    
    
    override func viewWillLayoutSubviews() {
        bannerView.anchor(view.topAnchor, left: view.leftAnchor , bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
    //    bannerView.anchorCenterXToSuperview()
        stockTabeleView.anchor(bannerView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if animateIsNeed {
            let frame = cell.frame
            cell.frame = CGRect(x: 0, y: self.stockTabeleView.frame.height, width: frame.width, height: frame.height)
            UIView.animate(withDuration: 0.75, delay: 0.0, options: UIViewAnimationOptions.transitionCrossDissolve, animations: { () -> Void in
                cell.frame = frame
            }, completion: {(bool:Bool) in
                if bool {
                    self.animateIsNeed = false
                }
            } )
        }

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if interstitial.isReady , clickNumber == 3 {
            UIWindow.removeStatusBar()
            interstitial.present(fromRootViewController: self)
            isAdsshown = true
            clickNumber = 0
            //            UIWindow.addStatusBar()
        }
        
        let stockDetailVC = StockDetailViewController()
        stockDetailVC.stock = filterStocks[indexPath.row]
        navigationController?.pushViewController(stockDetailVC, animated: true)
        
        clickNumber += 1
        UserDefaults.standard.set(clickNumber, forKey: "clickNumber")
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
