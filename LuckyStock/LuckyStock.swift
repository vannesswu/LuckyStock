//
//  LuckyStock.swift
//  parseHtmltest
//
//  Created by 吳建豪 on 2017/2/22.
//  Copyright © 2017年 吳建豪. All rights reserved.
//

import Foundation

class LuckyStock {
    
    var startDate:String?
    var name:String?
    var number:String?
    var reason:String?
    var during:String?
    var amount:String?
    var sellPrice:String?
    var marketPrice:String?
    let myURL = URL(string: "http://histock.tw/stock/public.aspx")
   
    
    init (_ stock:String) {
        
                        
            let separateString = stock.components(separatedBy: "</font></td><td><font size=\"3\">")
            
            self.startDate = separateString[0].substring(from: separateString[0].characters.count-10)
            
            self.number = separateString[1].substring(with: 21..<25)
            
            if let range = separateString[1].range(of: "&nbsp;") {
                let name = separateString[1].substring(from: (range.upperBound))
                self.name = name.substring(to: (name.characters.count)-5)
            }
            
            self.reason = separateString[2]
            
            self.during = separateString[3].substring(with: 1..<12)
            
            let amount = separateString[4]
            self.amount = amount.return1to9(with: amount)
            
            if let range2 = separateString[5].range(of: "</font></td><td>"){
                let sellPrice = separateString[5].substring(to: range2.lowerBound)
                self.sellPrice = sellPrice.return1to9(with: sellPrice)
            }
            
            if let range3 = separateString[5].range(of: "size=\"3\">") {
                let marketPrice = separateString[5].substring(from: (range3.upperBound))
                self.marketPrice = marketPrice.return1to9(with: marketPrice)
            }
            
            
        
    }
    
}
