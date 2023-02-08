//
//  FoodListViewController.swift
//  recordDiet
//
//  Created by Kazuki Omori on 2023/02/08.
//

import UIKit

class FoodListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: ライフサイクル
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: TableView delegate 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
}
