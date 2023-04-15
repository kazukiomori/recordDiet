//
//  WeightInputViewController.swift
//  recordDiet
//
//  Created by Kazuki Omori on 2022/12/28.
//

import UIKit
import RxSwift
import RxCocoa
import GoogleMobileAds

class WeightInputViewController: UIViewController {
 
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var bannerView: GADBannerView!
    var dateStValue: String = ""
    var datePicker: UIDatePicker = UIDatePicker()
    var cancelButtonItem: UIBarButtonItem!
    var addBarButtonItem: UIBarButtonItem!
    let disposeBag = DisposeBag()
    let weightVM = WeightViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItemSet()
        datePickerSet()
        
        dateTextField.rx.controlEvent(.valueChanged).asDriver()
            .drive(onNext: { _ in
                let dateStr = AppDate().dateDate(string: self.dateTextField.text!, format1: "yyyy年MM月dd日", format2: "yyyy/MM/dd")
                self.inputDate(date: dateStr)
            }).disposed(by: disposeBag)
        
        bannerView.adUnitID = "ca-app-pub-3293568654583905/4911273024"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    // datePickerで設定された日にちの体重をweightTextFieldに表示する
    func inputDate(date: String) {
        let weight = weightVM.fetchTheDayData(date: date)
        if weight == 0 {
            weightTextField.text = ""
            weightTextField.placeholder = "体重を入力してください"
        } else {
            weightTextField.text = "\(weight)"
        }
    }
    
    func navigationItemSet() {
        cancelButtonItem = UIBarButtonItem(title: "キャンセル", style: .done, target: self, action: #selector(backButtonTapped))
        cancelButtonItem.tintColor = .black
        self.navigationItem.leftBarButtonItems = [cancelButtonItem]
        
        addBarButtonItem = UIBarButtonItem(title: "保存", style: .done, target: self, action: #selector(addButtonTapped))
        addBarButtonItem.tintColor = .black
        self.navigationItem.rightBarButtonItems = [addBarButtonItem]
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func addButtonTapped() {
        let weightNum: Float
        if let weightText = weightTextField.text, let doubleWeightNum = Double(weightText) {
            weightNum = Float(doubleWeightNum)
        } else {
            weightNum = 0.0
        }
        
        if dateTextField.text == "" {
            messageAlert.shared.showErrorMessage(title: "エラー", body: "日付が入力されていません")
            return
        }
        
        if weightNum > 0 {
            let weightViewModel = WeightViewModel()
            let date =  AppDate().pickerDateStrOnlyDate(date: datePicker.date)
            let date1 = AppDate().strDate(date: date)
            weightViewModel.addData(weightData: weightNum, dateData: date1, dateStData: AppDate().dateStrOnlyDate(date: date1))
            messageAlert.shared.showSuccessMessage(title: "成功", body: "体重の保存に成功しました")
            NotificationCenter.default.post(name: .graphViewShow, object: nil)
            self.navigationController?.popViewController(animated: false)
        } else {
            messageAlert.shared.showErrorMessage(title: "エラー", body: "体重が入力されていません")
        }
    }
    
    func datePickerSet() {
        datePicker.datePickerMode = .date
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale.current
        datePicker.maximumDate = Date()
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.addTarget(self, action: #selector(changeDatePicker), for: .valueChanged)
        
        let dateToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        let spacerItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let dateDoneItem = UIBarButtonItem(title: "決定", style: .done, target: self, action: #selector(dateSelect))
        dateToolBar.setItems([spacerItem, dateDoneItem], animated: true)
        
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = dateToolBar
        
        let weightToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        let weightDoneItem = UIBarButtonItem(title: "決定", style: .done, target: self, action: #selector(weightSelect))
        weightToolBar.setItems([spacerItem, weightDoneItem], animated: true)
        
        weightTextField.inputAccessoryView = weightToolBar
        weightTextField.keyboardType = .decimalPad
        weightTextField.text = ""
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        dateTextField.text = "\(formatter.string(from: Date()))"
        
        let date = dateTextField.text!
        let dateStr = AppDate().dateDate(string: date, format1: "yyyy年MM月dd日", format2: "yyyy/MM/dd")
        self.inputDate(date: dateStr)
    }
    
    @objc func dateSelect() {
        dateTextField.endEditing(true)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        dateTextField.text = "\(formatter.string(from: datePicker.date))"
    }
    
    @objc func weightSelect() {
        weightTextField.endEditing(true)
    }
    
    @objc func changeDatePicker(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        dateTextField.text = "\(formatter.string(from: sender.date))"
        dateTextField.sendActions(for: .valueChanged)
    }
    
}
