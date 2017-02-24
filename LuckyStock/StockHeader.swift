//
//  StockHeader.swift
//  LuckyStock
//
//  Created by 吳建豪 on 2017/2/23.
//  Copyright © 2017年 吳建豪. All rights reserved.
//

import Foundation
import  UIKit
import  LBTAComponents

class StockHeader: UITableViewHeaderFooterView {
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.mainBlue
        setupViews()
        
    }
  
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let stockNameLabel:UILabel = {
        let label = UILabel()
        label.text = "股票代號"
        label.backgroundColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    let stockDateLabel:UILabel = {
        let label = UILabel()
        label.text = "抽籤日期"
        label.textAlignment = .center
        return label
    }()
    let stockSellPriceLabel:UILabel = {
        let label = UILabel()
        label.text = "承銷價"
        label.backgroundColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    let stockMarketPriceLabel:UILabel = {
        let label = UILabel()
        label.text = "參考市價"
        label.backgroundColor = UIColor.white

        label.textAlignment = .center
        return label
    }()
    let stockProfitLabel:UILabel = {
        let label = UILabel()
        label.text = "溢價差"
        label.backgroundColor = UIColor.white

        label.textAlignment = .center
        return label
    }()
    let notyetBuyLabel:UILabel = {
        let label = UILabel()
        label.text = "未開始"
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.backgroundColor = UIColor.adoptGreen
        return label
    }()
    let inBuyLabel:UILabel = {
        let label = UILabel()
        label.text = "可申購"
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.backgroundColor = UIColor.adoptRed
        return label
    }()
    let doneBuyLabel:UILabel = {
        let label = UILabel()
        label.text = "截止申購"
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.backgroundColor = UIColor.midleGray
        return label
    }()
    let separatorView = UIView.makeSeparatorView()
    
    func setupViews(){
        addSubview(stockNameLabel)
        addSubview(stockDateLabel)
        addSubview(stockSellPriceLabel)
        addSubview(stockMarketPriceLabel)
        addSubview(stockProfitLabel)
        addSubview(notyetBuyLabel)
        addSubview(inBuyLabel)
        addSubview(doneBuyLabel)
        addSubview(separatorView)
        
        if let window = UIApplication.shared.keyWindow {
            let  labelWidth = window.frame.width/4
            let buyLabelWidth = window.frame.width/3
            
            notyetBuyLabel.anchor(topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: buyLabelWidth, heightConstant: 20)
            inBuyLabel.anchor(notyetBuyLabel.topAnchor, left: notyetBuyLabel.rightAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: buyLabelWidth, heightConstant: 20)
            doneBuyLabel.anchor(notyetBuyLabel.topAnchor, left: inBuyLabel.rightAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20)
            
            stockNameLabel.anchor(notyetBuyLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: labelWidth, heightConstant: 0)
            stockSellPriceLabel.anchor(stockNameLabel.topAnchor, left: stockNameLabel.rightAnchor, bottom: stockNameLabel.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: labelWidth, heightConstant: 0)
            stockMarketPriceLabel.anchor(stockNameLabel.topAnchor, left: stockSellPriceLabel.rightAnchor, bottom: stockNameLabel.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: labelWidth, heightConstant: 0)
            stockProfitLabel.anchor(stockNameLabel.topAnchor, left: stockMarketPriceLabel.rightAnchor, bottom: stockNameLabel.bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
            separatorView.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
            
            
        }
        
        
    }

    
    
    
    
}


