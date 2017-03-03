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

    var isNeedRemindDict = [2:false, 3:false, 4:false] {
        didSet {
            if let status = isNeedRemindDict[cellIndex] {
            let color = status ? UIColor.red : UIColor.darkGray
            alarmButton.tintColor = color
            }
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
                    alarmButton.isHidden = false
                    titleLabel.text = "抽籤日期:"
                    stockInfoLabel.text = "\(stock?.startDate ?? "")"
                case 4 :
                    alarmButton.isHidden = false
                    titleLabel.text = "撥券日期:"
                    stockInfoLabel.text = "\(stock?.givenDate ?? "")"
                case 5 :
                    alarmButton.isHidden = true
                    titleLabel.text = "承銷張數:"
                    stockInfoLabel.text = "\(stock?.amount ?? "")"
                case 6 :
                    alarmButton.isHidden = true
                    titleLabel.text = "承銷價:"
                    stockInfoLabel.text = "\(stock?.sellPrice ?? "")"
                case 7 :
                    alarmButton.isHidden = true
                    titleLabel.text = "參考市價:"
                    stockInfoLabel.text = "\(stock?.marketPrice ?? "")"
                case 8 :
                    alarmButton.isHidden = true
                    titleLabel.text = "申購張數:"
                    stockInfoLabel.text = "\(stock?.numberOfStockCanBuy ?? "")"
                case 9 :
                    alarmButton.isHidden = true
                    titleLabel.text = "總合格件:"
                    stockInfoLabel.text = "\(stock?.numberOfPeople ?? "")"
                case 10 :
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
        var notifyTitle = ""
        var notifyBody = ""
        var startDateString = ""
        var alertMessage = ""
        var alertTitle = "已新增通知"
        var isNeedRemind = false
        guard let stockNumber = stock?.number else { return }

        if let archivedData = UserDefaults.standard.object(forKey: stockNumber) as? Data, let remindDict = NSKeyedUnarchiver.unarchiveObject(with: archivedData) as? [Int:Bool] {
            isNeedRemindDict  = remindDict
        }
        
        switch cellIndex {
        case 2:
            notifyTitle = "\(stock?.name ?? "")申購通知"
            notifyBody = "申購期間\(stock?.during ?? "") "
            if let dateComponents = stock?.during?.components(separatedBy: "~") {
                startDateString = dateComponents[0]
            }
     //       isNeedRemindArray[0] = !isNeedRemindArray[0]
     //       isNeedRemind = isNeedRemindArray[0]
            if let  status = isNeedRemindDict[cellIndex] {
            isNeedRemindDict[cellIndex] = !status
            isNeedRemind = !status
            }
            
        case 3:
            notifyTitle = "\(stock?.name ?? "")抽籤日通知"
            notifyBody = "抽籤期間\(stock?.startDate ?? "") "
            if let date = stock?.startDate {
            startDateString = date
            }
    //        isNeedRemindArray[1] = !isNeedRemindArray[1]
   //         isNeedRemind = isNeedRemindArray[1]
            if let  status = isNeedRemindDict[cellIndex] {
                isNeedRemindDict[cellIndex] = !status
                isNeedRemind = !status
            }
        case 4:
            notifyTitle = "\(stock?.name ?? "")撥券日通知"
            notifyBody = "撥券日期\(stock?.givenDate ?? "") "
            if let date = stock?.givenDate {
                startDateString = date
            }
     //       isNeedRemindArray[2] = !isNeedRemindArray[2]
     //       isNeedRemind = isNeedRemindArray[2]
            if let  status = isNeedRemindDict[cellIndex] {
                isNeedRemindDict[cellIndex] = !status
                isNeedRemind = !status
            }
            
        default:
            break
        }
        
     //   isNeedRemind = !isNeedRemind
            if isNeedRemind {
            if let remindTime = UserDefaults.standard.object(forKey: "remindTime") as? Date {
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "HH:mm"
                let  remindTimeString = timeFormatter.string(from: remindTime )
                
                let stockContent = UNMutableNotificationContent()
                stockContent.title = notifyTitle
                stockContent.body = notifyBody
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
                let combineDateString = "\(yearInToday)/\(startDateString) \(remindTimeString)"
                guard let startDate = formatter.date(from: combineDateString) else { return }
                
                alertMessage = "將在\(combineDateString) 發送 \(notifyTitle)"
     //           alertMessage = alertMessages
                let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: startDate)
                let notifTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                
                let request = UNNotificationRequest(identifier: "\(notifyTitle)Notify", content: stockContent, trigger: notifTrigger)
                UNUserNotificationCenter.current().add(request) { (error) in
                    if error != nil {
                        print("\(error)")
                    }
                    
                }
            }
        } else {
            alertTitle = "已取消通知"
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(notifyTitle)Notify"])
        }
        
        
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        delegateController?.present(alertController, animated: true, completion: nil)
        let data = NSKeyedArchiver.archivedData(withRootObject: isNeedRemindDict)
        UserDefaults.standard.set(data , forKey: stockNumber)
        UserDefaults.standard.synchronize()
        

        
    }
    
    
}
