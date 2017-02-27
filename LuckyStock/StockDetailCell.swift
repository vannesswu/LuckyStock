//
//  StockDetailCell.swift
//  LuckyStock
//
//  Created by 吳建豪 on 2017/2/27.
//  Copyright © 2017年 吳建豪. All rights reserved.
//

import Foundation
import UIKit
import LBTAComponents
import UserNotifications

class StockDetailCell: UITableViewCell {
    
    var cellIndex:Int = 0
    var delegateController:StockDetailViewController?
    var isNeedRemind = false {
        didSet {
        let color = isNeedRemind ? UIColor.red : UIColor.darkGray
        alarmButton.tintColor = color
        }
    }
    var stock:LuckyStock? {
        
        didSet {
            setupViews()
         //   if let index = self.cellIndex {
                switch cellIndex {
                case 0 :
                    alarmButton.isHidden = true
                    titleLabel.text = "股票代號:"
                    stockInfoLabel.text = "\(stock?.name ?? "") \(stock?.number ?? "" ) "
                case 1 :
                    alarmButton.isHidden = true
                    titleLabel.text = "發行市場:"
                    stockInfoLabel.text = "\(stock?.reason ?? "")"
                case 2 :
                    alarmButton.isHidden = false
                    titleLabel.text = "申購期間:"
                    stockInfoLabel.text = "\(stock?.during ?? "")"
                case 3 :
                    alarmButton.isHidden = true
                    titleLabel.text = "撥券日期:"
                    stockInfoLabel.text = "\(stock?.givenDate ?? "")"
                case 4 :
                    alarmButton.isHidden = true
                    titleLabel.text = "承銷張數:"
                    stockInfoLabel.text = "\(stock?.amount ?? "")"
                case 5 :
                    alarmButton.isHidden = true
                    titleLabel.text = "承銷價:"
                    stockInfoLabel.text = "\(stock?.sellPrice ?? "")"
                case 6 :
                    alarmButton.isHidden = true
                    titleLabel.text = "參考市價:"
                    stockInfoLabel.text = "\(stock?.marketPrice ?? "")"
                case 7 :
                    alarmButton.isHidden = true
                    titleLabel.text = "申購張數:"
                    stockInfoLabel.text = "\(stock?.numberOfStockCanBuy ?? "")"
                case 8 :
                    alarmButton.isHidden = true
                    titleLabel.text = "總合格件:"
                    stockInfoLabel.text = "\(stock?.numberOfPeople ?? "")"
                case 9 :
                    titleLabel.text = "中籤率:"
                    alarmButton.isHidden = true
                    stockInfoLabel.text = "\(stock?.bingoRate ?? "") %"
                default :
                    break
                }
           // }
        }
        
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let titleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    let stockInfoLabel:UILabel = {
        let label = UILabel()
        return label
    }()
    lazy var alarmButton:UIButton = {
        let btn = UIButton()
        let btnImage = UIImage(named: "alarm")?.withRenderingMode(.alwaysTemplate)
        btn.setImage(btnImage, for: .normal)
        btn.tintColor = UIColor.darkGray
        btn.addTarget(self, action: #selector(settingAlarm), for: .touchUpInside)
        btn.isHidden = true
        return btn
    }()
    
    
    func setupViews() {
    addSubview(titleLabel)
    addSubview(stockInfoLabel)
        titleLabel.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 5, leftConstant: 5, bottomConstant: 5, rightConstant: 0, widthConstant: 100, heightConstant: 0)
        
        
        
        stockInfoLabel.anchor(titleLabel.topAnchor, left: titleLabel.rightAnchor, bottom: titleLabel.bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
            addSubview(alarmButton)
            alarmButton.anchor(titleLabel.topAnchor, left: nil, bottom: titleLabel.bottomAnchor, right: rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 5, rightConstant: 20, widthConstant: 40, heightConstant: 0)
        
        
        
    }
    
    func settingAlarm() {
        isNeedRemind = !isNeedRemind
        var alertTitle = ""
        var alertMessage = ""
        guard let stockNumber = stock?.number else { return }
        if isNeedRemind {
            if let remindTime = UserDefaults.standard.object(forKey: "remindTime") as? Date {
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "HH:mm"
                let  remindTimeString = timeFormatter.string(from: remindTime )
                
                let stockContent = UNMutableNotificationContent()
                stockContent.title = "\(stock?.name ?? "")申購通知"
                stockContent.body = "申購期間\(stock?.during ?? "") "
                let currentBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
                stockContent.badge = currentBadgeNumber as NSNumber?
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy/MM/dd HH:mm"
                //       formatter.timeZone = TimeZone.current
                formatter.locale = Locale(identifier: "zh_TW")
                let date = Date()
                let today = formatter.string(from: date as Date)
                let componentInToday = today.components(separatedBy: "/")
                let yearInToday = componentInToday[0]
                
                if let duringDate = stock?.during?.components(separatedBy: "~") {
                    let startDateString = duringDate[0]
                    let combineDateString = "\(yearInToday)/\(startDateString) \(remindTimeString)"
                    guard let startDate = formatter.date(from: combineDateString) else { return }
                    alertTitle = "已新增通知"
                    alertMessage = "將在\(combineDateString) 發送 \(stock?.name ?? "") 申購提醒"
                    let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: startDate)
                    let notifTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                    
                    let request = UNNotificationRequest(identifier: "\(stockNumber)Notify", content: stockContent, trigger: notifTrigger)
                    UNUserNotificationCenter.current().add(request) { (error) in
                        if error != nil {
                            print("\(error)")
                        }
                    }
                }
            }
        } else {
            alertTitle = "已取消通知"
              UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(stockNumber)Notify"])
        }
        
        
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        delegateController?.present(alertController, animated: true, completion: nil)
        UserDefaults.standard.set(isNeedRemind, forKey: stockNumber)
        UserDefaults.standard.synchronize()

        
    }
    
    
}
