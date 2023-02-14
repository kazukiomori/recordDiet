//
//  FoodListModel.swift
//  recordDiet
//
//  Created by Kazuki Omori on 2023/02/11.
//

import RealmSwift

class FoodListModel {
    // RealmでFoodListを保存
    func addData(food: FoodList) {
        let realm = try! Realm()
        try! realm.write{
            realm.add(food)
        }
    }
    
    // RealmからFoodListを取得
    func getTheDayData(date: String) -> Results<FoodList> {
        let realm = try! Realm()
        var results: Results<FoodList>
        results = realm.objects(FoodList.self).where{($0.date == date)}
        return results
    }
}
