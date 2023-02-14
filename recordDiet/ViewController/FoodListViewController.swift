//
//  FoodListViewController.swift
//  recordDiet
//
//  Created by Kazuki Omori on 2023/02/08.
//

import UIKit
import RxSwift
import RealmSwift

class FoodListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var addMenuButton: UIButton! {
        didSet {
            addMenuButton.rx.tap.subscribe (onNext :{ _ in
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                guard let nextViewController = storyBoard.instantiateViewController(withIdentifier: "FoodInputViewController") as? FoodInputViewController else { return }
                nextViewController.date = self.date
                self.navigationController?.show(nextViewController, sender: nil)
            }).disposed(by: disposeBag)
        }
    }
    
    @IBOutlet weak var addImageButton: UIButton!{
        didSet {
            addImageButton.rx.tap.subscribe (onNext :{ _ in
                self.addImageAction()
            }).disposed(by: disposeBag)
        }
    }
    
    var date: String = ""
    var addBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var bodyImageView: UIImageView!
    var bodyImage = BodyImageViewModel()
    var foodList = FoodListViewModel()
    @IBOutlet weak var foodTableView: UITableView!
    var theDayOfAllFoodList: [FoodList] = []
    
    // MARK: ライフサイクル
    override func viewDidLoad() {
        super.viewDidLoad()
        self.foodTableView.delegate = self
        self.foodTableView.dataSource = self
        self.setView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataLoad()
    }
    
    // MARK: メソッド
    func addImageAction() {
        let imagePicker = UIImagePickerController()
        // imagePicker.sourceType = .camera はシミュレーターでは使えない
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    func setView() {
        self.bodyImageView.image = self.bodyImage.fetchTheDayData(date: date)
        self.navigationItemSet()
    }
    
    func navigationItemSet() {
        navigationItem.title = date
        addBarButtonItem = UIBarButtonItem(title: "保存", style: .done, target: self, action: #selector(addButtonTapped))
        addBarButtonItem.tintColor = .black
        self.navigationItem.rightBarButtonItems = [addBarButtonItem]
    }
    
    func dataLoad() {
        let allfoodList = foodList.fetchTheDayData(date: date)
        self.theDayOfAllFoodList = allfoodList.sorted(by:{ $0.time < $1.time })
        self.foodTableView.reloadData()
    }
    
    @objc func addButtonTapped() {
        if bodyImageView.image != nil {
            self.bodyImage.addData(date: date, image: bodyImageView.image!)
            messageAlert.shared.showSuccessMessage(title: "成功", body: "体の写真の保存に成功しました")
            self.navigationController?.popViewController(animated: false)
        } else {
            messageAlert.shared.showErrorMessage(title: "エラー", body: "画像が設定されていません。")
            return
        }
    }

    
    // MARK: TableView delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return theDayOfAllFoodList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "listTableCell", for: indexPath) as? FoodListTableViewCell else { return UITableViewCell()}
        cell.timeLabel.text = theDayOfAllFoodList[indexPath.row].time
        cell.menuLabel.text = theDayOfAllFoodList[indexPath.row].menu
        cell.calorieLabel.text = String(theDayOfAllFoodList[indexPath.row].calorie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func imagePickerController(_ imagePicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            bodyImageView.image = pickedImage
        }
        dismiss(animated: false)
    }
}
