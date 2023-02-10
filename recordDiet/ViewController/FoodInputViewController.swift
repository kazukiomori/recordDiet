//
//  FoodInputViewController.swift
//  recordDiet
//
//  Created by Kazuki Omori on 2023/02/10.
//

import UIKit
import RxSwift
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//    func datePickerSet() {
//        datePicker.datePickerMode = .date
//        datePicker.timeZone = NSTimeZone.local
//        datePicker.locale = Locale.current
//        datePicker.maximumDate = Date()
//
//        if #available(iOS 13.4, *) {
//            datePicker.preferredDatePickerStyle = .wheels
//        }
//        datePicker.addTarget(self, action: #selector(changeDatePicker), for: .valueChanged)
//
//        let dateToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
//        let spacerItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
//        let dateDoneItem = UIBarButtonItem(title: "決定", style: .done, target: self, action: #selector(dateSelect))
//        dateToolBar.setItems([spacerItem, dateDoneItem], animated: true)
//
//        timeTextField.inputView = datePicker
//        timeTextField.inputAccessoryView = dateToolBar
//
//        let weightToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
//        let weightDoneItem = UIBarButtonItem(title: "決定", style: .done, target: self, action: #selector(weightSelect))
//        weightToolBar.setItems([spacerItem, weightDoneItem], animated: true)
//
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy年MM月dd日"
//        timeTextField.text = "\(formatter.string(from: Date()))"
//
//        let date = timeTextField.text!
//        let dateStr = AppDate().dateDate(string: date, format1: "yyyy年MM月dd日", format2: "yyyy/MM/dd")
//        self.inputDate(date: dateStr)
//
//    }
}
