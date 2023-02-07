//
//  WeightModel.swift
//  recordDiet
//
//  Created by Kazuki Omori on 2022/12/30.
//

import UIKit
import RealmSwift

@objcMembers
class Weight: Object {
    @objc dynamic var weight: Float = 0.0
    @objc dynamic var date: Date = NSDate() as Date
    @objc dynamic var dateSt: String = ""
    
    override static func primaryKey() -> String? {
        return "dateSt"
    }
}
