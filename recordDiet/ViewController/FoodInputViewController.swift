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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
