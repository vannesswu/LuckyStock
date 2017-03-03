//
//  SettingLauncher.swift
//  LuckyStock
//
//  Created by 吳建豪 on 2017/2/24.
//  Copyright © 2017年 吳建豪. All rights reserved.
//

import UIKit
import LBTAComponents

class StockSettingLauncher: NSObject, UITextFieldDelegate {
    
    override init() {
        super.init()
        
    }
    var delegateController:LuckyStockViewController?
    let stockCompanies = LuckyStock.stockCompaniesArray
    var didScrolled = false
    let blackView = UIView()
    let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.mainBlue
        return view
    }()
    let SettingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    var halfWidth:CGFloat = 0

    
    
    // MARK: show mainView
    func showSetting() {
        // remove the handleView
        //   if conditionDelegate.ha
        
        
        //show menu
        
        if let window = UIApplication.shared.keyWindow {
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            window.addSubview(blackView)
            window.addSubview(SettingView)
            SettingView.frame = CGRect(x: window.frame.width, y: 0, width: window.frame.width/2, height: window.frame.height)
            blackView.frame = window.frame
            blackView.alpha = 0
            halfWidth = SettingView.frame.width/2
            setupHeaderView()
            setupFilterView()
            setupCompanyView()
            setupRemindView()
            setupDoneButton()
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackView.alpha = 1
                
                self.SettingView.frame = CGRect(x: window.frame.width/2, y: 0, width: self.SettingView.frame.width, height: self.SettingView.frame.height)
                
            }, completion: nil)
        }
        
    }
    func handleDismiss() {
        
//        if globalTableView.count > 0 {
//            for view in globalTableView{
//                view.removeFromSuperview()
//            }
//        }
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.SettingView.frame = CGRect(x: window.frame.width, y: 0, width: self.SettingView  .frame.width, height: self.SettingView.frame.height)
            }
            
        }) { (completed: Bool) in
            if completed {
                self.blackView.removeFromSuperview()
                self.SettingView.removeFromSuperview()
                self.filterView.removeFromSuperview()
                
            }
        }
        
    }
    // MARK: setupHeaderView
    func setupHeaderView() {
        SettingView.addSubview(headerView)
        headerView.anchor(SettingView.topAnchor, left: SettingView.leftAnchor, bottom: nil, right: SettingView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 44+20)
        let statusBarBackgroundView = UIView()
        statusBarBackgroundView.backgroundColor = UIColor.darkBlue
        SettingView.addSubview(statusBarBackgroundView)
        statusBarBackgroundView.anchor(SettingView.topAnchor, left: SettingView.leftAnchor, bottom: nil, right: SettingView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20)
        let titleLabel = UILabel()
        titleLabel.text = "設定相關條件"
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white
        headerView.addSubview(titleLabel)
        titleLabel.anchor(headerView.topAnchor, left: nil, bottom: nil, right: nil, topConstant: 31, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 150, heightConstant: 0)
        titleLabel.anchorCenterXToSuperview()
    }
    let sellPriceLabel = TitleLabel()
    let profitLabel = TitleLabel()
    let sellTextfield:NumberTextField = {
        let tf = NumberTextField()
        if let sellPrice = UserDefaults.standard.object(forKey: "sellPrice") as? String {
            tf.text = sellPrice
        }
        return tf
    }()
    let profitTextfield:NumberTextField = {
        let tf = NumberTextField()
        if let profitPrice = UserDefaults.standard.object(forKey: "profitPrice") as? String {
            tf.text = profitPrice
        }
        return tf
    }()
    let isHideOverDateStockLabel = TitleLabel()
    
    var tempIshideOverDateSetting = UserDefaults.isHideOverDateSetting()
    lazy var confirmButton:UIButton = {
        let btn = UIButton()
        btn.layer.borderWidth = 4
        btn.layer.borderColor = UIColor.selectGreen.cgColor
        btn.setImage(self.tempIshideOverDateSetting ? #imageLiteral(resourceName: "confirm") : nil, for: .normal)
        btn.addTarget(self, action: #selector(switchButtonImage), for: .touchUpInside)
        return btn
    }()
    func switchButtonImage(){
        tempIshideOverDateSetting = !tempIshideOverDateSetting
    //     UserDefaults.standard.set(!UserDefaults.isHideOverDateSetting(), forKey: "isHideOverDateSetting")
        confirmButton.setImage(tempIshideOverDateSetting ? #imageLiteral(resourceName: "confirm") : nil, for: .normal)
    //     UserDefaults.standard.synchronize()
    }
    
    var filterView = UIView()
    
    // MARK: setupFilterView
    
    func setupFilterView(){
        let separatorView = SeparatorView()
        filterView = UIView()
        SettingView.addSubview(filterView)
        filterView.anchor(headerView.bottomAnchor, left: SettingView.leftAnchor, bottom: nil, right: SettingView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 160)
        
        // setting title view
        let titleLabel = HearderLabel()
        titleLabel.text = "篩選條件"
        titleLabel.textAlignment = .center
        filterView.addSubview(titleLabel)
        titleLabel.anchor(filterView.topAnchor, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        titleLabel.anchorCenterXToSuperview()
        
        // setting filter condition view
        sellPriceLabel.text = "承銷價 小於: "
        profitLabel.text = "溢價差 大於: "
        isHideOverDateStockLabel.text = "隱藏截止申購:"
        profitTextfield.delegate = self
        sellTextfield.delegate = self
        let halfWidth = SettingView.frame.width/2
        
        filterView.addSubview(sellPriceLabel)
        filterView.addSubview(sellTextfield)
        filterView.addSubview(profitLabel)
        filterView.addSubview(profitTextfield)
        filterView.addSubview(isHideOverDateStockLabel)
        filterView.addSubview(confirmButton)
        filterView.addSubview(separatorView)
        sellPriceLabel.anchor(titleLabel.bottomAnchor, left: filterView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: halfWidth, heightConstant: 40)
        sellTextfield.anchor(sellPriceLabel.topAnchor, left: sellPriceLabel.rightAnchor, bottom: nil, right: SettingView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: halfWidth, heightConstant: 40)
        profitLabel.anchor(sellPriceLabel.bottomAnchor, left: filterView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: halfWidth, heightConstant: 40)
        profitTextfield.anchor(profitLabel.topAnchor, left: profitLabel.rightAnchor, bottom: nil, right: SettingView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: halfWidth, heightConstant: 40)
        isHideOverDateStockLabel.anchor(profitLabel.bottomAnchor, left: profitLabel.leftAnchor, bottom: filterView.bottomAnchor, right: profitLabel.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        confirmButton.anchor(isHideOverDateStockLabel.topAnchor, left: isHideOverDateStockLabel.rightAnchor, bottom: nil , right: nil, topConstant: 5, leftConstant: halfWidth/2-12.5, bottomConstant: 0, rightConstant: 0, widthConstant: 25, heightConstant: 25)
        
        
        
        separatorView.anchor(nil, left: filterView.leftAnchor, bottom: filterView.bottomAnchor, right: filterView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true;
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        // make sure userid in legal range
         textField.text = textField.text?.return0to9()
        
    
    }
    
    
    
    
    // MARK: setupCompanyView
    
    var companyView = UIView()
    let companyLabel = TitleLabel()
    let companyHeaderLabel = HearderLabel()
    lazy var menuButton:UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(showCompany), for: .touchUpInside)
        if let company = UserDefaults.standard.object(forKey: "stockCompany") as? String {
            btn.setTitle(company, for: .normal)
        } else { btn.setTitle("請選擇", for: .normal) }
        btn.setTitleColor(UIColor.darkText, for: .normal)
        let separatorView = SeparatorView()
        btn.addSubview(separatorView)
        separatorView.anchor(nil, left: btn.leftAnchor, bottom: btn.bottomAnchor, right: btn.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        return btn
    }()
    
    
    func setupCompanyView() {
        let separatorView = SeparatorView()

        SettingView.addSubview(companyView)
        companyView.anchor(filterView.bottomAnchor, left: SettingView.leftAnchor, bottom: nil, right: SettingView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 100)
        
        companyView.addSubview(companyHeaderLabel)
        companyHeaderLabel.text = "選擇證卷商"
        companyHeaderLabel.anchor(companyView.topAnchor, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        companyHeaderLabel.anchorCenterXToSuperview()
        
        
        // company label and menu
        companyView.addSubview(menuButton)
        companyView.addSubview(separatorView)
        menuButton.anchor(companyHeaderLabel.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: halfWidth, heightConstant: 50)
        menuButton.anchorCenterXToSuperview()
        
        separatorView.anchor(nil, left: companyView.leftAnchor, bottom: companyView.bottomAnchor, right: companyView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
    }
    
    let secondBlackView = UIView()
    lazy var companyPickerView:UIPickerView = {
        let pv = UIPickerView()
        pv.dataSource = self
        pv.delegate = self
        pv.backgroundColor = UIColor.white
        pv.alpha = 0.95
        return pv
    }()
    var buttonTitle = ""
    let menuView = UIView()
    lazy var selectCompanyButton:UIButton = {
        let btn = UIButton()
        btn.setTitle("OK", for: .normal)
        btn.layer.cornerRadius = 15
        btn.clipsToBounds = true
        btn.backgroundColor = UIColor.mainBlue
        btn.addTarget(self, action: #selector(handleDismissCompany), for: .touchUpInside)
        return btn
    }()
    
    func showCompany() {
        if let window = UIApplication.shared.keyWindow {
            secondBlackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            secondBlackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismissCompany)))
            menuView.frame = CGRect(x: window.frame.width/4, y: -window.frame.height, width: window.frame.width/2, height: 300)
            menuView.backgroundColor = UIColor.white
            
            window.addSubview(secondBlackView)
            window.addSubview(menuView)
            setupCompanyPickerView()
            setupSelectedcompanyButton()
       //     window.addSubview(companyPickerView)
            secondBlackView.frame = window.frame
            secondBlackView.alpha = 0
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.secondBlackView.alpha = 1
                self.menuView.center = window.center
            }, completion: nil)
            
            
            
        }
    }
    func setupCompanyPickerView(){
        menuView.addSubview(companyPickerView)
        companyPickerView.anchor(menuView.topAnchor, left: menuView.leftAnchor, bottom: nil, right: menuView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 150)
        
    }
    func setupSelectedcompanyButton() {
        menuView.addSubview(selectCompanyButton)
        selectCompanyButton.anchor(companyPickerView.bottomAnchor, left: nil, bottom: menuView.bottomAnchor, right: nil, topConstant: 10, leftConstant: 0, bottomConstant: 10, rightConstant: 0, widthConstant: 70, heightConstant: 30)
        selectCompanyButton.anchorCenterXToSuperview()
    }
    
    
    func handleDismissCompany() {
        buttonTitle = didScrolled ? buttonTitle : "元大"
        menuButton.setTitle(buttonTitle, for: .normal)
         UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.secondBlackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.menuView.frame = CGRect(x: window.frame.width/4, y: -window.frame.height/2, width: window.frame.width/2, height: 300)
            }
            
        }) { (completed: Bool) in
            if completed {
                self.secondBlackView.removeFromSuperview()
                self.menuView.removeFromSuperview()
            }
    }
        
    }

     // MARK: setupRemindView
    
    var remindView = UIView()
    let remindHeaderLabel = HearderLabel()
    let someSwitch = UISwitch()
    let remindSwitch:UISwitch = {
        let switcher = UISwitch(frame:.zero)
        if let switchStatus = UserDefaults.standard.object(forKey: "isNeedRemind") as? Bool {
            switcher.isOn = switchStatus
        }
        else { switcher.isOn = true }
        switcher.contentMode = .scaleToFill
        return switcher
    }()
    lazy var datePicker:UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .time
        dp.locale = Locale(identifier: "zh_TW")
        
        dp.date = self.remindTime!
        return dp
    }()
    var remindTime:Date? = {
        if let storetime = UserDefaults.standard.object(forKey: "remindTime") as? Date {
         return storetime
        }
        else {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            formatter.locale = Locale(identifier: "zh_TW")
            let initialTime = formatter.date(from: "09:00")
            return initialTime
        }
    }()
    
    
    func setupRemindView() {
        let separatorView = SeparatorView()
        SettingView.addSubview(remindView)
        remindView.anchor(companyView.bottomAnchor, left: SettingView.leftAnchor, bottom: nil, right: SettingView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 140)
        
        remindView.addSubview(remindHeaderLabel)
        remindView.addSubview(remindSwitch)
        remindSwitch.addTarget(self, action: #selector(switchChange), for: .valueChanged)
        remindHeaderLabel.text = "每日提醒"
        remindHeaderLabel.anchor(remindView.topAnchor, left: remindView.leftAnchor , bottom: nil, right: nil, topConstant: 0, leftConstant: 5, bottomConstant: 0, rightConstant: 0, widthConstant: halfWidth, heightConstant: 40)
        remindSwitch.anchor(remindHeaderLabel.topAnchor, left: nil , bottom: nil, right: remindView.rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 15, widthConstant: 40, heightConstant: 40)

       
        remindView.addSubview(datePicker)
        datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        datePicker.anchor(remindHeaderLabel.bottomAnchor, left: remindView.leftAnchor, bottom: nil, right: remindView.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 90)
        
        
        remindView.addSubview(separatorView)
        separatorView.anchor(nil, left: remindView.leftAnchor, bottom: remindView.bottomAnchor, right: remindView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
    
    }
    func switchChange( switcher:UISwitch){
        
    }
    
 //   var remindTime:Date
    func datePickerChanged(datePicker:UIDatePicker) {
        // 設置要顯示在 UILabel 的日期時間格式
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
       remindTime = datePicker.date
       // myLabel.text = formatter.stringFromDate(
        //    datePicker.date)
    }
    
    
    
    
    lazy var doneButton:UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(finishSetting), for: .touchUpInside)
        btn.setTitle("完成", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.layer.cornerRadius = 20
        btn.clipsToBounds = true
        btn.backgroundColor = UIColor.mainBlue
        return btn
    }()
    
    func setupDoneButton() {
        SettingView.addSubview(doneButton)
        doneButton.anchor(remindView.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 40)
        doneButton.anchorCenterXToSuperview()
        
        
    }
    
    func finishSetting() {
   
        let userDefault = UserDefaults.standard
        
        // store the conditions
        if let sellPrice = sellTextfield.text  {
            userDefault.set(sellPrice, forKey: "sellPrice")
            userDefault.synchronize()
        }
        if let profitPrice = profitTextfield.text {
            userDefault.set(profitPrice, forKey: "profitPrice")
            userDefault.synchronize()
        }
        if let company = menuButton.currentTitle, company != "請選擇" {
        userDefault.set(company, forKey: "stockCompany")
            userDefault.synchronize()
        }
        userDefault.set(tempIshideOverDateSetting, forKey: "isHideOverDateSetting")
        let isNeedRemind = remindSwitch.isOn
        userDefault.set(isNeedRemind, forKey: "isNeedRemind")
        userDefault.synchronize()
        userDefault.set(datePicker.date, forKey: "remindTime")
        userDefault.synchronize()
        delegateController?.animateIsNeed = true
        delegateController?.handleUserSetting()
        handleDismiss()
    }
    
}

extension StockSettingLauncher : UIPickerViewDataSource, UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stockCompanies.count
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = stockCompanies[row]
        let companyTitle = NSAttributedString(string: title, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 18.0)!,NSForegroundColorAttributeName:UIColor.darkText])
        return companyTitle
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        didScrolled = true
        buttonTitle = stockCompanies[row]
       // handleDismissCompany()
    }
    
    
    
}

