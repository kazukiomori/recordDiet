//
//  BodyImageModel.swift
//  recordDiet
//
//  Created by Kazuki Omori on 2023/02/13.
//

import RealmSwift

class BodyImageModel {
    // RealmでBodyImageを保存
    func addData(body: BodyImage) {
        let realm = try! Realm()
        try! realm.write{
            realm.add(body)
        }
    }
    
    // RealmからBodyImageを取得
    func getTheDayData(date: String) -> BodyImage {
        let realm = try! Realm()
        let body = BodyImage()
        let result = realm.object(ofType: BodyImage.self, forPrimaryKey: date)
        if let bodyResult = result {
            body.date = bodyResult.date
            body.imageData = bodyResult.imageData
        } else {
            
        }
        return body
    }
}
