//
//  FoodList.swift
//  recordDiet
//
//  Created by Kazuki Omori on 2023/02/10.
//

import UIKit
import RealmSwift

@objcMembers
class FoodList: Object {
    @objc dynamic var date: String = ""
    @objc dynamic var time: String = ""
    @objc dynamic var menu: String = ""
    @objc dynamic var calorie: String = ""
    @objc dynamic var memo: String = ""
    
}
