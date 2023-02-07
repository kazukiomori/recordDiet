//
//  Database.swift
//  recordDiet
//
//  Created by Kazuki Omori on 2023/02/04.
//

import RealmSwift

class WeightModel {
    
    // realmにデータを保存
    func addData(weight: Weight) {
        let realm = try! Realm()
        try! realm.write{
            realm.add(weight, update: .modified)
        }
    }
    // realmからデータを取得
    func getAllWeightData() -> Results<Weight> {
        let config = RealmSwift.Realm.Configuration(schemaVersion: 1)
        Realm.Configuration.defaultConfiguration = config
        let realm = try! Realm()
        var results: Results<Weight>
        results = realm.objects(Weight.self)
        return results
    }
    
    func getTheDayData(date: String) -> Weight {
        let realm = try! Realm()
        let weight = Weight()
        let result = realm.object(ofType: Weight.self, forPrimaryKey: date)
//        results = realm.objects(Weight.self).filter("dateSt == \(date)")
        if let weightResult = result {
            weight.weight = weightResult.weight
            weight.date = weightResult.date
            weight.dateSt = weightResult.dateSt
        } else {
            
        }
        return weight
    }
}
