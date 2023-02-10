//
//  FoodListViewModel.swift
//  recordDiet
//
//  Created by Kazuki Omori on 2023/02/11.
//

import Foundation
import RealmSwift

class FoodListViewModel {
    
    let model = FoodListModel()
    
    // FoodListModelでrealmから取り出したデータをFoodList型の配列にしてviewに渡す
    func fetchTheDayData(date: String) -> [FoodList] {
        var foodList: [FoodList] = []
        let results = model.getTheDayData(date: date)
        for result in results {
            let food = FoodList()
            food.time = result.time
            food.menu = result.menu
            food.calorie = result.calorie
            food.memo = result.memo
            
            foodList.append(food)
        }
        return foodList
    }
    
    
    // viewで入力した値をFoodList型の変数にまとめて、FoodListModelでrealmに保存する
    func addData(time: String, menu: String, calorie: Int, memo: String){
        let food = FoodList()
        food.time = time
        food.menu = menu
        food.calorie = calorie
        food.memo = memo
        model.addData(food: food)
    }
}
