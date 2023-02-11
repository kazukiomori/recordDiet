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
        let food = FoodList()
        var results: Results<FoodList>
        results = realm.objects(FoodList.self).filter("date == \(date)")
        return results
    }
}
