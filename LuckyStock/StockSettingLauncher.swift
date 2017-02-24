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
    let sellTextfield = NumberTextField()
    let profitTextfield = NumberTextField()
    
    var filterView = UIView()
    
    func setupFilterView(){
        let separatorView = SeparatorView()
        filterView = UIView()
        SettingView.addSubview(filterView)
        filterView.anchor(headerView.bottomAnchor, left: SettingView.leftAnchor, bottom: nil, right: SettingView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 150)
        
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
        profitTextfield.delegate = self
        sellTextfield.delegate = self
        let halfWidth = SettingView.frame.width/2
        
        
        
        
        filterView.addSubview(sellPriceLabel)
        filterView.addSubview(sellTextfield)
        filterView.addSubview(profitLabel)
        filterView.addSubview(profitTextfield)
        filterView.addSubview(separatorView)
        sellPriceLabel.anchor(titleLabel.bottomAnchor, left: filterView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: halfWidth, heightConstant: 40)
        sellTextfield.anchor(sellPriceLabel.topAnchor, left: sellPriceLabel.rightAnchor, bottom: nil, right: SettingView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: halfWidth, heightConstant: 40)
        profitLabel.anchor(sellPriceLabel.bottomAnchor, left: filterView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: halfWidth, heightConstant: 40)
        profitTextfield.anchor(profitLabel.topAnchor, left: profitLabel.rightAnchor, bottom: nil, right: SettingView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: halfWidth, heightConstant: 40)
        separatorView.anchor(nil, left: filterView.leftAnchor, bottom: filterView.bottomAnchor, right: filterView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true;
    }
    
    var companyView = UIView()
    let companyLabel = TitleLabel()
    let companyHeaderLabel = HearderLabel()
    lazy var menuButton:UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(showCompany), for: .touchUpInside)
        btn.setTitle("請選擇", for: .normal)
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
   //     companyView.addSubview(companyLabel)
        companyView.addSubview(menuButton)
        companyView.addSubview(separatorView)
//        companyLabel.text = "證券公司"
//        companyLabel.textAlignment = .center
//        companyLabel.anchor(companyHeaderLabel.bottomAnchor, left: SettingView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: halfWidth, heightConstant: 50)
        menuButton.anchor(companyHeaderLabel.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: halfWidth, heightConstant: 50)
        menuButton.anchorCenterXToSuperview()
        
        separatorView.anchor(nil, left: companyView.leftAnchor, bottom: companyView.bottomAnchor, right: companyView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
    }
    func showCompany() {
        
        
    }
    
    var remindView = UIView()
    let remindHeaderLabel = HearderLabel()
    let someSwitch = UISwitch()
    let remindSwitch:UISwitch = {
        let switcher = UISwitch(frame:.zero)
        switcher.isOn = true
        switcher.setOn(true, animated: false)
        switcher.contentMode = .scaleToFill
        return switcher
    }()
    let datePicker:UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .time
        dp.locale = Locale(identifier: "zh_TW")
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "HH:mm"
        // 可以選擇的最早日期時間
        let initialTime = formatter.date(from: "09:00")
        dp.date = initialTime!
        
        
        
        
        
        
        
        return dp
    }()
    
    
    
    func setupRemindView() {
        let separatorView = SeparatorView()
        SettingView.addSubview(remindView)
        remindView.anchor(companyView.bottomAnchor, left: SettingView.leftAnchor, bottom: nil, right: SettingView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 140)
        
        remindView.addSubview(remindHeaderLabel)
        remindView.addSubview(remindSwitch)
        remindSwitch.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)
        remindHeaderLabel.text = "每日提醒"
        remindHeaderLabel.anchor(remindView.topAnchor, left: remindView.leftAnchor , bottom: nil, right: nil, topConstant: 0, leftConstant: 5, bottomConstant: 0, rightConstant: 0, widthConstant: halfWidth, heightConstant: 40)
        remindSwitch.anchor(remindHeaderLabel.topAnchor, left: nil , bottom: nil, right: remindView.rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 15, widthConstant: 40, heightConstant: 40)

       
        remindView.addSubview(datePicker)
        datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        datePicker.anchor(remindHeaderLabel.bottomAnchor, left: remindView.leftAnchor, bottom: nil, right: remindView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 90)
        
        
        remindView.addSubview(separatorView)
        separatorView.anchor(nil, left: remindView.leftAnchor, bottom: remindView.bottomAnchor, right: remindView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
    
    }
    func switchValueDidChange(sender:UISwitch) {
        if (sender.isOn == true){
            print("on")
        }
        else{
            print("off")
        }
        
    }
    func datePickerChanged(datePicker:UIDatePicker) {
        // 設置要顯示在 UILabel 的日期時間格式
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
       
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
        doneButton.anchor(remindView.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 40)
        doneButton.anchorCenterXToSuperview()
        
        
    }
    
    func finishSetting() {
        
        
    }
    
}

extension StockSettingLauncher : UIPickerViewDataSource, UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    
    
}

