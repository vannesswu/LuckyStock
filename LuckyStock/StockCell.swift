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
    
    var stock:LuckyStock? {
        didSet {
           nameLabel.text = "\(stock?.name ?? "")\n\n\(stock?.number ?? "")"
           sellPriceLabel.text = stock?.sellPrice ?? ""
           marketPriceLabel.text = stock?.marketPrice ?? ""
           profitLabel.text = stock?.profit ?? ""
           duringDateLabel.text = "申購期間: \(stock?.during ?? "")"
           startDateLabel.text = "抽籤日期: \(stock?.startDate ?? "")"
            if let during = stock?.during {
                nameLabel.backgroundColor = judgeStatus(during)
            }
            
            
        }
        
        
    }
    func judgeStatus(_ during:String) -> UIColor {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
 //       formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: "zh_TW")
        let date = Date()
        let today = formatter.string(from: date as Date)
        let componentInToday = today.components(separatedBy: "/")
        let yearInToday = componentInToday[0]
        let monthInToday = componentInToday[1]
        let dayInToday = componentInToday[2]

        let duringDate = during.components(separatedBy: "~")
        let startDateString = duringDate[0]
        let endDateString = duringDate[1]
        let startDate = formatter.date(from: "\(yearInToday)/\(startDateString)")
        let endDate = formatter.date(from: "\(yearInToday)/\(endDateString)")
        
        if date  < startDate! {
            return UIColor.adoptGreen
        } else if date > startDate! && date < endDate! {
            return UIColor.adoptRed
        } else {
            return UIColor.midleGray
        }
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
        label.textColor = UIColor.darkGray
        return label
    }()
    let duringDateLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor.darkGray
        return label
    }()

    func setupViews(){
        addSubview(nameLabel)
        addSubview(sellPriceLabel)
        addSubview(marketPriceLabel)
        addSubview(profitLabel)
        addSubview(startDateLabel)
        addSubview(duringDateLabel)
        
        
        
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
    
    }
    
    
    
    
}
