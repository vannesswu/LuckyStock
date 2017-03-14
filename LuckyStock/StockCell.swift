//
//  StockCell.swift
//  LuckyStock
//
//  Created by 吳建豪 on 2017/2/22.
//  Copyright © 2017年 吳建豪. All rights reserved.
//

import UIKit
import  LBTAComponents

class StockCell: UITableViewCell {
    
    
    var delegateController:LuckyStockViewController?
    
    var stock:LuckyStock? {
        didSet {
           nameLabel.text = "\(stock?.name ?? "")\n\n\(stock?.number ?? "")"
           sellPriceLabel.text = stock?.sellPrice ?? ""
           marketPriceLabel.text = stock?.marketPrice ?? ""
           profitLabel.text = stock?.profit ?? ""
           duringDateLabel.text = "申購期間: \(stock?.during ?? "")"
           startDateLabel.text = "抽籤日期: \(stock?.startDate ?? "")"
            if let status = stock?.status {
                nameLabel.backgroundColor = judgeStatus(status)
            }
            
            
        }
        
        
    }
    func judgeStatus(_ status:LuckyStock.StockStatus) -> UIColor {
        
        switch status {
        case.notyet :
            buyButton.isHidden = true
            return UIColor.adoptGreen
        case.onsell :
            buyButton.isHidden = false
            return UIColor.adoptRed
        case.expired :
            buyButton.isHidden = true
            return UIColor.midleGray
        }
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy/MM/dd"
// //       formatter.timeZone = TimeZone.current
//        formatter.locale = Locale(identifier: "zh_TW")
//        let date = Date()
//        let today = formatter.string(from: date as Date)
//        let componentInToday = today.components(separatedBy: "/")
//        let yearInToday = componentInToday[0]
//       // let monthInToday = componentInToday[1]
//       // let dayInToday = componentInToday[2]
//
//        let duringDate = during.components(separatedBy: "~")
//        let startDateString = duringDate[0]
//        let endDateString = duringDate[1]
//        let startDate = formatter.date(from: "\(yearInToday)/\(startDateString)")
//        let endDate = formatter.date(from: "\(yearInToday)/\(endDateString)")
//        
//        if date  < startDate! {
//            buyButton.isHidden = true
//            return UIColor.adoptGreen
//        } else if date > startDate! && date < endDate! {
//            buyButton.isHidden = false
//            return UIColor.adoptRed
//        } else {
//            buyButton.isHidden = true
//            return UIColor.midleGray
//        }
    }
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    let nameLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        label.layer.cornerRadius = 40
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.clipsToBounds = true
        return label
    }()
    let sellPriceLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    let marketPriceLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    let profitLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.red
        return label
    }()
    let startDateLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.darkGray
        return label
    }()
    let duringDateLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.darkGray
        return label
    }()
    lazy var buyButton:UIButton = {
        let btn = UIButton()
        btn.setTitle("申購", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = UIColor.buyRed
        btn.addTarget(self, action: #selector(goWebView), for: .touchUpInside)
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOffset = CGSize(width: -1.5, height: 1.5)
        btn.layer.shadowOpacity = 0.8
        btn.layer.shadowRadius = 1.0
        
        
        return btn
    }()
    
    

    func setupViews(){
        addSubview(nameLabel)
        addSubview(sellPriceLabel)
        addSubview(marketPriceLabel)
        addSubview(profitLabel)
        addSubview(startDateLabel)
        addSubview(duringDateLabel)
    //    addSubview(buyButton)
        
        
        if let window = UIApplication.shared.keyWindow {
            let  labelWidth = (window.frame.width )/4
            
        nameLabel.anchor(nil, left: leftAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 8, bottomConstant: 10, rightConstant: 0, widthConstant: 80, heightConstant: 80)
            nameLabel.anchorCenterYToSuperview()
        sellPriceLabel.anchor(topAnchor, left: nameLabel.rightAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 40, rightConstant: 0, widthConstant: labelWidth, heightConstant: 0)
        marketPriceLabel.anchor(sellPriceLabel.topAnchor, left: sellPriceLabel.rightAnchor, bottom: sellPriceLabel.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: labelWidth, heightConstant: 0)
        profitLabel.anchor(sellPriceLabel.topAnchor, left: marketPriceLabel.rightAnchor, bottom: sellPriceLabel.bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        duringDateLabel.anchor(sellPriceLabel.bottomAnchor, left: nameLabel.rightAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 15)
        startDateLabel.anchor(duringDateLabel.bottomAnchor, left: duringDateLabel.leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 5, rightConstant: 0, widthConstant: 0, heightConstant: 15)
        }
     //   buyButton.anchor(profitLabel.bottomAnchor, left: profitLabel.leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 5, bottomConstant: 5, rightConstant: 5, widthConstant: 0, heightConstant: 35)
        
        
    
    }
    
    
    func goWebView() {
        
        if let company = UserDefaults.standard.object(forKey: "stockCompany") as? String {
            let webViewController = SecurityCompanyViewController()
            webViewController.company = company
            delegateController?.navigationController?.pushViewController(webViewController, animated: true)
        } else {
            let alertController = UIAlertController(title: "Oops~ 出錯了", message: "請先至設定選擇您的證券商", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(okAction)
            delegateController?.present(alertController, animated: true, completion: nil)
        }
    
    
    
    }
}
