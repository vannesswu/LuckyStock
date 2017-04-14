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
    var givenDate:String?
    var name:String?
    var number:String?
    var reason:String?
    var during:String?
    var amount:String?
    var sellPrice:String?
    var marketPrice:String?
    var profit:String?
    var numberOfStockCanBuy:String?
    var numberOfPeople:String?
    var bingoRate:String?
    var status:StockStatus?
    
    let myURL = URL(string: "http://histock.tw/stock/public.aspx")
    
    init (_ stock:String) {
        
        
        var separateString = stock.components(separatedBy: "</font></td><td><font size=\"3\">")
        if separateString.count == 1 {
            separateString = stock.components(separatedBy: "</td><td>")
        }
        
        self.startDate = separateString[0].substring(from: separateString[0].characters.count-5)
        
     //   self.number = separateString[1].substring(with: 21..<25)
        
        if let range = separateString[1].range(of: "&nbsp;") {
            let number = separateString[1].substring(to: (range.lowerBound))
            self.number = number.substring(from: number.characters.count-4)
            let name = separateString[1].substring(from: (range.upperBound))
            self.name = name.substring(to: (name.characters.count) - (name.contains("</a>") ? 5 : 1))
        }
        
        self.reason = separateString[2].replacingOccurrences(of: " ", with: "")
        self.reason = self.reason?.replacingOccurrences(of: "\r\n", with:"")
        self.during = separateString[3].substring(with: 1..<12)
        self.status = judgeStatus(during: self.during)
        self.givenDate = separateString[3].substring(from: separateString[3].characters.count - 4)
        let amount = separateString[4]
        self.amount = amount.return1to9(with: amount)
        
        if let range2 = separateString[5].range(of: "</td><td"){
            let sellPrice = separateString[5].substring(to: range2.lowerBound)
            self.sellPrice = sellPrice.return1to9(with: sellPrice)
        }
        
        //            if let range3 = separateString[5].range(of: "size=\"3\">") {
        
        //                let marketPrice = separateString[5].substring(from: (range3.upperBound))
        let marketPrice = separateString[5].substring(from: separateString[5].characters.count-7)
        self.marketPrice = marketPrice.return1to9(with: marketPrice)
        
        //       }
        if self.sellPrice != nil && self.marketPrice != nil {
            if let sellprice = Double(self.sellPrice!), let marketprice = Double(self.marketPrice!) {
                self.profit = String(format: "%.2f", marketprice - sellprice)
            }
            if self.marketPrice == "" {
                self.marketPrice = "無資料"
                self.profit = "無資料"
            }
        }
        self.numberOfStockCanBuy = separateString[8].return0to9()
        self.numberOfPeople = separateString[9]
        self.bingoRate = separateString[10]
        
    }
    
    func judgeStatus(during:String?)-> StockStatus {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH"
        formatter.locale = Locale(identifier: "zh_TW")
        let date = Date()
        let today = formatter.string(from: date as Date)
        let componentInToday = today.components(separatedBy: "/")
        let yearInToday = componentInToday[0]
        
        if let duringDate = self.during?.components(separatedBy: "~")   {      let startDateString = duringDate[0]
        let endDateString = duringDate[1]

        let startDate = formatter.date(from: "\(yearInToday)/\(startDateString) 00")
        let endDate = formatter.date(from: "\(yearInToday)/\(endDateString) 14" )
            
        if date  < startDate! {
            return StockStatus.notyet
        } else if date > startDate! && date < endDate! {
            return StockStatus.onsell
        } else {
            return StockStatus.expired
        }
        }
        return StockStatus.notyet
    }


    
    
    
    
    static let stockCompaniesDict = ["元大":"http://www.yuanta.com.tw/pages/homepage/Security.aspx?Node=3ebfd711-ea07-417f-8723-83d73ebaa4ac",
     "凱基":"http://www.kgieworld.com.tw/stock/stock_6_6.aspx?findex=9",
     "富邦":"http://www.fubon-ebroker.com/fbs/index.fs",
     "永豐金":"http://www.sinotrade.com.tw/Stock",
     "群益":"https://www.capital.com.tw/",
     "元富":"http://www.masterlink.com.tw/stock/StockIndex.aspx",
     "統一":"http://www.pscnet.com.tw/",
     "日盛":"http://www.jihsun.com.tw/JssFHCWebNet/#",
     "兆豐":"http://www.emega.com.tw/",
    "華南永昌":"https://www.entrust.com.tw/index.do",
    "新光":"https://w.sk88.com.tw/Cross/Pc/Login.aspx",
    "國票":"https://www.wls.com.tw/",
    "國泰":"https://www.cathaysec.com.tw/index_exclude_AL.aspx",
    "玉山":"http://www.esunsec.com.tw/",
    "第一金":"http://www.firstsec.com.tw/",
    "康和":"https://www.concords.com.tw/home/PDefault.aspx",
    "中國信託":"https://www.win168.com.tw/",
    "宏遠":"http://www.honsec.com.tw/HWweb/Content.Files/Securities.Files/Mainframe/index.aspx",
    "大眾":"http://www.tcsc.com.tw/",
    "合庫":"http://www.tcfhc-sec.com.tw/",
    "其他":"https://www.google.com.tw/"
    ]
    
    static  let stockCompaniesArray = ["元大","凱基","富邦","永豐金","群益","元富","統一","日盛","兆豐","華南永昌","新光","國票","國泰","玉山","第一金","康和","中國信託","宏遠","大眾","合庫","其他"]
    
    enum StockStatus:String {
        case notyet = "notyet"
        case onsell = "onsell"
        case expired = "expired"
    }
    
    
}
