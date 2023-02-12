//
//  BodyImage.swift
//  recordDiet
//
//  Created by Kazuki Omori on 2023/02/13.
//

import UIKit
import RealmSwift

@objcMembers
class BodyImage: Object {
    @objc dynamic var date: String = ""
    @objc dynamic var imageURL: String = ""
}
