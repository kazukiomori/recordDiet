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
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        let dateToolBar = toolBar
        let spacerItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let dateDoneItem = UIBarButtonItem(title: "決定", style: .done, target: self, action: #selector(timeSelect))
        dateToolBar.setItems([spacerItem, dateDoneItem], animated: true)

        timeTextField.inputView = datePicker
        timeTextField.inputAccessoryView = dateToolBar

        let menuToolBar = toolBar
        let menuDoneItem = UIBarButtonItem(title: "決定", style: .done, target: self, action: #selector(menuSelect))
        menuToolBar.setItems([spacerItem, menuDoneItem], animated: true)
        
        let calorieToolBar = toolBar
        let calorieDoneItem = UIBarButtonItem(title: "決定", style: .done, target: self, action: #selector(calorieSelect))
        calorieToolBar.setItems([spacerItem, calorieDoneItem], animated: true)
        
        calorieTextField.keyboardType = .numberPad
        
        let memoToolBar = toolBar
        let memoDoneItem = UIBarButtonItem(title: "決定", style: .done, target: self, action: #selector(memoSelect))
        memoToolBar.setItems([spacerItem, memoDoneItem], animated: true)
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
        if self.timeTextField.text == "" {
            messageAlert.shared.showErrorMessage(title: "エラー", body: "時間が設定されていません。")
            return
        }
        
        // memuTextField内の文字数が0の場合は、エラーにしたいからオプショナルチェインで50を代入
        if self.menuTextField.text?.count ?? 50 >= 50 {
            messageAlert.shared.showErrorMessage(title: "エラー", body: "メニューが設定されていません。")
            return
        }
        
        if self.calorieTextField.text == nil {
            messageAlert.shared.showErrorMessage(title: "エラー", body: "カロリーが設定されていません。")
            return
        }
        // memoTextField内の文字数が0の場合は、OKにしたいからオプショナルチェインで0を代入
        if self.memoTextField.text?.count ?? 0 >= 200 {
            messageAlert.shared.showErrorMessage(title: "エラー", body: "メモは200文字以内で入力してください。")
            return
        }
    }
}
