//
//  FoodListViewController.swift
//  recordDiet
//
//  Created by Kazuki Omori on 2023/02/08.
//

import UIKit
import RxSwift

class FoodListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let disposeBag = DisposeBag()
    @IBOutlet weak var addMenuButton: UIButton! {
        didSet {
            addMenuButton.rx.tap.subscribe (onNext :{ _ in
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                guard let nextViewController = storyBoard.instantiateViewController(withIdentifier: "FoodInputViewController") as? FoodInputViewController else { return }
                self.navigationController?.show(nextViewController, sender: nil)
            }).disposed(by: disposeBag)
        }
    }
    
    var date: String = ""
    
    // MARK: ライフサイクル
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = date
    }
    
    
    // MARK: TableView delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "listTableCell", for: indexPath) as? FoodListTableViewCell else { return UITableViewCell()}
        return cell
    }
}
