//
//  FoodInputViewController.swift
//  recordDiet
//
//  Created by Kazuki Omori on 2023/02/10.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

class FoodInputViewController: UIViewController {
    
    @IBOutlet weak var timeTextField: UITextField!
    
    @IBOutlet weak var menuTextField: UITextField!
    
    @IBOutlet weak var calorieTextField: UITextField!
    
    @IBOutlet weak var memoTextField: UITextField!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var saveButton: UIButton!
    
    var datePicker: UIDatePicker = UIDatePicker()
    var date: String = ""
    var foodMenu: String = ""
    
    let disposeBag = DisposeBag()
    let foodViewModel = FoodListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextField()
        buttonSet()
    }
    
    func setTextField() {
        datePicker.datePickerMode = .time
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale.current
        datePicker.maximumDate = Date()

        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        let dateToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        let spacerItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let dateDoneItem = UIBarButtonItem(title: NSLocalizedString("decision", comment: ""), style: .done, target: self, action: #selector(timeSelect))
        dateToolBar.setItems([spacerItem, dateDoneItem], animated: true)

        timeTextField.inputView = datePicker
        timeTextField.inputAccessoryView = dateToolBar

        let menuToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        let menuDoneItem = UIBarButtonItem(title: NSLocalizedString("decision", comment: ""), style: .done, target: self, action: #selector(menuSelect))
        menuToolBar.setItems([spacerItem, menuDoneItem], animated: true)
        menuTextField.inputAccessoryView = menuToolBar
        menuTextField.keyboardType = .webSearch
        
        let calorieToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        let calorieDoneItem = UIBarButtonItem(title: NSLocalizedString("decision", comment: ""), style: .done, target: self, action: #selector(calorieSelect))
        calorieToolBar.setItems([spacerItem, calorieDoneItem], animated: true)
        
        calorieTextField.inputAccessoryView = calorieToolBar
        calorieTextField.keyboardType = .numberPad
        
        let memoToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        let memoDoneItem = UIBarButtonItem(title: NSLocalizedString("decision", comment: ""), style: .done, target: self, action: #selector(memoSelect))
        memoToolBar.setItems([spacerItem, memoDoneItem], animated: true)
        
        memoTextField.inputAccessoryView = memoToolBar
        memoTextField.keyboardType = .webSearch
        
        self.inputDate(date: self.date)
    }
    
    func inputDate(date: String) {
        let food = foodViewModel.fetchTheDayFood(date: date, food: self.foodMenu)
        if foodMenu == "" {
            timeTextField.placeholder = NSLocalizedString("pleaseEnteraTime", comment: "") 
            menuTextField.placeholder = NSLocalizedString("pleaseEnteraMenu", comment: "")
            calorieTextField.placeholder = NSLocalizedString("pleaseEnteraCalorie", comment: "")
        } else {
            timeTextField.text = "\(food.time)"
            menuTextField.text = "\(food.menu)"
            calorieTextField.text = "\(food.calorie)"
        }
        
        if food.memo == "" {
            memoTextField.placeholder = NSLocalizedString("pleaseEnteraMemo", comment: "")
        } else {
            memoTextField.text = "\(food.memo)"
        }
    }
    
    /// timeTextFieldの値設定後に、datePickerの値をStringに変換してtextFieldに表示
    @objc func timeSelect() {
        timeTextField.endEditing(true)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale
        dateFormatter.timeStyle = .short
        timeTextField.text = dateFormatter.string(from: datePicker.date)
    }
    
    
    @objc func menuSelect() {
        menuTextField.endEditing(true)
    }
    
    @objc func calorieSelect() {
        calorieTextField.endEditing(true)
    }
    
    @objc func memoSelect() {
        memoTextField.endEditing(true)
    }
    
    func buttonSet() {
        self.deleteButton.rx.tap
            .subscribe(onNext: {
                self.deleteButtonTapped()
            })
            .disposed(by: disposeBag)
        
        self.saveButton.rx.tap
            .subscribe(onNext: {
                self.saveButtonTapped()
            })
            .disposed(by: disposeBag)
    }
    
    func deleteButtonTapped() {
        timeTextField.text = ""
        menuTextField.text = ""
        calorieTextField.text = ""
        memoTextField.text = ""
        self.navigationController?.popViewController(animated: false)
    }
    
    func saveButtonTapped() {
        
        guard let timeStr = self.timeTextField.text, !timeStr.isEmpty else {
            messageAlert.shared.showErrorMessage(title: NSLocalizedString("error", comment: ""), body: NSLocalizedString("timeIsNotSet", comment: ""))
            return
        }
        
        guard let menuStr = self.menuTextField.text, !menuStr.isEmpty else {
            messageAlert.shared.showErrorMessage(title: NSLocalizedString("error", comment: ""), body: NSLocalizedString("menuIsNotSet", comment: ""))
            return
        }
        if menuStr.count >= 50 {
            messageAlert.shared.showErrorMessage(title: NSLocalizedString("error", comment: ""), body: NSLocalizedString("pleaseEnterUpTo50CharactersForTheMenu", comment: ""))
            return
        }
        
        guard let calorieStr = self.calorieTextField.text, !calorieStr.isEmpty else {
            messageAlert.shared.showErrorMessage(title: NSLocalizedString("error", comment: ""), body: NSLocalizedString("calorieIsNotSet", comment: ""))
            return
        }
        var calorieNum = Int(calorieStr)!
        
       if calorieNum >= 5000 {
            messageAlert.shared.showErrorMessage(title: NSLocalizedString("setAt5000KcalOrLess", comment: ""), body: "")
            return
        }
        guard let memo = self.memoTextField.text, memo.count <= 200 else {
            messageAlert.shared.showErrorMessage(title: NSLocalizedString("error", comment: ""), body: NSLocalizedString("pleaseEnterUpTo200CharactersForTheMemo", comment: ""))
            return
        }
        
        foodViewModel.addData(time: timeStr, menu: menuStr, calorie: calorieNum, memo: memo, date: date)
        
        messageAlert.shared.showSuccessMessage(title: NSLocalizedString("success", comment: ""), body: NSLocalizedString("successfullySavedMenu", comment: ""))
        self.navigationController?.popViewController(animated: false)
    }
}
